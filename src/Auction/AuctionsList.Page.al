page 50112 "Auctions List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Auction;
    Caption = 'Auctions';
    CardPageId = "Auction Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Auction Number"; Rec."Auction Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the auction number.';
                }
                field("Internal Note"; Rec."Internal Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any internal notes or comments about the auction.';
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the URL where you can find more details about the auction. Click to open in your browser.';

                    trigger OnDrillDown()
                    begin
                        if Rec.URL <> '' then
                            Hyperlink(Rec.URL);
                    end;
                }
                field("Last Updated"; Rec."Last Updated")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the auction information was last updated from the source.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshData)
            {
                ApplicationArea = All;
                Caption = 'Refresh Data';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Refresh the auction data from the source';

                trigger OnAction()
                var
                    AuctionMgt: Codeunit "Auction Management";
                begin
                    AuctionMgt.LoadAuctionData();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AuctionMgt: Codeunit "Auction Management";
    begin
        AuctionMgt.LoadAuctionData();
        LoadAuctionDataAsync();
    end;

    local procedure LoadAuctionDataAsync()
    begin
        if TaskScheduler.CanCreateTask then
            TaskScheduler.CreateTask(Codeunit::"Auction Management", Codeunit::"Auction Management", true);
    end;

}