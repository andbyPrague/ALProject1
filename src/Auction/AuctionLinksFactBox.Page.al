page 50162 "Auction Links FactBox"
{
    PageType = CardPart;
    SourceTable = "Auction Tmp";
    Caption = 'Auction Links';

    layout
    {
        area(Content)
        {
            group(Links)
            {
                Caption = 'Quick Links';
                field(URLLink; Rec.URL)
                {
                    ApplicationArea = All;
                    Caption = 'Auction URL';
                    ToolTip = 'Click to open the auction in your browser';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        if Rec.URL <> '' then
                            Hyperlink(Rec.URL);
                    end;
                }
                field("Last Updated"; Rec."Last Updated")
                {
                    ApplicationArea = All;
                    Caption = 'Last Update';
                    StyleExpr = UpdateStyle;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field(UpdateAge; GetUpdateAge())
                {
                    ApplicationArea = All;
                    Caption = 'Data Age';
                    Editable = false;
                }
            }
        }
    }

    var
        UpdateStyle: Text;

    trigger OnAfterGetRecord()
    var
        TimeSinceUpdate: Duration;
    begin
        TimeSinceUpdate := CurrentDateTime - Rec."Last Updated";
        if TimeSinceUpdate > 3600000 then // More than 1 hour
            UpdateStyle := 'Unfavorable'
        else
            UpdateStyle := 'Favorable';
    end;

    local procedure GetUpdateAge(): Text
    var
        TimeSinceUpdate: Duration;
    begin
        if Rec."Last Updated" = 0DT then
            exit('Not updated');

        TimeSinceUpdate := CurrentDateTime - Rec."Last Updated";
        if TimeSinceUpdate < 60000 then // Less than 1 minute
            exit('Just now');
        if TimeSinceUpdate < 3600000 then // Less than 1 hour
            exit(Format(Round(TimeSinceUpdate / 60000, 1, '<')) + ' minutes ago');
        if TimeSinceUpdate < 86400000 then // Less than 1 day
            exit(Format(Round(TimeSinceUpdate / 3600000, 1, '<')) + ' hours ago');

        exit(Format(Round(TimeSinceUpdate / 86400000, 1, '<')) + ' days ago');
    end;
}