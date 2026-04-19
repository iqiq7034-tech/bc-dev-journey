codeunit 50104 "Discount Mgmt"
{
    procedure CalcDiscount(unitPrice: Decimal; discountPct: Decimal): Decimal
    begin
        if discountPct <= 0 then
            exit(unitPrice);
        exit(unitPrice - (unitPrice * discountPct / 100));
    end;



    procedure CheckCreditLimit(CustNo: Code[20])
    var
        cust: Record Customer;
    begin
        if not cust.Get(CustNo) then
            Error('Customer %1 not found', CustNo);

        cust.CalcFields("Balance (LCY)");


        if cust."Credit Limit (LCY)" = 0 then
            exit;
        if cust."Balance (LCY)" > cust."Credit Limit (LCY)" then
            Error('Credit limit exceeded for customer %1 - %2.\Balance: %3    Credit Limit: %4',
             cust."No.",
             cust."Name",
             cust."Balance (LCY)",
             cust."Credit Limit (LCY)"
             );
    end;


    procedure ApplyTierDiscount(var Cust: Record Customer)
    begin
        case Cust."customer tier" of
            Cust."customer tier"::Bronze:
                Cust."Discount %" := 5;
            Cust."customer tier"::Silver:
                Cust."Discount %" := 10;
            Cust."customer tier"::Gold:
                Cust."Discount %" := 15;
            else
                Cust."Discount %" := 0;

        end;
        Cust.Modify(true);
    end;


    procedure GetTierLable(CustomerTier: Enum "customer tier"): Text
    begin
        case CustomerTier of
            CustomerTier::Bronze:
                exit('🥉 Bronze — 5% Discount');
            CustomerTier::Silver:
                exit('🥈 Silver — 10% Discount');
            CustomerTier::Gold:
                exit('🥇 Gold — 15% Discount');
            else
                exit('No Tier Assigned');

        end;
    end;


}