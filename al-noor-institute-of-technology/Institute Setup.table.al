table 50120 "Institute Setup"
{
    Caption = 'Institute Setup';
    DataClassification = CustomerContent;
    DataPerCompany = true; // each company has its own setup

    fields
    {
        // Primary key is always blank for setup tables
        // because there is only ONE setup record
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }

        field(2; "Institute Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Institute Name';
            NotBlank = true; // institute name is mandatory
        }

        field(3; "Student No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No. Series';
            TableRelation = "No. Series"; // must be a valid No. Series
        }

        field(4; "Course No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No. Series';
            TableRelation = "No. Series";
        }

        field(5; "Enrollment No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment No. Series';
            TableRelation = "No. Series";
        }

        field(6; "Fee Invoice No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fee Invoice No. Series';
            TableRelation = "No. Series";
        }

        field(7; "Max Students Per Course"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Students Per Course';
            MinValue = 1;   // at least 1 student
            MaxValue = 500; // max 500 students per course
            InitValue = 30; // default is 30 if not configured
        }

        field(8; "Pass Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pass Percentage (%)';
            MinValue = 0;
            MaxValue = 100;
            InitValue = 50; // default pass marks = 50%
        }
    }

    keys
    {
        // Clustered = true means data is physically sorted by this key
        // Setup table always has blank primary key — only one record
        key(PK; "Primary Key") { Clustered = true; }
    }
}