codeunit 50110 "Auction Management"
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
        Auction: Record Auction;
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
        Clear(Auction);
        Auction.DeleteAll();

        // Step 4: Process each auction record from the JSON array
        foreach JsonToken in JsonArray do begin
            JsonObject := JsonToken.AsObject();

            // Get the basic information object which contains auction details
            if JsonObject.Get('zakladniInformace', BasicInfoToken) then
                BasicInfoObject := BasicInfoToken.AsObject();

            Auction.Init();

            // Extract auction number 
            if BasicInfoObject.Get('cisloDrazby', TempToken) then
                Auction."Auction Number" := CopyStr(TempToken.AsValue().AsText(), 1, 20);

            // Extract auction form as internal note
            if BasicInfoObject.Get('formaDrazby', TempToken) then
                Auction."Internal Note" := CopyStr(TempToken.AsValue().AsText(), 1, 5);

            // Extract auction URL from the JSON  object
            if BasicInfoObject.Get('konaniDrazby', TempToken) then begin
                BasicInfoObject := TempToken.AsObject();
                if BasicInfoObject.Get('url', TempToken) then
                    Auction.URL := CopyStr(TempToken.AsValue().AsText(), 1, 2048);
            end;

            // Set the last updated Auction."Last Updated
            Auction."Last Updated" := CurrentDateTime;

            // Insert or modify the auction record
            if Auction."Auction Number" <> '' then begin
                if Auction.Get(Auction."Auction Number") then
                    Auction.Modify()
                else
                    Auction.Insert();
            end;
        end;
    end;
}
