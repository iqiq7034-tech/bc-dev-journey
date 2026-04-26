page 50101 "Customer Visit Log Card"
{
    Caption = 'Customer Visit Log Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = CustomerVisitLog;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(EntryNo; Rec.EntryNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the entry Number.';

                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the customer for this vist.';

                }
                field(CustomerName; Rec.CustomerName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the customer name.';
                }
                field(VisitDate; Rec.VisitDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the date of the visit.';

                }
                field(SalesRepName; Rec.SalesRepName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the number of sales representative.';

                }
                field(VisitPurpose; Rec.VisitPurpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the purpose of the visit.';

                }
                field("Follow Up Date"; Rec.FollowUpDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the follow up date for this visit.';
                }
                field("Visit Notes"; Rec.VisitNotes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Enter any notes about this visit.';
                }

            }
        }
    }


}