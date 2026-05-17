table 50105 "Webhook Log"
{
    Caption = 'Webhook Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; ReceivedAt; DateTime)
        {
            Caption = 'Received At';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; EventType; Option)
        {
            Caption = 'Event Type';
            DataClassification = CustomerContent;
            OptionMembers = created,updated,deleted;
        }
        field(4; ResourceType; Text[100])
        {
            Caption = 'Resource Type';
            DataClassification = CustomerContent;
            // customers · orders · items
        }
        field(5; ResourceId; Text[100])
        {
            Caption = 'Resource ID';
            DataClassification = CustomerContent;
        }
        field(6; Payload; Text[2048])
        {
            Caption = 'Raw Payload';
            DataClassification = CustomerContent;
        }
        field(7; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(8; ProcessedAt; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; ClientState; Text[100])
        {
            Caption = 'Client State';
            DataClassification = CustomerContent;
        }
        field(10; Source; Text[100])
        {
            Caption = 'Source System';
            DataClassification = CustomerContent;
            // Shopify · GitHub · Custom
        }
        field(11; ErrorMessage; Text[500])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EntryNo) { Clustered = true; }
        key(ByDate; ReceivedAt) { }
        key(ByType; EventType, ResourceType) { }
    }
}