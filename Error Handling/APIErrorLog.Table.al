table 50101 "API Error Log"
{
    Caption = 'API Error Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; LogDateTime; DateTime)
        {
            Caption = 'Date Time';
            DataClassification = CustomerContent;
        }
        field(3; Method; Text[10])
        {
            Caption = 'Method';
            DataClassification = CustomerContent;
        }
        field(4; Url; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
        }
        field(5; StatusCode; Text[10])
        {
            Caption = 'Status Code';
            DataClassification = CustomerContent;
        }
        field(6; StatusMessage; Text[250])
        {
            Caption = 'Status Message';
            DataClassification = CustomerContent;
        }
        field(7; Success; Boolean)
        {
            Caption = 'Success';
            DataClassification = CustomerContent;
        }
        field(8; ErrorDetails; Text[500])
        {
            Caption = 'Error Details';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EntryNo) { Clustered = true; }
    }
}