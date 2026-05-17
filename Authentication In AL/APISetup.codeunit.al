codeunit 50101 MyCodeunit
{


    procedure GetSetup(): Record "API Setup"
    var
        Setup: Record "API Setup";
    begin
        Setup.Get('DEFAULT');
        exit(Setup);
    end;

    procedure CallAPIWithSetup()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Setup: Record "API Setup";
        Base64: Codeunit "Base64 Convert";
        Encoded: Text;
    begin
        // Read from setup table
        Setup := GetSetup();

        case Setup.AuthType of
            Setup.AuthType::"API Key":
                Client.DefaultRequestHeaders.Add('X-API-Key', Setup.ApiKey);

            Setup.AuthType::"Basic Auth":
                begin
                    Encoded := Base64.ToBase64(Setup.Username + ':' + Setup.Password);
                    Client.DefaultRequestHeaders.Add('Authorization', 'Basic ' + Encoded);
                end;

            Setup.AuthType::"Bearer Token":
                Client.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + GetBearerToken());
        end;

        if not Client.Get(Setup.BaseUrl, Response) then
            Error('Connection failed.')
        else
            if Response.IsSuccessStatusCode then
                Message('✅ Connection successful!')
            else
                Error('API Error: %1', Response.ReasonPhrase());
    end;

    local procedure GetBearerToken(): Text
    begin
        Error('GetBearerToken not implemented. Please configure token retrieval logic.');
    end;
}