report 50100 "Customer Analysis"
{
    Caption = 'Customer Analysis Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Reports/CustomerAnalysis.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", CustomerCategory;

            column(CustomerNo; "No.")
            {
                Caption = 'Customer No.';
            }
            column(CustomerName; Name)
            {
                Caption = 'Customer Name';
            }
            column(CustomerCategory; CustomerCategory)
            {
                Caption = 'Category';
            }
            column(CreditScore; "Credit Score")
            {
                Caption = 'Credit Score';
            }
            column(LastVisitDate; "Last Visit Date")
            {
                Caption = 'Last Visit Date';
            }
            column(SpecialDiscount; "Special Discount %")
            {
                Caption = 'Special Discount %';
            }
            column(CustomerNotes; "Customer Notes")
            {
                Caption = 'Notes';
            }
            column(CompanyName; CompanyName())
            {
                Caption = 'Company Name';
            }
            column(ReportDate; Today())
            {
                Caption = 'Report Date';
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }
}