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
        // Step 1: Fetch data from the external API
        if not Client.Get('https://cevd.gov.cz/opendata/drazby/drazby_2025.json', Response) then
            Error('Failed to connect to the service.');

        if not Response.IsSuccessStatusCode then
            Error('Error appeared: %1', Response.HttpStatusCode);

        Response.Content.ReadAs(JsonText);

        // Step 2: Parse and validate JSON response
        if not JsonToken.ReadFrom(JsonText) then
            Error('Invalid JSON response.');

        JsonArray := JsonToken.AsArray();

        // Step 3: Clear existing temporary data
        Clear(AuctionTmp);
        AuctionTmp.DeleteAll();

        // Step 4: Process each auction record from the JSON array
        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            // Get the basic information object which contains auction details
            if JsonObject.Get('zakladniInformace', BasicInfoToken) then
                BasicInfoObject := BasicInfoToken.AsObject();

            AuctionTmp.Init();

            // Extract auction number 
            if BasicInfoObject.Get('cisloDrazby', TempToken) then
                AuctionTmp."Auction Number" := CopyStr(TempToken.AsValue().AsText(), 1, 20);

            // Extract auction form as internal note
            if BasicInfoObject.Get('formaDrazby', TempToken) then
                AuctionTmp."Internal Note" := CopyStr(TempToken.AsValue().AsText(), 1, 5);

            // Extract auction URL from the JSON  object
            if BasicInfoObject.Get('konaniDrazby', TempToken) then begin
                BasicInfoObject := TempToken.AsObject();
                if BasicInfoObject.Get('url', TempToken) then
                    AuctionTmp.URL := CopyStr(TempToken.AsValue().AsText(), 1, 2048);
            end;

            // Set the last updated AuctionTmp."Last Updated
            AuctionTmp."Last Updated" := CurrentDateTime;

            // Insert or modify the auction record
            if AuctionTmp."Auction Number" <> '' then begin
                if AuctionTmp.Get(AuctionTmp."Auction Number") then
                    AuctionTmp.Modify()
                else
                    AuctionTmp.Insert();
            end;
        end;
    end;
}
