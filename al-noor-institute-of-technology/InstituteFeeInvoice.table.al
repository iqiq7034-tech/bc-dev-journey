table 50124 "Institute Fee Invoice"
{
    Caption = 'Institute Fee Invoice';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice No.';
            NotBlank = true;
        }
        field(2; "Student No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No.';
            TableRelation = "Institute Student"."No.";
        }
        field(3; "Course No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No.';
            TableRelation = "Institute Course"."No.";
        }
        field(4; "Enrollment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment No.';
            TableRelation = "Institute Enrollment"."Enrollment No.";
        }
        field(5; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount (PKR)';
            MinValue = 0;
        }
        field(6; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionMembers = Unpaid,Partial,Paid,Overdue;
            OptionCaption = 'Unpaid,Partial,Paid,Overdue';
            InitValue = Unpaid;
        }
        field(7; "Invoice Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Date';
        }
        field(8; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(K1; "Student No.") { }
        key(K2; "Course No.", Status) { }
        key(K3; "Student No.", Status) { }
    }
}

