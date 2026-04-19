table 50123 "Institute Enrollment"
{
    Caption = 'Institute Enrollment';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(1; "Enrollment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment No.';
            NotBlank = true;
        }
        field(2; "Student No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Student No.';
            NotBlank = true;
            TableRelation = "Institute Student"."No.";

            trigger OnValidate()
            var
                Student: Record "Institute Student";
            begin
                if Student.Get("Student No.") then
                    "Student Name" := Student."Full Name"
                else
                    "Student Name" := '';
            end;
        }
        field(3; "Student Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Student Name';
            Editable = false;
        }
        field(4; "Course No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Course No.';
            NotBlank = true;
            TableRelation = "Institute Course"."No."
                            where("Is Active" = const(true));

            trigger OnValidate()
            var
                Course: Record "Institute Course";
            begin
                if Course.Get("Course No.") then begin
                    "Course Name" := Course.Name;
                    "Fee Amount" := Course."Fee Amount";

                    Course.CalcFields("No. of Students");
                    if Course."No. of Students" >= Course."Max Students" then
                        Error('Course %1 - %2 is full. Maximum %3 students allowed.',
                              "Course No.", "Course Name", Course."Max Students");
                end else begin
                    "Course Name" := '';
                    "Fee Amount" := 0;
                end;
            end;
        }
        field(5; "Course Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Course Name';
            Editable = false;
        }
        field(6; "Enrollment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Enrollment Date';
        }
        field(7; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionMembers = Enrolled,Completed,Dropped;
            OptionCaption = 'Enrolled,Completed,Dropped';
            InitValue = Enrolled;
        }
        field(8; "Fee Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee Amount';
            MinValue = 0;
            Editable = false;
        }
        field(9; "Fee Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Fee Status';
            OptionMembers = Unpaid,Partial,Paid;
            OptionCaption = 'Unpaid,Partial,Paid';
            InitValue = Unpaid;
        }

        // ── FLOWFIELDS ──────────────────────────────────────────────
        // IMPORTANT: FlowFields must NOT have DataClassification
        // They are virtual calculated fields — not stored in database

        field(10; "Attendance Days"; Integer)
        {
            Caption = 'Attendance Days';
            FieldClass = FlowField;
            CalcFormula = Count("Institute Attendance"
                          where("Enrollment No." = field("Enrollment No."),
                                "Is Present" = const(true)));
            Editable = false;
        }
        field(11; "Average Marks"; Decimal)
        {
            Caption = 'Average Marks (%)';
            FieldClass = FlowField;
            CalcFormula = Average("Institute Marks Entry"."Marks Percentage"
                          where("Enrollment No." = field("Enrollment No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Enrollment No.") { Clustered = true; }
        key(K1; "Student No.") { }
        key(K2; "Course No.") { }
        key(K3; "Student No.", "Course No.", Status) { }
    }

    trigger OnInsert()
    var
        DuplicateCheck: Record "Institute Enrollment";
    begin
        if "Enrollment Date" = 0D then
            "Enrollment Date" := Today;

        // Prevent duplicate: same student, same course, already Enrolled
        DuplicateCheck.SetRange("Student No.", "Student No.");
        DuplicateCheck.SetRange("Course No.", "Course No.");
        DuplicateCheck.SetRange(Status, DuplicateCheck.Status::Enrolled);
        DuplicateCheck.SetFilter("Enrollment No.", '<>%1', "Enrollment No.");
        if not DuplicateCheck.IsEmpty() then
            Error('Student %1 is already enrolled in course %2.',
                  "Student No.", "Course No.");
    end;

    trigger OnDelete()
    var
        Attendance: Record "Institute Attendance";
        MarksEntry: Record "Institute Marks Entry";
    begin
        // Block deletion if fee is already paid
        if "Fee Status" = "Fee Status"::Paid then
            Error('Cannot delete enrollment %1. Fee has already been paid.',
                  "Enrollment No.");

        // Cleanup child records
        Attendance.SetRange("Enrollment No.", "Enrollment No.");
        Attendance.DeleteAll(true);

        MarksEntry.SetRange("Enrollment No.", "Enrollment No.");
        MarksEntry.DeleteAll(true);
    end;

    trigger OnRename()
    begin
        Error('Enrollment No. cannot be changed after creation.');
    end;
}

