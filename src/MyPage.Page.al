page 50105 MyPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = MyTable;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec.ID)
                {

                }
                field(Name; Rec.Name)
                {
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        MyCodeunit.Getter();
    end;

    trigger OnInit()
    var
        myInt: Integer;
    begin
        MyCodeunit.Setter(5);

    end;

    var
        MyCodeunit: Codeunit MyCodeunit;
}