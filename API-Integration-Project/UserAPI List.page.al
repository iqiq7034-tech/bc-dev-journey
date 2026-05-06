page 50101 "User API List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "User API data";
    Caption = 'Stored API Users';
    CardPageId = "User API Card";
    Editable = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(UserLines)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    DrillDown = true;
                    DrillDownPageId = "User API Card";
                    trigger OnDrillDown()
                    var
                        UserAPICard: Page "User API Card";
                    begin
                        UserAPICard.LoadRecord(Rec);           // Pass current record data
                        UserAPICard.RunModal();                 // Open card
                        CurrPage.Update();                      // Refresh list after close
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                }
                field(Phone; Rec.Phone)
                {
                    ApplicationArea = All;
                    Caption = 'Phone';
                }
                field(CompanyName; Rec.CompanyName)
                {
                    ApplicationArea = All;
                    Caption = 'Company';
                }
                field(LastMethod; Rec.LastMethod)
                {
                    ApplicationArea = All;
                    Caption = 'Last method';
                }
                field(LastStatus; Rec.LastStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field(LastSyncDateTime; Rec.LastSyncDateTime)
                {
                    ApplicationArea = All;
                    Caption = 'Last Synced';
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchAll)
            {
                Caption = 'Fetch All Users (1-10)';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Fetch all 10 users from API and store them.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    UserApICard: Page "User API Card";
                begin
                    UserApICard.FetchAllAndStore();
                    CurrPage.Update();
                    Message('All users fetched and stored successfully!');
                end;
            }

            action(ClearAll)
            {
                Caption = 'Clear All Records';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete all stored user records.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UserAPIData: Record "User API Data";
                begin
                    if Confirm('Are you sure you want to delete all stored users?', false) then begin
                        UserAPIData.DeleteAll();
                        Message('All records cleared.');
                    end;
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    begin
        exit(true);
    end;


}