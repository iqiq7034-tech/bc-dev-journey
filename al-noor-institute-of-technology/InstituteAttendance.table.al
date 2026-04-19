table 50126 "Institute Attendance"
{
    Caption = 'Institute Attendance';
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
        field(2; "Enrollment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment No.';
            TableRelation = "Institute Enrollment"."Enrollment No.";
        }
        field(3; "Student No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No.';
            TableRelation = "Institute Student"."No.";
        }
        field(4; "Course No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No.';
            TableRelation = "Institute Course"."No.";
        }
        field(5; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(6; "Is Present"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Present';
            InitValue = true;
        }
        field(7; Remarks; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K1; "Enrollment No.", "Is Present") { }
        key(K2; "Student No.", Date) { }
    }
}

