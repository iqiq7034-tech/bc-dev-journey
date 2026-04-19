report 50106 "Sales Summary by Customer"
{
    Caption = 'Sales Summary by Customer';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesSummary.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Tier";
            PrintOnlyIfDetail = true;

            column(CustNo; "No.") { }
            column(CustName; Name) { }
            column(CustTier; "Customer Tier") { }
            column(CustDiscount; "Discount %") { }
            column(CustCreditLimit; "Credit Limit (LCY)") { }
            column(CustBalance; "Balance (LCY)") { }
            column(TotalSales; "Total Sales (LCY)") { }
            column(CompanyName; CompanyName()) { }
            column(PrintDate; Today()) { }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView =
                    sorting("Customer No.", "Posting Date")
                    where("Document Type" = filter(Invoice | "Credit Memo"));

                column(PostingDate; "Posting Date") { }
                column(DocumentNo; "Document No.") { }
                column(DocumentType; "Document Type") { }
                column(SalesLCY; "Sales (LCY)") { }
                column(RemainingAmt; "Remaining Amount") { }
                column(Description; Description) { }

                trigger OnAfterGetRecord()
                begin
                    TotalSalesAmt += "Sales (LCY)";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)", "Total Sales (LCY)");
                TotalSalesAmt := 0;
            end;

            trigger OnPreDataItem()
            begin
                TotalSalesAmt := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    Caption = 'Report Filters';

                    field(StartDate; StartDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Filter entries from this date.';
                    }
                    field(EndDate; EndDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Filter entries up to this date.';
                    }
                }
            }
        }
    }

    var
        TotalSalesAmt: Decimal;
        StartDateFilter: Date;
        EndDateFilter: Date;
}