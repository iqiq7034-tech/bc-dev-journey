table 50107 "API Health Log"
{
    Caption = 'API Health Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; CheckedAt; DateTime)
        {
            Caption = 'Checked At';
            DataClassification = CustomerContent;
        }
        field(3; EndpointUrl; Text[250])
        {
            Caption = 'Endpoint URL';
            DataClassification = CustomerContent;
        }
        field(4; StatusCode; Integer)
        {
            Caption = 'HTTP Status Code';
            DataClassification = CustomerContent;
        }
        field(5; IsHealthy; Boolean)
        {
            Caption = 'Is Healthy';
            DataClassification = CustomerContent;
        }
        field(6; ResponseTimeMs; Integer)
        {
            Caption = 'Response Time (ms)';
            DataClassification = CustomerContent;
        }
        field(7; ErrorMessage; Text[500])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EntryNo) { Clustered = true; }
        key(ByDate; CheckedAt) { }
    }
}