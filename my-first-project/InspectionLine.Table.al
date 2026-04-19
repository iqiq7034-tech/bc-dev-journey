table 50111 "Inspection Line"
{
    Caption = 'Inspection Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Inspection Header"."No.";

        }
        field(2; "Line number"; Integer)
        {
            Caption = 'Line number';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Score (1-5)"; Integer)
        {
            Caption = 'Score';
            MinValue = 1;
            MaxValue = 5;
        }
    }

    keys
    {
        key(Pk; "Document No.", "Line number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

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