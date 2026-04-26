pageextension 50102 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addlast(content)
        {
            group(AdditionalInfo)
            {
                Caption = 'Additional Info';
                field(CustomerCategory; Rec.CustomerCategory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the category of this customer.';
                }
                field("Credit Score"; Rec."Credit Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the credit score of this customer.';
                }
                field("Last Visit Date"; Rec."Last Visit Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the last visit date for this customer.';
                }
                field("Special Discount %"; Rec."Special Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the special discount percentage for this customer.';
                }
                field("Preferred Payment Method"; Rec."Preferred Payment Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the preferred payment method for this customer.';
                }
                field("Customer Notes"; Rec."Customer Notes")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Enter any additional notes for this customer.';
                }
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("View Visit Log")
            {
                ApplicationArea = All;
                Caption = 'View Visit Log';
                Promoted = true;
                PromotedCategory = Process;
                Image = History;
                RunObject = page "Customer Visit Log List";
                RunPageLink = CustomerNo = field("No.");
                ToolTip = 'View all visits for this customer.';
            }
            action("View Feedback")
            {
                ApplicationArea = All;
                Caption = 'View Feedback';
                Image = CreateRating;
                RunObject = page "Customer Feedback List";
                RunPageLink = CustomerNo = field("No.");
                ToolTip = 'View all feedback for this customer.';
            }
        }
    }

    var
        myInt: Integer;
}