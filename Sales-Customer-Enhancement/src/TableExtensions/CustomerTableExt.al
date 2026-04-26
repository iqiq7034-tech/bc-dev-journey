tableextension 50110 "Customer table Ext" extends Customer
{
    fields
    {
        field(200; CustomerCategory; Enum CustomerCategory)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Category';
        }
        field(201; "Credit Score"; Decimal)
        {
            Caption = 'Credit Score';
            MinValue = 0;
            MaxValue = 100;
            DataClassification = CustomerContent;
        }
        field(202; "Last Visit Date"; Date)
        {
            Caption = 'Last Visit Date';
            DataClassification = CustomerContent;
        }
        field(203; "Special Discount %"; Decimal)
        {
            Caption = 'Special Discount %';
            MinValue = 0;
            MaxValue = 100;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CustomerMgmt: Codeunit "Customer Mgmt";
            begin
                CustomerMgmt.ValidateDiscount(Rec);
            end;


        }
        field(204; "Preferred Payment Method"; Text[50])
        {
            Caption = 'Preferred Payment Method';
            DataClassification = CustomerContent;
        }
        field(205; "Customer Notes"; Text[250])
        {
            Caption = 'Customer Notes';
            DataClassification = CustomerContent;
        }
    }


}