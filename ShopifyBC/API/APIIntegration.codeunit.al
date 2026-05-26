codeunit 50200 "Shopify Integration"
{
    procedure SyncShopifyOrders()
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        ResponseText: Text;
        JsonResponse: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        OrderToken: JsonToken;
    begin
        // Step 1: Setup HTTP request
        HttpRequestMessage.SetRequestUri(GetShopifyOrdersUrl());
        HttpRequestMessage.Method := 'GET';

        // Step 2: Add Shopify token to header
        HttpRequestMessage.GetHeaders(HttpHeaders);
        HttpHeaders.Add(
            'X-Shopify-Access-Token',
            GetShopifyToken()
        );

        // Step 3: Send request to Shopify
        if not HttpClient.Send(
            HttpRequestMessage,
            HttpResponseMessage) then begin
            Message('ERROR: Cannot connect to Shopify. Check internet connection.');
            exit;
        end;

        // Step 4: Check if Shopify returned success
        if not HttpResponseMessage.IsSuccessStatusCode() then begin
            Message('Shopify API Error. Status: %1',
                HttpResponseMessage.HttpStatusCode());
            exit;
        end;

        // Step 5: Read response text
        HttpResponseMessage.Content.ReadAs(ResponseText);

        // Step 6: Parse JSON response
        if not JsonResponse.ReadFrom(ResponseText) then begin
            Message('ERROR: Cannot parse Shopify response');
            exit;
        end;

        // Step 7: Get orders array and process each
        if JsonResponse.Get('orders', JsonToken) then begin
            JsonArray := JsonToken.AsArray();
            if JsonArray.Count() = 0 then begin
                Message('No orders found in Shopify to sync.');
                exit;
            end;
            foreach OrderToken in JsonArray do
                ProcessShopifyOrder(OrderToken.AsObject());
            Message('Sync completed! %1 orders processed.',
                JsonArray.Count());
        end else
            Message('No orders field in Shopify response.');
    end;

    local procedure ProcessShopifyOrder(OrderJson: JsonObject)
    var
        SalesHeader: Record "Sales Header";
        JsonToken: JsonToken;
        ShopifyOrderId: Text;
        CustomerEmail: Text;
        CustomerNo: Code[20];
    begin
        // Get Shopify Order ID
        ShopifyOrderId := '';
        if OrderJson.Get('id', JsonToken) then
            ShopifyOrderId :=
                Format(JsonToken.AsValue().AsBigInteger());

        if ShopifyOrderId = '' then begin
            Message('Order has no ID - skipping');
            exit;
        end;

        // Check if this order already exists in BC
        // We store Shopify ID in External Document No.
        SalesHeader.Reset();
        SalesHeader.SetRange(
            "Document Type",
            SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(
            "External Document No.",
            CopyStr(ShopifyOrderId, 1, 35));
        if not SalesHeader.IsEmpty() then
            // Already synced before - skip
            exit;

        // Get customer email
        CustomerEmail := '';
        if OrderJson.Get('email', JsonToken) then
            CustomerEmail :=
                JsonToken.AsValue().AsText();

        // Find matching BC customer
        CustomerNo := FindCustomerByEmail(CustomerEmail);

        // Create the Sales Order in BC
        CreateSalesOrder(
            OrderJson,
            CustomerNo,
            ShopifyOrderId);
    end;

    local procedure FindCustomerByEmail(
        Email: Text): Code[20]
    var
        Customer: Record Customer;
    begin
        // Search BC customer by email
        if Email <> '' then begin
            Customer.Reset();
            Customer.SetRange("E-Mail", Email);
            if Customer.FindFirst() then
                exit(Customer."No.");
        end;

        // Default customer if email not found in BC
        // In production you would create the customer
        exit('20000');
    end;

    local procedure CreateSalesOrder(
        OrderJson: JsonObject;
        CustomerNo: Code[20];
        ShopifyOrderId: Text)
    var
        SalesHeader: Record "Sales Header";
        JsonToken: JsonToken;
        ShippingJson: JsonObject;
    begin
        // Initialize new Sales Order
        SalesHeader.Init();
        SalesHeader."Document Type" :=
            SalesHeader."Document Type"::Order;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        // Set customer - validates and fills customer name
        SalesHeader.Validate(
            "Sell-to Customer No.", CustomerNo);

        // Store Shopify Order ID for tracking
        // and duplicate prevention
        SalesHeader."External Document No." :=
            CopyStr(ShopifyOrderId, 1, 35);

        // Set order date to today
        SalesHeader."Order Date" := Today();
        SalesHeader."Document Date" := Today();

        // Set shipping address from Shopify order
        if OrderJson.Get(
            'shipping_address', JsonToken) then begin
            ShippingJson := JsonToken.AsObject();
            SetShippingAddress(SalesHeader, ShippingJson);
        end;

        // Save the header
        SalesHeader.Modify(true);

        // Create order lines for each product
        CreateSalesLines(SalesHeader, OrderJson);
    end;

    local procedure SetShippingAddress(
        var SalesHeader: Record "Sales Header";
        ShippingJson: JsonObject)
    var
        JsonToken: JsonToken;
    begin
        if ShippingJson.Get('name', JsonToken) then
            SalesHeader."Ship-to Name" :=
                CopyStr(
                    JsonToken.AsValue().AsText(), 1, 100);

        if ShippingJson.Get('address1', JsonToken) then
            SalesHeader."Ship-to Address" :=
                CopyStr(
                    JsonToken.AsValue().AsText(), 1, 100);

        if ShippingJson.Get('city', JsonToken) then
            SalesHeader."Ship-to City" :=
                CopyStr(
                    JsonToken.AsValue().AsText(), 1, 30);

        if ShippingJson.Get('zip', JsonToken) then
            SalesHeader."Ship-to Post Code" :=
                CopyStr(
                    JsonToken.AsValue().AsText(), 1, 20);

        if ShippingJson.Get('country_code', JsonToken) then
            SalesHeader."Ship-to Country/Region Code" :=
                CopyStr(
                    JsonToken.AsValue().AsText(), 1, 10);
    end;

    local procedure CreateSalesLines(
        var SalesHeader: Record "Sales Header";
        OrderJson: JsonObject)
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        JsonToken: JsonToken;
        LineItems: JsonArray;
        LineToken: JsonToken;
        LineJson: JsonObject;
        ItemSKU: Text;
        Qty: Decimal;
        Price: Decimal;
        LineNo: Integer;
    begin
        LineNo := 10000;

        // Get line_items array from Shopify order
        if not OrderJson.Get('line_items', JsonToken) then
            exit;

        LineItems := JsonToken.AsArray();

        foreach LineToken in LineItems do begin
            LineJson := LineToken.AsObject();
            ItemSKU := '';
            Qty := 0;
            Price := 0;

            // Get SKU - this is BC item number
            if LineJson.Get('sku', JsonToken) then
                if not JsonToken.AsValue().IsNull() then
                    ItemSKU :=
                        JsonToken.AsValue().AsText();

            // Get quantity
            if LineJson.Get('quantity', JsonToken) then
                Qty := JsonToken.AsValue().AsDecimal();

            // Get unit price
            if LineJson.Get('price', JsonToken) then
                Price := JsonToken.AsValue().AsDecimal();

            // Skip if no SKU or no quantity
            if (ItemSKU <> '') and (Qty <> 0) then begin
                // Find item in BC by SKU = Item No.
                Item.Reset();
                Item.SetRange("No.", ItemSKU);
                if Item.FindFirst() then begin
                    // Create Sales Line
                    SalesLine.Init();
                    SalesLine."Document Type" :=
                        SalesHeader."Document Type";
                    SalesLine."Document No." :=
                        SalesHeader."No.";
                    SalesLine."Line No." := LineNo;
                    SalesLine.Type :=
                        SalesLine.Type::Item;
                    SalesLine.Validate("No.", Item."No.");
                    SalesLine.Validate(Quantity, Qty);
                    SalesLine.Validate("Unit Price", Price);
                    SalesLine.Insert(true);
                    LineNo += 10000;
                end;
            end;
        end;
    end;

    local procedure GetShopifyOrdersUrl(): Text
    begin
        exit(
            'https://bc-integration-3von3a0f.myshopify.com' +
            '/admin/api/2024-01/orders.json' +
            '?status=any&limit=50'
        );
    end;

    local procedure GetShopifyToken(): Text
    begin
        exit('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');
    end;
}