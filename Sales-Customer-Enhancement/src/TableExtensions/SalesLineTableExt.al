tableextension 50104 "My Sales Line Table Ext" extends "Sales Line"
{
    fields
    {
        field(206; LineDiscountReason; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount Reason';
        }
        field(207; QualityCheckStatus; Enum QualityCheckStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Quality Check Status';
        }

        field(208; WarehouseLocationNote; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Warehouse Location Note';
        }
    }


}