codeunit 50154 MyCodeunit

{
    // SingleInstance = true;


    trigger OnRun()
    begin

    end;

    procedure RecordsChabge(Order: Record Order): Integer
    var
        myInt: Integer;
    begin

        Order.SetRange(Order_id, 2, 10);
        if Order.FindSet(true) then
            repeat
                Order.Products := 'harrdcode';
            until Order.Next() = 0;
        Order.ModifyAll(Order.Order_id, 2, true);

    end;

    procedure Setter(LInteger: Integer)
    var
        myInt: Integer;
    begin
        Int := LInteger;

    end;

    procedure Getter()
    begin
        Message(Format(Int));
    end;

    var
        Int: Integer;
}