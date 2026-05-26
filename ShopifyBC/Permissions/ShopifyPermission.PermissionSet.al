permissionset 50200 "SHOPIFY INTEGRATION"
{
    Assignable = true;
    Caption = 'Shopify Integration Access';

    Permissions =
        // Sales Orders - Insert, Modify, Read
        // NO Delete - Shopify never deletes BC orders
        tabledata "Sales Header" = IMR,
        tabledata "Sales Line" = IMR,

        // Customers - Read Only
        // Shopify only verifies customers
        // never creates or modifies them
        tabledata Customer = R,

        // Items - Read Only
        // Shopify only checks stock and prices
        tabledata Item = R,

        // Supporting tables needed by BC internally
        tabledata "Sales Header Archive" = R,
        tabledata "Salesperson/Purchaser" = R,
        tabledata "Payment Terms" = R,
        tabledata "Shipment Method" = R,
        tabledata Currency = R,
        tabledata "Item Ledger Entry" = R,

        // Our custom API pages
        page "Shopify Sales Order API" = X,
        page "Shopify Customer API" = X,
        page "Shopify Item API" = X;
}