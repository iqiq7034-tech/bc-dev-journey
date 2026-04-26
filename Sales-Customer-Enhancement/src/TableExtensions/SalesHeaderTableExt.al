tableextension 50111 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(205; DeliveryPriority; Enum DeliveryPriority)
        {
            DataClassification = CustomerContent;
            Caption = 'Delivery Priority';
        }
        field(206; CustomerSatisfaction; Enum CustomerSatisfaction)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Satisfaction';
        }
        field(50102; "Internal Reference No"; Text[50])
        {
            Caption = 'Internal Reference No';
            DataClassification = CustomerContent;
        }
        field(50103; "Approved By"; Text[100])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(50104; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
    }

}