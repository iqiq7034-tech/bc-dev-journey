codeunit 50101 "Customer Mgmt"
{
    procedure UpdateCustomerCategory(var Customer: Record Customer)
    var
        TotalSales: Decimal;
    begin
        TotalSales := GetCustomerTotalSales(Customer."No.");
        if TotalSales >= 100000 then
            Customer.CustomerCategory := Customer.CustomerCategory::Gold
        else if TotalSales >= 50000 then
            Customer.CustomerCategory := Customer.CustomerCategory::Silver
        else
            Customer.CustomerCategory := Customer.CustomerCategory::Bronze;

        Customer.Modify(true);
    end;

    procedure ValidateDiscount(var Customer: Record Customer)
    begin
        case Customer.CustomerCategory of
            Customer.CustomerCategory::Gold:
                if Customer."Special Discount %" > 50 then
                    Error('Gold customers cannot have more than 50% discount.');
            Customer.CustomerCategory::Silver:
                if Customer."Special Discount %" > 40 then
                    Error('Silver Customers cannot have more than 40% discount.');
            Customer.CustomerCategory::Bronze:
                if Customer."Special Discount %" > 30 then
                    Error('Bronze customers cannot have more than 30% discount.');
        end;
    end;

    procedure UpdateLastVisitDate(CustomerNo: Code[20]; visitDate: Date)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then begin
            Customer."Last Visit Date" := visitDate;
            Customer.Modify(true);
        end;
    end;

    local procedure GetCustomerTotalSales(CustomerNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields(Amount);
                TotalAmount += CustLedgerEntry.Amount;
            until CustLedgerEntry.Next() = 0;
        exit(TotalAmount);

    end;
}