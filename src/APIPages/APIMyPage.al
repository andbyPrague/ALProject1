page 50158 APIPage
{
    PageType = API;
    Caption = 'test';
    APIPublisher = 'admin';
    APIGroup = 'groupName';
    APIVersion = 'v1.0';
    EntityName = 'test';
    EntitySetName = 'tests';
    SourceTable = MyTable;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec.ID)
                {
                    Caption = 'ID';

                }
                field(Name; Rec.Name)
                {
                }
            }
        }
    }
}