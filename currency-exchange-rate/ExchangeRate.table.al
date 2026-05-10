table 50104 "Exchange Rate"
{
    Caption = 'Exchange Rate';
    DataClassification = CustomerContent;

    fields
    {
        // Primary key — the currency code e.g. EUR GBP PKR
        field(1; CurrencyCode; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }

        // The exchange rate value vs USD
        field(2; Rate; Decimal)
        {
            Caption = 'Rate vs USD';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 6;
        }

        // Base currency — always USD in this project
        field(3; BaseCurrency; Code[10])
        {
            Caption = 'Base Currency';
            DataClassification = CustomerContent;
        }

        // When this rate was last fetched
        field(4; LastUpdated; DateTime)
        {
            Caption = 'Last Updated';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // Was the last fetch successful
        field(5; FetchStatus; Text[50])
        {
            Caption = 'Fetch Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; CurrencyCode) { Clustered = true; }
    }
}