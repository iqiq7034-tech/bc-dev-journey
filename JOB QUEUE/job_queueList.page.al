page 50108 "Job Queue Log List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Queue Log";
    Caption = 'Job Queue Run Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LogLines)
            {
                field(EntryNo; Rec.EntryNo)
                { ApplicationArea = All; Caption = 'No.'; }

                field(RunDateTime; Rec.RunDateTime)
                { ApplicationArea = All; Caption = 'Started At'; }

                field(JobName; Rec.JobName)
                { ApplicationArea = All; Caption = 'Job Name'; }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    StyleExpr = StatusStyle;
                }

                field(RecordsSynced; Rec.RecordsSynced)
                { ApplicationArea = All; Caption = 'Records Synced'; }

                field(DurationSeconds; Rec.DurationSeconds)
                { ApplicationArea = All; Caption = 'Duration (sec)'; }

                field(FinishedAt; Rec.FinishedAt)
                { ApplicationArea = All; Caption = 'Finished At'; }

                field(ErrorMessage; Rec.ErrorMessage)
                { ApplicationArea = All; Caption = 'Error'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunNow)
            {
                Caption = 'Run Nightly Sync Now';
                ApplicationArea = All;
                Image = Start;
                ToolTip = 'Run the nightly sync immediately for testing.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NightlySync: Codeunit "Nightly API Sync";
                begin
                    NightlySync.Run();
                    CurrPage.Update();
                    Message('Nightly sync completed! Check log above.');
                end;
            }

            action(RunExchangeRates)
            {
                Caption = 'Sync Exchange Rates';
                ApplicationArea = All;
                Image = Currency;
                ToolTip = 'Run exchange rate sync only.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NightlySync: Codeunit "Nightly API Sync";
                begin
                    NightlySync.SyncExchangeRates();
                    CurrPage.Update();
                end;
            }

            action(RunUserSync)
            {
                Caption = 'Sync API Users';
                ApplicationArea = All;
                Image = User;
                ToolTip = 'Run user sync from JSONPlaceholder.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NightlySync: Codeunit "Nightly API Sync";
                begin
                    NightlySync.SyncAPIUsers();
                    CurrPage.Update();
                end;
            }

            action(ClearLog)
            {
                Caption = 'Clear Log';
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JobLog: Record "Job Queue Log";
                begin
                    if Confirm('Clear all job queue logs?', false) then begin
                        JobLog.DeleteAll();
                        Message('Log cleared.');
                    end;
                end;
            }

            action(SetupJobQueue)
            {
                Caption = 'Open Job Queue Entries';
                ApplicationArea = All;
                Image = Calendar;
                ToolTip = 'Open BC Job Queue Entries to schedule this codeunit.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Page.Run(Page::"Job Queue Entries");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Success:
                StatusStyle := 'Favorable';
            Rec.Status::Failed:
                StatusStyle := 'Unfavorable';
            Rec.Status::Started:
                StatusStyle := 'Ambiguous';
        end;
    end;
}
