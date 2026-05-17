page 50106 "Webhook Receiver"
{
    // ── This page IS the webhook endpoint ────────────
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'cronus';
    APIGroup = 'webhooks';
    EntityName = 'webhookNotification';
    EntitySetName = 'webhookNotifications';
    DelayedInsert = true;  // we want to control when the record is inserted (after processing the notification)

    SourceTable = "Webhook Log";
    ODataKeyFields = EntryNo;
    InsertAllowed = true;   // allows POST from external system
    ModifyAllowed = false;
    DeleteAllowed = false;

    Caption = 'Webhook Receiver';

    layout
    {
        area(Content)
        {
            repeater(Notifications)
            {
                field(entryNo; Rec.EntryNo)
                { Caption = 'entryNo'; }

                field(receivedAt; Rec.ReceivedAt)
                { Caption = 'receivedAt'; }

                field(eventType; Rec.EventType)
                { Caption = 'eventType'; }

                field(resourceType; Rec.ResourceType)
                { Caption = 'resourceType'; }

                field(resourceId; Rec.ResourceId)
                { Caption = 'resourceId'; }

                field(payload; Rec.Payload)
                { Caption = 'payload'; }

                field(processed; Rec.Processed)
                { Caption = 'processed'; }

                field(clientState; Rec.ClientState)
                { Caption = 'clientState'; }
            }
        }
    }

    // ── Fires when external system POSTs a notification
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        WebhookMgmt: Codeunit "Webhook Manager";
    begin
        // Set received timestamp
        Rec.ReceivedAt := CurrentDateTime();

        // Process the incoming notification
        WebhookMgmt.ProcessIncomingNotification(Rec);

        exit(true);
    end;
}