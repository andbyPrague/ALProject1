table 50157 Order
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Order_id; Integer)
        {
            Caption = 'Order ID';
            DataClassification = ToBeClassified;

        }
        field(2; Created_at; date)
        {
            Caption = 'Created at';
            DataClassification = ToBeClassified;
        }
        field(3; Status; option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = in_process,sent,received;
            OptionCaption = 'In Process, Sent, Delivered';

        }
        field(4; Products; Text[50])
        {
            Caption = 'Products';
            DataClassification = ToBeClassified;
            TableRelation = Product;
        }
    }

    keys
    {
        key(Key1; Order_id)
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