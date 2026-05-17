codeunit 50104 "Webhook Manager"
{
    procedure ProcessIncomingNotification(var WebhookLog: Record "Webhook Log")
    var
        JsonObj: JsonObject;
        ValueArr: JsonArray;
        ItemToken: JsonToken;
        ItemObj: JsonObject;
        Token: JsonToken;
        ChangeType: Text;
        Resource: Text;
        ClientState: Text;
    begin
        if WebhookLog.Payload = '' then begin
            WebhookLog.ErrorMessage := 'Empty payload Recieved';
            exit;
        end;

        if not JsonObj.ReadFrom(WebhookLog.Payload) then begin
            WebhookLog.ErrorMessage := 'Invalid JSON payload';
            exit;
        end;

        if not JsonObj.Get('value', Token) then begin
            WebhookLog.ErrorMessage :=
                'No value array in payload.';
            exit;
        end;

        if not Token.IsArray then begin
            WebhookLog.ErrorMessage :=
                'Value is not an array.';
            exit;
        end;

        ValueArr := Token.AsArray();

        if ValueArr.Count = 0 then begin
            WebhookLog.ErrorMessage := 'Empty value array in payload.';
            exit;
        end;

        ValueArr.Get(0, ItemToken);

        if not ItemToken.IsObject then begin
            WebhookLog.ErrorMessage := 'Item in value array is not a JSON object.';
            exit;
        end;

        ItemObj := ItemToken.AsObject();

        if ItemObj.Get('changeType', Token) then
            ChangeType := Token.AsValue().AsText();

        if ItemObj.Get('resource', Token) then
            Resource := Token.AsValue().AsText();

        if ItemObj.Get('clientState', Token) then
            ClientState := Token.AsValue().AsText();

        Evaluate(WebhookLog.EventType, ChangeType);
        WebhookLog.ResourceType := CopyStr(Resource, 1, 100);
        WebhookLog.ClientState := CopyStr(ClientState, 1, 100);
        WebhookLog.Processed := false;

        case ChangeType of
            'created':
                HandleCreatedEvent(Resource, WebhookLog);
            'updated':
                HandleUpdatedEvent(Resource, WebhookLog);
            'deleted':
                HandleDeletedEvent(Resource, WebhookLog);
        end;

    end;


    // PROCEDURE 2: Handlers for different event types
    procedure HandleCreatedEvent(
        Resource: Text;
        var WebhookLog: Record "Webhook Log")
    begin
        WebhookLog.ErrorMessage := '';
        Message('New record created!\nResources: %1', Resource, WebhookLog.EntryNo);
    end;

    procedure HandleUpdatedEvent(
        Resource: Text;
        var WebhookLog: Record "Webhook Log")
    begin
        WebhookLog.ErrorMessage := '';
        Message('Record Updated!\nResources: %1', Resource, WebhookLog.EntryNo);
    end;

    procedure HandleDeletedEvent(
        Resource: Text;
        var WebhookLog: Record "Webhook Log")
    begin
        WebhookLog.ErrorMessage := '';
        Message('Record Deleted!\nResources: %1', Resource, WebhookLog.EntryNo);
    end;



    procedure RegisterBCSubscription(
        ExternalUrl: Text;
        ClientSecret: Text): Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RequestObj: JsonObject;
        ResponseObj: JsonObject;
        Token: JsonToken;
        JsonText: Text;
        ResponseText: Text;
        SubscriptionId: Text;
        ExpiryDate: Text;
        Url: Text;
    begin

        Url := 'http://localhost:7048/BC230/api/v2.0/subscriptions';
        ExpiryDate :=
              Format(Today() + 30, 0, '<Year4>-<Month,2>-<Day,2>') +
              'T23:59:59Z';
        RequestObj.Add('notificationUrl', ExternalUrl);
        RequestObj.Add('resource', 'api/v2.0/customers');
        RequestObj.Add('clientState', ClientSecret);
        RequestObj.Add('expirationDateTime', ExpiryDate);
        RequestObj.WriteTo(JsonText);


        Content.WriteFrom(JsonText);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');


        Request.Method := 'POST';
        Request.SetRequestUri(Url);
        Request.Content := Content;

        Client.Timeout := 30000;
        if not Client.Send(Request, Response) then
            Error('Cannot connect to BC subscription API.');

        if not Response.IsSuccessStatusCode then begin
            Response.Content.ReadAs(ResponseText);
            Error('Subscription failed: %1\n%2',
                Response.ReasonPhrase(),
                ResponseText);
        end;
        Response.Content.ReadAs(ResponseText);
        if ResponseObj.ReadFrom(ResponseText) then
            if ResponseObj.Get('subscriptionId', Token) then
                SubscriptionId := Token.AsValue().AsText();
        Message('Subscription created!\nID: %1\nExpires: %2',
                    SubscriptionId, ExpiryDate);

        exit(SubscriptionId);


    end;

    procedure SimulateIncomingWebhook()
    var
        WebhookLog: Record "Webhook Log";
        FakePayload: Text;
    begin
        FakePayload :=
               '{' +
               '  "value": [' +
               '    {' +
               '      "subscriptionId": "test-sub-001",' +
               '      "clientState": "secret123",' +
               '      "changeType": "created",' +
               '      "resource": "api/v2.0/customers(abc-123)",' +
               '      "resourceData": {}' +
               '    }' +
               '  ]' +
               '}';
        WebhookLog.Init();
        WebhookLog.ReceivedAt := CurrentDateTime();
        WebhookLog.Payload := CopyStr(FakePayload, 1, 2048);
        WebhookLog.Source := 'Simulation';
        WebhookLog.Processed := false;
        WebhookLog.Insert(true);

        // Process it
        ProcessIncomingNotification(WebhookLog);
        WebhookLog.Modify(true);
    end;


    procedure GetSubscriptions(): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
        Url: Text;
    begin
        Url := 'http://localhost:7048/BC230/api/v2.0/subscriptions';

        if not Client.Get(Url, Response) then
            Error('Cannot connect to BC API.');

        if not Response.IsSuccessStatusCode then
            Error('Failed: %1', Response.ReasonPhrase());

        Response.Content.ReadAs(ResponseText);
        exit(ResponseText);
    end;

}