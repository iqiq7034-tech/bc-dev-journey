codeunit 50105 "Discount Mgt"
{
    procedure ApplyAutomaticDiscount(var SalesLine: Record "Sales Line")
    var
        customer: Record Customer;
        DiscountPct: Decimal;
    begin
        if not customer.Get(SalesLine."Sell-to Customer No.") then
            exit;
        case Customer.CustomerCategory of
            Customer.CustomerCategory::Gold:
                begin
                    DiscountPct := 10;
                    SalesLine.LineDiscountReason := 'Automatic Gold Customer Discount';
                end;
            Customer.CustomerCategory::Silver:
                begin
                    DiscountPct := 5;
                    SalesLine.LineDiscountReason := 'Automatic Silver Customer Discount';
                end;
            Customer.CustomerCategory::Bronze:
                begin
                    DiscountPct := 2;
                    SalesLine.LineDiscountReason := 'Automatic Bronze Customer Discount';
                end;
        end;
        if DiscountPct > 0 then
            SalesLine."Line Discount %" := DiscountPct;
        SalesLine.Modify(true);
    end;


    procedure ValidateLineDiscount(SalesLine: Record "Sales Line")
    var
        Customer: Record Customer;
        MaxDiscount: Decimal;
    begin
        if not Customer.Get(SalesLine."Sell-to Customer No.") then
            exit;

        case Customer.CustomerCategory of
            Customer.CustomerCategory::Gold:
                MaxDiscount := 50;
            Customer.CustomerCategory::Silver:
                MaxDiscount := 40;
            Customer.CustomerCategory::Bronze:
                MaxDiscount := 30;
            else
                MaxDiscount := 20;
        end;

        if SalesLine."Line Discount %" > MaxDiscount then
            Error('Discount cannot exceed %1%% for this customer category.', MaxDiscount);
    end;
}