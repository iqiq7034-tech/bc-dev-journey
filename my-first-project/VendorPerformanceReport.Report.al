report 50110 "Vendor Performance Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Vendor Performance Report';
    DefaultLayout = Word;
    WordLayout = 'VendorPerformance.docx';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = where("Inspection Count" = filter(> 0));

            column(VendorNo; "No.") { }
            column(VendorName; Name) { Caption = 'Vendor Name'; }
            column(AvgRating; "Average Quality Rating") { Caption = 'Average Rating'; }
            column(TotalInspections; "Inspection Count") { }
        }
    }

}