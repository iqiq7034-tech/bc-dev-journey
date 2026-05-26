page 50200 "Shopify Sales Order API"
{
    PageType = API;
    APIPublisher = 'shopifybc';
    APIGroup = 'shopify';
    APIVersion = 'v1.0';
    EntityName = 'shopifySalesOrder';
    EntitySetName = 'shopifySalesOrders';
    SourceTable = "Sales Header";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Caption = 'Shopify Sales Order API';

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
                }
                field(customerNumber; Rec."Sell-to Customer No.")
                {
                    Caption = 'customerNumber';
                }
                field(customerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'customerName';
                    Editable = false;
                }
                field(shopifyOrderId; Rec."External Document No.")
                {
                    Caption = 'shopifyOrderId';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'orderDate';
                }
                field(status; Rec.Status)
                {
                    Caption = 'status';
                    Editable = false;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'shipToName';
                }
                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'shipToAddress';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'shipToCity';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'shipToPostCode';
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'shipToCountry';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'amount';
                    Editable = false;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'currencyCode';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Order;
        exit(true);
    end;
}