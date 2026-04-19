tableextension 50101 "Customer Ext" extends Customer
{
    fields
    {
        field(50; "customer tier"; Enum "customer tier")
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Tier';
        }
        field(50200; "Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(50201; "Total Sales (LCY)"; Decimal)
        {
            Caption = 'Total Sales (LCY)';
            FieldClass = FlowField;
            CalcFormula = sum("Cust. Ledger Entry"."Sales (LCY)"
            where("Customer No." = field("No.")));
            Editable = false;
        }
    }
    trigger OnAfterInsert()
    begin
        AssignTierDiscount();
    end;

    trigger OnAfterModify()
    begin
        AssignTierDiscount();
    end;




    local procedure AssignTierDiscount()
    begin
        case Rec."customer tier" of
            Rec."customer tier"::Bronze:
                Rec."Discount %" := 5;
            "customer tier"::Silver:
                Rec."Discount %" := 10;
            "customer tier"::Gold:
                Rec."Discount %" := 15;
            else
                Rec."Discount %" := 0

        end;
        Rec.Modify();
    end;

}