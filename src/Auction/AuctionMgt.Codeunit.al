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

            if JsonObject.Get('zakladniInformace', BasicInfoToken) then
                BasicInfoObject := BasicInfoToken.AsObject();

            AuctionTmp.Init();


            if BasicInfoObject.Get('cisloDrazby', TempToken) then
                AuctionTmp."Auction Number" := CopyStr(TempToken.AsValue().AsText(), 1, 20);

            if BasicInfoObject.Get('formaDrazby', TempToken) then
                AuctionTmp."Internal Note" := CopyStr(TempToken.AsValue().AsText(), 1, 5);

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


    local procedure GetJsonValue(var JsonObject: JsonObject; TokenPath: Text; var ReturnToken: JsonToken): Boolean
    begin
        exit(JsonObject.Get(TokenPath, ReturnToken));
    end;

}
