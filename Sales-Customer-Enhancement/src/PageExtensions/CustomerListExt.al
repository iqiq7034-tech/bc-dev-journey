pageextension 50104 "Customer List Ext" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Customer Category"; Rec.CustomerCategory)
            {
                ApplicationArea = All;
                ToolTip = 'Shows the category of this customer.';
            }
            field("Credit Score"; Rec."Credit Score")
            {
                ApplicationArea = All;
                ToolTip = 'Shows the credit score of this customer.';
            }
            field("Last Visit Date"; Rec."Last Visit Date")
            {
                ApplicationArea = All;
                ToolTip = 'Shows the last visit date for this customer.';
            }
            field("Special Discount %"; Rec."Special Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Shows the special discount for this customer.';
            }
        }
    }
}