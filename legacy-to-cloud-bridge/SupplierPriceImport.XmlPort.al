xmlport 50102 "Supplier Price Importer"
{
    Caption = 'Supplier Price Importer';
    Format = Xml;
    Direction = Import;
    UseDefaultNamespace = false;
    schema
    {
        textelement(Items)
        {
            tableelement(Item; Item)
            {
                XmlName = 'SupplierItem';
                AutoUpdate = true;

                fieldattribute(ItemNo; Item."No.") { }

                textelement(ItemName)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        Item.Validate(Description, ItemName);
                    end;
                }

                textelement(NewPrice)
                {
                    trigger OnAfterAssignVariable()
                    var
                        PriceDec: Decimal;
                    begin
                        if Evaluate(PriceDec, NewPrice) then begin
                            Item.Validate("Unit Price", PriceDec);
                            Item.Modify(true);
                        end;
                    end;
                }

                textelement(LeadTime) { }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Import Settings';
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    }


}



pageextension 50107 "Item List Ext" extends "Item List"
{


    actions
    {
        addlast(processing)
        {
            action(ImportSupplierPrices)
            {
                Caption = 'Import Supplier Prices';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Supplier Price Importer", true, true);
                    Message('Prices Updated Successfully!');

                end;
            }
        }
    }

    var
        myInt: Integer;
}