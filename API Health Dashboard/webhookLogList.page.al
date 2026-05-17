page 50107 "Webhook Log List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Webhook Log";
    Caption = 'Webhook Notifications Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LogLines)
            {
                field(EntryNo; Rec.EntryNo)
                { ApplicationArea = All; Caption = 'No.'; }

                field(ReceivedAt; Rec.ReceivedAt)
                { ApplicationArea = All; Caption = 'Received'; }

                field(Source; Rec.Source)
                { ApplicationArea = All; Caption = 'Source'; }

                field(EventType; Rec.EventType)
                { ApplicationArea = All; Caption = 'Event'; }

                field(ResourceType; Rec.ResourceType)
                { ApplicationArea = All; Caption = 'Resource'; }

                field(ResourceId; Rec.ResourceId)
                { ApplicationArea = All; Caption = 'Resource ID'; }

                field(Processed; Rec.Processed)
                { ApplicationArea = All; Caption = 'Processed'; }

                field(ProcessedAt; Rec.ProcessedAt)
                { ApplicationArea = All; Caption = 'Processed At'; }

                field(ErrorMessage; Rec.ErrorMessage)
                { ApplicationArea = All; Caption = 'Error'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewPayload)
            {
                Caption = 'View Raw Payload';
                ApplicationArea = All;
                Image = View;
                ToolTip = 'Show the raw JSON payload of this notification.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Message('Raw Payload:\n\n%1', Rec.Payload);
                end;
            }

            action(MarkProcessed)
            {
                Caption = 'Mark as Processed';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Processed := true;
                    Rec.ProcessedAt := CurrentDateTime();
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action(ClearLog)
            {
                Caption = 'Clear All Logs';
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    WebhookLog: Record "Webhook Log";
                begin
                    if Confirm(
                        'Delete all webhook log entries?', false) then begin
                        WebhookLog.DeleteAll();
                        Message('All webhook logs cleared.');
                    end;
                end;
            }

            action(SimulateWebhook)
            {
                Caption = 'Simulate Webhook';
                ApplicationArea = All;
                Image = TestFile;
                ToolTip = 'Simulate receiving a webhook notification for testing.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    WebhookMgmt: Codeunit "Webhook Manager";
                begin
                    WebhookMgmt.SimulateIncomingWebhook();
                    CurrPage.Update();
                    Message('Simulated webhook notification created!');
                end;
            }
        }
    }
}