table 50125 "Institute Marks Entry"
{
    Caption = 'Institute Marks Entry';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Student No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No.';
            TableRelation = "Institute Student"."No.";
        }
        field(3; "Enrollment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment No.';
            TableRelation = "Institute Enrollment"."Enrollment No.";
        }
        field(4; "Course No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No.';
            TableRelation = "Institute Course"."No.";
        }
        field(5; Subject; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Subject';
        }
        field(6; "Marks Obtained"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Marks Obtained';
            MinValue = 0;
        }
        field(7; "Max Marks"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Marks';
            MinValue = 0;
            InitValue = 100;
        }
        field(8; "Marks Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Marks Percentage (%)';
            MinValue = 0;
            MaxValue = 100;
        }
        field(9; "Exam Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Exam Date';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K1; "Student No.") { }
        key(K2; "Enrollment No.") { }
        key(K3; "Course No.", "Student No.") { }
    }
}

