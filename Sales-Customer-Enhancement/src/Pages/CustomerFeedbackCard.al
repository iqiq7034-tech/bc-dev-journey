page 50103 "Customer Feedback Card"
{
    PageType = Card;
    SourceTable = CustomerFeedback;
    Caption = 'Customer Feedback';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec.EntryNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the entry number.';
                }
                field("Customer No."; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the customer.';
                }
                field("Customer Name"; Rec.CustomerName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the customer name.';
                }
                field("Feedback Date"; Rec.FeedbackDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the feedback date.';
                }
                field("Rating"; Rec."Rating")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the rating from 1 to 5.';
                }
                field("Feedback Type"; Rec.FeedbackType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the type of feedback.';
                }
                field("Comments"; Rec."Comments")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Enter the customer comments.';
                }
                field("Resolved"; Rec."Resolved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Check this if the feedback has been resolved.';
                }
                field("Resolved Date"; Rec.ResolvedDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the date when feedback was resolved.';
                }
            }
        }
    }
}