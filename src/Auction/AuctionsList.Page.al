page 50152 "Auctions List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Auction Tmp";
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
                }
                field("Internal Note"; Rec."Internal Note")
                {
                    ApplicationArea = All;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
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