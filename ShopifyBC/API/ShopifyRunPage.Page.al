page 50203 "Run Shopify Sync"
{
    PageType = Card;
    Caption = 'Run Shopify Sync';
    UsageCategory = Tasks;
    ApplicationArea = All;

    actions
    {
        area(Processing)
        {
            action(RunSync)
            {
                Caption = 'Run Shopify Sync Now';
                ApplicationArea = All;
                Image = RefreshLines;

                trigger OnAction()
                var
                    ShopifyInt: Codeunit "Shopify Integration";
                begin
                    ShopifyInt.SyncShopifyOrders();
                end;
            }
        }
    }
}