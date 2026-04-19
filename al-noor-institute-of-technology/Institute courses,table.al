table 50121 "Institute Course"
{
    Caption = 'Institute Course';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No.';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Course Name';
            NotBlank = true;
        }
        field(3; "Duration (Months)"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration (Months)';
            MinValue = 1;
            MaxValue = 60;
            InitValue = 6;
        }
        field(4; "Fee Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Course Fee (PKR)';
            MinValue = 0;
            InitValue = 0;
        }
        field(5; "Max Students"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max Students';
            MinValue = 1;
            InitValue = 30;
        }
        field(6; "Is Active"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
            InitValue = true;
        }
        field(7; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(8; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }

        // ── FLOWFIELDS ──────────────────────────────────────────────
        // FlowFields must NOT have DataClassification
        // They are virtual — not stored in database

        field(9; "No. of Students"; Integer)
        {
            Caption = 'No. of Students';
            FieldClass = FlowField;
            CalcFormula = Count("Institute Enrollment"
                          where("Course No." = field("No."),
                                Status = const(Enrolled)));
            Editable = false;
        }
        field(10; "Total Fee Collected"; Decimal)
        {
            Caption = 'Total Fee Collected';
            FieldClass = FlowField;
            CalcFormula = Sum("Institute Fee Invoice"."Total Amount"
                          where("Course No." = field("No."),
                                Status = const(Paid)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(K1; Name) { }
        key(K2; "Is Active", "Start Date") { }
    }

    trigger OnInsert()
    begin
        if ("Start Date" <> 0D) and ("End Date" = 0D) then
            "End Date" := CalcDate('<' + Format("Duration (Months)") + 'M>', "Start Date");
    end;

    trigger OnModify()
    begin
        if ("Start Date" <> 0D) and ("Duration (Months)" > 0) then
            "End Date" := CalcDate('<' + Format("Duration (Months)") + 'M>', "Start Date");
    end;

    trigger OnDelete()
    var
        Enrollment: Record "Institute Enrollment";
    begin
        Enrollment.SetRange("Course No.", "No.");
        Enrollment.SetRange(Status, Enrollment.Status::Enrolled);
        if not Enrollment.IsEmpty() then
            Error('Cannot delete course %1. It has %2 active enrollments.',
                  "No.", Enrollment.Count());
    end;

    trigger OnRename()
    var
        Enrollment: Record "Institute Enrollment";
    begin
        Enrollment.SetRange("Course No.", xRec."No.");
        Enrollment.ModifyAll("Course No.", "No.", true);
    end;
}

