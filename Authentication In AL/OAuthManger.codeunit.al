codeunit 50103 "OAuth Manager"
{
    procedure GetValidToken(var Setup: Record "API Setup"): Text

    begin
        if IsTokenValid(Setup) then begin
            exit(Setup.AccessToken);

        end;

        FetchNewToken(Setup);
        exit(Setup.AccessToken);

    end;

    local procedure IsTokenValid(var Setup: Record "API Setup"): Boolean

    begin
        if Setup.AccessToken = '' then
            exit(false);

        if Setup.TokenExpiry = 0DT then
            exit(false);

        if Setup.TokenExpiry > (CurrentDateTime() + 300000) then
            exit(true);

        exit(false);

    end;

    procedure FetchNewToken(var Setup: Record "API Setup")
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        Requestbody: Text;
        ResponseText: Text;
        ResponseObj: JsonObject;
        Token: JsonToken;
        AccessToken: Text;
        ExpiresIn: Integer;
    begin
        if Setup.TokenEndpoint = '' then
            Error('Token Endpoint is not configured in API setup.');

        if Setup.ClientId = '' then
            Error('Client ID is not configured in API setup.');

        if Setup.ClientSecret = '' then
            Error('Client Secret is not configured in API setup.');

        Requestbody := 'grant_type=client_credentials&client_id=' + Setup.ClientId + '&client_secret=' + Setup.ClientSecret;

        if Setup.Scope <> '' then
            Requestbody += '&scope=' + Setup.Scope;

        Content.WriteFrom(Requestbody);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');


        Request.Method := 'POST';
        Request.SetRequestUri(Setup.TokenEndpoint);
        Request.Content := Content;

        Client.Timeout := 30000;
        if not Client.Send(Request, Response) then
            Error('Cannot connect to OAuth server. Please check the Token Endpoint URL.');


        if not Response.IsSuccessStatusCode() then
            Error('OAuth Token request failed: %1 - %2', Format(Response.HttpStatusCode()), Response.ReasonPhrase());

        Response.Content.ReadAs(ResponseText);
        if not ResponseObj.ReadFrom(ResponseText) then
            Error('Invalid response from OAuth server. Response: %1', ResponseText);

        if not ResponseObj.Get('access_token', Token) then
            Error('Response does not contain access_token. Response: %1', ResponseText);
        AccessToken := Token.AsValue().AsText();

        if AccessToken = '' then
            Error('OAuth server returened empty access token.');

        ExpiresIn := 3600; // Default to 1 hour if not provided
        if ResponseObj.Get('expires_in', Token) then
            ExpiresIn := Token.AsValue().AsInteger();

        Setup.AccessToken := CopyStr(AccessToken, 1, 1000); // Truncate if token is too long for the field
        Setup.TokenExpiry := CurrentDateTime() + ExpiresIn * 1000;
        Setup.Modify();

        Message('New token obtained. \nExpires in: %1 minutes', ExpiresIn / 60);
    end;


    procedure CallProtectedAPI(var setup: Record "API Setup"; URL: Text; var Response: HttpResponseMessage): Boolean
    var
        Client: HttpClient;
        ValidToken: Text;
    begin
        ValidToken := GetValidToken(setup);

        Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + ValidToken);

        Client.Timeout := 30000;

        if not Client.Get(URL, Response) then begin
            if Response.HttpStatusCode() = 401 then begin
                setup.AccessToken := '';
                setup.Modify(true);
                ValidToken := GetValidToken(setup);
                Client.DefaultRequestHeaders.Remove('Authorization');
                Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + ValidToken);
                exit(Client.Get(URL, Response));
            end;
            exit(false);
        end;
        exit(true);
    end;

    procedure CheckStatusCode(var Setup: Record "API Setup")
    var
        MinutesLeft: Integer;
    begin
        if Setup.AccessToken = '' then begin
            Message('No token — will fetch on next API call');
            exit;
        end;

        if Setup.TokenExpiry = 0DT then begin
            Message('Token exists but no expiry set');
            exit;
        end;

        if Setup.TokenExpiry <= CurrentDateTime() then begin
            Message('Token EXPIRED — will refresh on next API call');
            exit;
        end;

        MinutesLeft := (Setup.TokenExpiry - CurrentDateTime()) div 60000;
        Message('Token valid — expires in ' + Format(MinutesLeft) + ' minutes');
    end;

    procedure ForceExpireToken(var Setup: Record "API Setup")
    begin
        Setup.TokenExpiry := CurrentDateTime() - 1000;
        Setup.Modify();
        Message('✅ Token has been force expired. It will be refreshed on next API call.');
    end;
}