page 50102 "Customer visit Log List"
{
    Caption = 'Customer Visit Log';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = CustomerVisitLog;
    CardPageId = "Customer Visit Log Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec.EntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the entry number.';
                }
                field("Customer No."; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the customer number.';
                }
                field("Customer Name"; Rec.CustomerName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the customer name.';
                }
                field("Visit Date"; Rec.VisitDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the visit date.';
                }
                field("Sales Rep Name"; Rec.SalesRepName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the sales rep name.';
                }
                field("Visit Purpose"; Rec.VisitPurpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the visit purpose.';
                }
                field("Follow Up Date"; Rec.FollowUpDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the follow up date.';
                }

            }
        }
    }


}