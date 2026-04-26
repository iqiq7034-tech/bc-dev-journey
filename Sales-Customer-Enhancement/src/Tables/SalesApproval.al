table 50104 "Sales Approval"
{
    Caption = 'Sales Approval';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
            DataClassification = CustomerContent;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
        field(5; "Requested By"; Text[100])
        {
            Caption = 'Requested By';
            DataClassification = CustomerContent;
        }
        field(6; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(7; "Approved By"; Text[100])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(8; "Approval Status"; Enum ApprovalStatus)
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(9; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(10; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
            DataClassification = CustomerContent;
        }
        field(11; "Order Amount"; Decimal)
        {
            Caption = 'Order Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(StatusKey; "Approval Status", "Request Date") { }
    }
}