pageextension 50105 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(content)
        {
            group("Additional Details")
            {
                Caption = 'Additional Details';

                field("Delivery Priority"; Rec.DeliveryPriority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the delivery priority for this order.';
                }
                field("Internal Reference No"; Rec."Internal Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the internal reference number for this order.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows who approved this order.';
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the date this order was approved.';
                }
                field("Customer Satisfaction"; Rec.CustomerSatisfaction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the customer satisfaction level.';
                }
            }
        }
    }
}