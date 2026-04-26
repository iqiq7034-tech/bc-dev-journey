page 50104 "Customer Feedback List"
{
    PageType = List;
    SourceTable = CustomerFeedback;
    Caption = 'Customer Feedback';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Customer Feedback Card";

    layout
    {
        area(content)
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
                field("Feedback Date"; Rec.FeedbackDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the feedback date.';
                }
                field("Rating"; Rec."Rating")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the rating.';
                }
                field("Feedback Type"; Rec.FeedbackType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the feedback type.';
                }
                field("Resolved"; Rec."Resolved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows whether feedback is resolved.';
                }
            }
        }
    }
}