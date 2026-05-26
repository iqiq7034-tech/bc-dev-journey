page 50202 "Shopify Item API"
{
    PageType = API;
    APIPublisher = 'shopifybc';
    APIGroup = 'shopify';
    APIVersion = 'v1.0';
    EntityName = 'shopifyItem';
    EntitySetName = 'shopifyItems';
    SourceTable = Item;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Caption = 'Shopify Item API';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'number';
                    Editable = false;
                }
                field(displayName; Rec.Description)
                {
                    Caption = 'displayName';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'unitPrice';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'unitCost';
                    Editable = false;
                }
                field(inventory; Rec.Inventory)
                {
                    Caption = 'inventory';
                    Editable = false;
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'baseUnitOfMeasure';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'blocked';
                    Editable = false;
                }
                field(itemType; Rec.Type)
                {
                    Caption = 'itemType';
                    Editable = false;
                }
                field(shopifyProductId; Rec.GTIN)
                {
                    Caption = 'shopifyProductId';
                }
                field(grossWeight; Rec."Gross Weight")
                {
                    Caption = 'grossWeight';
                    Editable = false;
                }
            }
        }
    }
}