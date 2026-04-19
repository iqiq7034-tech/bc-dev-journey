tableextension 50105 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50; "Tier Discount Applied"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Tier Discount Applied';
            Editable = false;
        }
        field(51; "Original Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Unit Price';
            Editable = false;
        }
    }

    trigger OnInsert()
    var
        DiscountMgmt: Codeunit "Discount Mgmt";
        Customer: Record Customer;
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            DiscountMgmt.CheckCreditLimit(Rec."Sell-to Customer No.");

        if Customer.Get(Rec."Sell-to Customer No.") then begin
            Rec."Original Unit Price" := Rec."Unit Price";
            Rec."Unit Price" := DiscountMgmt.CalcDiscount(
                Rec."Unit Price",
                Customer."Discount %"
            );
            if Customer."Discount %" > 0 then
                Rec."Tier Discount Applied" := true;
        end;
    end;

    trigger OnModify()
    var
        DiscountMgmt: Codeunit "Discount Mgmt";
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            DiscountMgmt.CheckCreditLimit(Rec."Sell-to Customer No.");
    end;
}