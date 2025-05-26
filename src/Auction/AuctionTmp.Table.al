table 50110 Auction
{
    Caption = 'Auction';

    fields
    {
        field(1; "Auction Number"; Code[20])
        {
            Caption = 'Auction Number';
        }
        field(2; "Internal Note"; Text[100])
        {
            Caption = 'Internal Note';
        }
        field(3; URL; Text[2048])
        {
            Caption = 'URL';
        }
        field(4; "Last Updated"; DateTime)
        {
            Caption = 'Last Updated';
        }
    }

    keys
    {
        key(Key1; "Auction Number")
        {
            Clustered = true;
        }
    }
}