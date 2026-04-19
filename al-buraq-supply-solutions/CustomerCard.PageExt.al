pageextension 50103 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group("Tier & Discount Info")
            {
                Caption = 'Tier & Discount Info';
                field("customer tier"; Rec."customer tier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the cusomer tier : Bronze, Silver, or Gold.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Auto-calculated discount based on the customer tier.';
                    Editable = false;
                }
                field("Total Sales (LCY)"; Rec."Total Sales (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total sales amount for the customer (local currency).';
                    Editable = false;
                }
            }

        }
        addfirst(factboxes)
        {
            part("Order History"; "Sales Order Subform")
            {
                ApplicationArea = All;
                Caption = 'Order History';
                SubPageLink = "Sell-to Customer No." = field("No.");
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(ReCalcDiscount)
            {
                ApplicationArea = All;
                Caption = 'Recalculate Discount';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Recalculate;

                trigger OnAction()
                var
                    DiscountMgmt: Codeunit "Discount Mgmt";
                begin
                    DiscountMgmt.ApplyTierDiscount(Rec);
                    Message('Discount recalculated successfully for %1.', Rec.Name);

                end;
            }
        }
    }
}