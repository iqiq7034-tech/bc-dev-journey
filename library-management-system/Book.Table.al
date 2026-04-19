table 50101 Book
{
    Caption = 'Book';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Title"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Author"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Status"; Enum "Book Status")
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Rec.Status = "Book Status"::Borrowed) and

                 (xRec.Status = "Book Status"::Inrepair) then
                    Error('Book cannot be borrowed as it is currently in repair.');

                if (Rec.Status = "Book Status"::Borrowed) then
                    Rec."Last Borrowed Date" := Today;
            end;
        }
        field(5; "Last Borrowed Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Pk; "No.")
        {
            Clustered = true;
        }
    }



    var
        myInt: Integer;

    trigger OnInsert()
    begin
        // Code to execute when a new book record is inserted
        Rec.Status := "Book Status"::Available; // Set default status to Available
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}