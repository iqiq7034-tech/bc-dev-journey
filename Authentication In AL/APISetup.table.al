table 50103 "API Setup"
{
    Caption = 'API Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; BaseUrl; Text[250])
        {
            Caption = 'Base URL';
            DataClassification = CustomerContent;
        }
        field(3; ApiKey; Text[250])
        {
            Caption = 'API Key';
            DataClassification = CustomerContent;
        }
        field(4; Username; Text[100])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
        field(5; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }
        field(6; ClientId; Text[250])
        {
            Caption = 'Client ID';
            DataClassification = CustomerContent;
        }
        field(7; ClientSecret; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = CustomerContent;
        }
        field(8; TokenEndpoint; Text[250])
        {
            Caption = 'Token Endpoint';
            DataClassification = CustomerContent;
        }
        field(9; AuthType; Option)
        {
            Caption = 'Auth Type';
            OptionMembers = "None","API Key","Basic Auth","Bearer Token";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; PrimaryKey) { Clustered = true; }
    }
}