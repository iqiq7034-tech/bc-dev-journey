table 50100 "User API data"
{
    DataClassification = CustomerContent;
    Caption = 'User API Data';

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Email; Text[100])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        }
        field(4; Phone; Text[50])
        {
            Caption = 'Phone';
            DataClassification = CustomerContent;
        }
        field(5; CompanyName; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(6; LastStatus; Text[50])
        {
            Caption = 'Last Status';
            DataClassification = CustomerContent;
        }
        field(7; LastMethod; Text[20])
        {
            Caption = 'Last Method';
            DataClassification = CustomerContent;
        }
        field(8; LastMessage; Text[250])
        {
            Caption = 'Last Message';
            DataClassification = CustomerContent;
        }
        field(9; LastSyncDateTime; DateTime)
        {
            Caption = 'Last Synced';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; ID) { Clustered = true; }
    }
}



