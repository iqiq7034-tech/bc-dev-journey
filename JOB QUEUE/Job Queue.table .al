table 50106 "Job Queue Log"
{
    Caption = 'Job Queue Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; RunDateTime; DateTime)
        {
            Caption = 'Run Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; JobName; Text[100])
        {
            Caption = 'Job Name';
            DataClassification = CustomerContent;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Started,Success,Failed;
            DataClassification = CustomerContent;
        }
        field(5; RecordsSynced; Integer)
        {
            Caption = 'Records Synced';
            DataClassification = CustomerContent;
        }
        field(6; DurationSeconds; Decimal)
        {
            Caption = 'Duration (sec)';
            DataClassification = CustomerContent;
        }
        field(7; ErrorMessage; Text[500])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(8; FinishedAt; DateTime)
        {
            Caption = 'Finished At';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; EntryNo) { Clustered = true; }
        key(ByDate; RunDateTime) { }
    }
}
