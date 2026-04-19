table 50110 "Inspection Header"
{
    Caption = 'Inspection Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.Get("Vendor No.") then
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(3; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(4; "Inspection Date"; Date)
        {
            Caption = 'Inspection Date';
        }
        field(5; Status; Enum "Inspection Status")
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
