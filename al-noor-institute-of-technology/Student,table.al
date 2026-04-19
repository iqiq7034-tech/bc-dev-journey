table 50122 "Institute Student"
{
    Caption = 'Institute Student';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No.';
            NotBlank = true;
        }
        field(2; "First Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'First Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                BuildFullName();
            end;
        }
        field(3; "Last Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                BuildFullName();
            end;
        }
        field(4; "Full Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Full Name';
            Editable = false;
        }
        field(5; "Father Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Father Name';
            NotBlank = true;
        }
        field(6; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        }
        field(7; Gender; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Gender';
            OptionMembers = " ",Male,Female,Other;
            OptionCaption = ' ,Male,Female,Other';
        }
        field(8; "CNIC"; Code[15])
        {
            DataClassification = CustomerContent;
            Caption = 'CNIC No.';

            trigger OnValidate()
            begin
                if ("CNIC" <> '') and (StrLen("CNIC") <> 13) then
                    Error('CNIC must be exactly 13 digits. You entered %1 digits.',
                          StrLen("CNIC"));
            end;
        }
        field(9; "Phone No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
        }
        field(10; Email; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email Address';
        }
        field(11; Address; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        }
        field(12; City; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(13; "Registration Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Registration Date';
        }
        field(14; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionMembers = Active,Inactive,Graduated,Dropped;
            OptionCaption = 'Active,Inactive,Graduated,Dropped';
            InitValue = Active;
        }



        field(15; "No. of Enrollments"; Integer)
        {
            Caption = 'No. of Enrollments';
            FieldClass = FlowField;
            CalcFormula = Count("Institute Enrollment"
                          where("Student No." = field("No.")));
            Editable = false;
        }
        field(16; "Total Marks Scored"; Decimal)
        {
            Caption = 'Total Marks Scored';
            FieldClass = FlowField;
            CalcFormula = Sum("Institute Marks Entry"."Marks Obtained"
                          where("Student No." = field("No.")));
            Editable = false;
        }
        field(17; "Total Fees Paid"; Decimal)
        {
            Caption = 'Total Fees Paid';
            FieldClass = FlowField;
            CalcFormula = Sum("Institute Fee Invoice"."Total Amount"
                          where("Student No." = field("No."),
                                Status = const(Paid)));
            Editable = false;
        }
        field(18; "Outstanding Fees"; Decimal)
        {
            Caption = 'Outstanding Fees';
            FieldClass = FlowField;
            CalcFormula = Sum("Institute Fee Invoice"."Total Amount"
                          where("Student No." = field("No."),
                                Status = const(Unpaid)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(K1; "Full Name") { }
        key(K2; Status) { }
        key(K3; Status, City) { }
    }

    trigger OnInsert()
    begin
        if "Registration Date" = 0D then
            "Registration Date" := Today;
        BuildFullName();
    end;

    trigger OnModify()
    begin
        BuildFullName();
    end;

    trigger OnDelete()
    var
        Enrollment: Record "Institute Enrollment";
        FeeInvoice: Record "Institute Fee Invoice";
        MarksEntry: Record "Institute Marks Entry";
    begin
        // Step 1: Block deletion if student has unpaid fees
        FeeInvoice.SetRange("Student No.", "No.");
        FeeInvoice.SetRange(Status, FeeInvoice.Status::Unpaid);
        if not FeeInvoice.IsEmpty() then
            Error('Cannot delete student %1 - %2. They have outstanding fees.',
                  "No.", "Full Name");

        // Step 2: Delete all related records (cleanup)
        Enrollment.SetRange("Student No.", "No.");
        Enrollment.DeleteAll(true);

        MarksEntry.SetRange("Student No.", "No.");
        MarksEntry.DeleteAll(true);

        FeeInvoice.Reset();
        FeeInvoice.SetRange("Student No.", "No.");
        FeeInvoice.DeleteAll(true);
    end;

    trigger OnRename()
    begin
        BuildFullName();
    end;

    local procedure BuildFullName()
    begin
        "Full Name" := CopyStr(
            "First Name" + ' ' + "Last Name",
            1,
            MaxStrLen("Full Name")
        );
    end;
}

