page 50110 "Auction Card"
{
    PageType = Card;
    SourceTable = "Auction Tmp";
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Auction Details';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Auction Number"; Rec."Auction Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the auction number';
                    Importance = Promoted;
                    Editable = false;
                }
                field("Internal Note"; Rec."Internal Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Random field';
                    MultiLine = true;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'URL where you can find more details about the auction. Click to open in your browser';
                    Editable = false;
                    ExtendedDatatype = URL;

                    trigger OnDrillDown()
                    begin
                        if Rec.URL <> '' then
                            Hyperlink(Rec.URL);
                    end;
                }
                field("Last Updated"; Rec."Last Updated")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the auction information was last updated from the source';
                    Editable = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(Links; "Auction Links FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Auction Number" = FIELD("Auction Number");
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
                PromotedIsBig = true;
                ToolTip = 'Refresh the auction data from the source';

                trigger OnAction()
                var
                    AuctionMgt: Codeunit "Auction Management";
                begin
                    AuctionMgt.LoadAuctionData();
                    CurrPage.Update(false);
                end;
            }
            action(OpenURL)
            {
                ApplicationArea = All;
                Caption = 'Open Auction URL';
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Opens the auction URL in your browser';

                trigger OnAction()
                begin
                    if Rec.URL <> '' then
                        Hyperlink(Rec.URL);
                end;
            }
        }
        area(Navigation)
        {
            action(AuctionsList)
            {
                ApplicationArea = All;
                Caption = 'Auctions List';
                Image = List;
                RunObject = Page "Auctions List";
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Go back to the auctions list';
            }
        }
    }
}