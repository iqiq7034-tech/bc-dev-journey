pageextension 50110 "Vendor Card Quality Ext" extends "Vendor Card"
{
    layout
    {
        addlast(content)
        {
            group("Quality Tracking")
            {
                Caption = 'Quality Tracking';
                field("Average Quality Rating"; Rec."Average Quality Rating")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the average quality score based on posted inspections.';
                    Style = StrongAccent;
                }
                field("Inspection Count"; Rec."Inspection Count")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many times this vendor has been inspected.';
                    Style = StrongAccent;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}