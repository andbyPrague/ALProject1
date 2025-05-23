table 50156 Product
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product id"; Integer)
        {
            Caption = 'Product ID';
            DataClassification = ToBeClassified;

        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; Price; Decimal)
        {
            Caption = ' Price';
            DataClassification = ToBeClassified;
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(key1; "product ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}