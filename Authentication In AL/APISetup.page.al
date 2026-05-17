page 50103 "API_Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "API Setup";
    Caption = 'API Setup';

    layout
    {
        area(Content)
        {
            group(Connection)
            {
                Caption = 'Connection';
                field(PrimaryKey; Rec.PrimaryKey) { ApplicationArea = All; }
                field(BaseUrl; Rec.BaseUrl) { ApplicationArea = All; }
                field(AuthType; Rec.AuthType) { ApplicationArea = All; }
            }
            group(ApiKeyAuth)
            {
                Caption = 'API Key';
                field(ApiKey; Rec.ApiKey) { ApplicationArea = All; }
            }
            group(BasicAuthGroup)
            {
                Caption = 'Basic Auth';
                field(Username; Rec.Username) { ApplicationArea = All; }
                field(Password; Rec.Password) { ApplicationArea = All; }
            }
            group(OAuthGroup)
            {
                Caption = 'OAuth / Bearer Token';
                field(ClientId; Rec.ClientId) { ApplicationArea = All; }
                field(ClientSecret; Rec.ClientSecret) { ApplicationArea = All; }
                field(TokenEndpoint; Rec.TokenEndpoint) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestConnection)
            {
                Caption = 'Test Connection';
                ApplicationArea = All;
                Image = TestFile;
                ToolTip = 'Test the API connection with current setup.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    MyCodeunit: Codeunit MyCodeunit;
                begin
                    // Call the MyCodeunit to test connection with all auth types
                    MyCodeunit.CallAPIWithSetup();
                    Message('✅ Connection successful!');
                end;
            }
        }
    }
}