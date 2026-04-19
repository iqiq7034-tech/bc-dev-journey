namespace ALProject.ALProject;

using Microsoft.Purchases.Vendor;

tableextension 50110 "Vendor Quality check Ext" extends Vendor
{
    fields
    {
        field(50100; "Total Quality Score"; Decimal)
        {
            Caption = 'Total Quality Score';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Inspection Count"; Integer)
        {
            Caption = 'Inspection Count';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50102; "Average Quality Rating"; Decimal)
        {
            Caption = 'Average Quality Rating';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}
