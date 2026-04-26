pageextension 50103 "Sales Invoice Ext" extends "Sales Invoice"
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
                    Editable = false;
                    ToolTip = 'Shows the delivery priority for this invoice.';
                }
                field("Internal Reference No"; Rec."Internal Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the internal reference number for this invoice.';
                }
                field("Customer Satisfaction"; Rec.CustomerSatisfaction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the customer satisfaction level.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows who approved this invoice.';
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the approval date for this invoice.';
                }
            }
        }
    }
}