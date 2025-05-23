codeunit 50151 "Auction Management"
{
    procedure LoadAuctionData()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonText: Text;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        BasicInfoToken: JsonToken;
        BasicInfoObject: JsonObject;
        TempToken: JsonToken;
        AuctionTmp: Record "Auction Tmp";
    begin
        if not Client.Get('https://cevd.gov.cz/opendata/drazby/drazby_2025.json', Response) then
            Error('Failed to connect to the service.');

        if not Response.IsSuccessStatusCode then
            Error('Error appeared: %1', Response.HttpStatusCode);

        Response.Content.ReadAs(JsonText);

        if not JsonToken.ReadFrom(JsonText) then
            Error('Invalid JSON response.');

        JsonArray := JsonToken.AsArray();

        Clear(AuctionTmp);
        AuctionTmp.DeleteAll();

        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            if JsonObject.Get('zakladniInformace', BasicInfoToken) then begin
                BasicInfoObject := BasicInfoToken.AsObject();

                AuctionTmp.Init();

                if BasicInfoObject.Get('cisloDrazby', TempToken) then
                    AuctionTmp."Auction Number" := CopyStr(TempToken.AsValue().AsText(), 1, 20);

                if JsonObject.Get('adresa', BasicInfoToken) then begin
                    BasicInfoObject := BasicInfoToken.AsObject();
                    if JsonObject.Get('ulice', TempToken) then begin
                        AuctionTmp."Internal Note" := CopyStr(TempToken.AsValue().AsText(), 1, 100);
                    end;

                end;

                if BasicInfoObject.Get('konaniDrazby', TempToken) then begin
                    BasicInfoObject := TempToken.AsObject();
                    if BasicInfoObject.Get('url', TempToken) then
                        AuctionTmp.URL := CopyStr(TempToken.AsValue().AsText(), 1, 2048);
                end;

                AuctionTmp."Last Updated" := CurrentDateTime;

                if AuctionTmp."Auction Number" <> '' then begin
                    if AuctionTmp.Get(AuctionTmp."Auction Number") then
                        AuctionTmp.Modify()
                    else
                        AuctionTmp.Insert();
                end;
            end;
        end;
    end;

    local procedure ProcessJsonArray(JsonToken: JsonToken; var AuctionTmp: Record "Auction Tmp")
    var
        JsonArray: JsonArray;
        ArrayToken: JsonToken;
        JsonObject: JsonObject;
        BasicInfoToken: JsonToken;
        AuctionInfoObject: JsonObject;
        TempToken: JsonToken;
    begin
        if not JsonToken.IsArray then
            exit;

        JsonArray := JsonToken.AsArray();
        foreach ArrayToken in JsonArray do begin
            if not ArrayToken.IsObject then
                exit;

            JsonObject := ArrayToken.AsObject();
            if not JsonObject.Get('zakladniInformace', BasicInfoToken) then
                exit;

            AuctionInfoObject := BasicInfoToken.AsObject();
            AuctionTmp.Init();


            if GetJsonValue(AuctionInfoObject, 'cisloDrazby', TempToken) then
                AuctionTmp."Auction Number" := CopyStr(TempToken.AsValue().AsText(), 1, 20);


            if GetJsonValue(JsonObject, 'url', TempToken) then
                AuctionTmp.URL := CopyStr(TempToken.AsValue().AsText(), 1, 2048);
        end;


        if GetJsonValue(JsonObject, 'udajeProUhraduCeny', TempToken) then
            AuctionTmp."Internal Note" := CopyStr(TempToken.AsValue().AsText(), 1, 100);

        AuctionTmp."Last Updated" := CurrentDateTime;

        if AuctionTmp.Get(AuctionTmp."Auction Number") then
            AuctionTmp.Modify()
        else
            AuctionTmp.Insert();
    end;

    local procedure GetJsonValue(var JsonObject: JsonObject; TokenPath: Text; var ReturnToken: JsonToken): Boolean
    begin
        exit(JsonObject.Get(TokenPath, ReturnToken));
    end;

}
