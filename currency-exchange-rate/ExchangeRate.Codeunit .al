codeunit 50102 "EXchange Rate Mgmt"
{
    procedure FetchAndStoreRates()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        RatesObj: JsonObject;
        Token: JsonToken;
        RatesToken: JsonToken;
        ResponseText: Text;
        Url: Text;
        BaseCode: Text;
        Result: Text;
    begin
        Url := 'https://open.er-api.com/v6/latest/USD';
        Client.Timeout := 30000;

        if not Client.Get(Url, Response) then
            Error('Cannot connect to exchange rate API.\nCheck your internet connection.');

        if not Response.IsSuccessStatusCode then
            Error('Exchange rate API error: %1 — %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

        Response.Content.ReadAs(ResponseText);
        if not JsonObj.ReadFrom(ResponseText) then
            Error('Exchange rate API returned invalid JSON.');

        if JsonObj.Get('result', Token) then begin
            Result := Token.AsValue().AsText();
            if Result <> 'success' then
                Error('API returned failure: %1', Result);
        end;

        if JsonObj.Get('base_code', Token) then
            BaseCode := Token.AsValue().AsText();

        if not JsonObj.Get('rates', RatesToken) then
            Error('No rates data in API response.');

        if not RatesToken.IsObject then
            Error('Rates field is not a valid JSON object.');

        RatesObj := RatesToken.AsObject();

        SaveRatesFromObject(RatesObj, BaseCode);

        Message('Exchange rates updated successfully!\nBase: %1\nTime: %2',
            BaseCode, Format(CurrentDateTime()));
    end;

    local procedure SaveRatesFromObject(
        var RatesObj: JsonObject;
        BaseCode: Text)
    var
        ExRate: Record "Exchange Rate";
        ValToken: JsonToken;
        CurrCode: Text;
        // ✅ Explicit list — no Keys() needed
        Currencies: array[170] of Text;
        i: Integer;
    begin
        // ✅ Define every currency from open.er-api USD response
        Currencies[1] := 'AED';
        Currencies[2] := 'AFN';
        Currencies[3] := 'ALL';
        Currencies[4] := 'AMD';
        Currencies[5] := 'ANG';
        Currencies[6] := 'AOA';
        Currencies[7] := 'ARS';
        Currencies[8] := 'AUD';
        Currencies[9] := 'AWG';
        Currencies[10] := 'AZN';
        Currencies[11] := 'BAM';
        Currencies[12] := 'BBD';
        Currencies[13] := 'BDT';
        Currencies[14] := 'BGN';
        Currencies[15] := 'BHD';
        Currencies[16] := 'BIF';
        Currencies[17] := 'BMD';
        Currencies[18] := 'BND';
        Currencies[19] := 'BOB';
        Currencies[20] := 'BRL';
        Currencies[21] := 'BSD';
        Currencies[22] := 'BTN';
        Currencies[23] := 'BWP';
        Currencies[24] := 'BYN';
        Currencies[25] := 'BZD';
        Currencies[26] := 'CAD';
        Currencies[27] := 'CDF';
        Currencies[28] := 'CHF';
        Currencies[29] := 'CLP';
        Currencies[30] := 'CNY';
        Currencies[31] := 'COP';
        Currencies[32] := 'CRC';
        Currencies[33] := 'CUP';
        Currencies[34] := 'CVE';
        Currencies[35] := 'CZK';
        Currencies[36] := 'DJF';
        Currencies[37] := 'DKK';
        Currencies[38] := 'DOP';
        Currencies[39] := 'DZD';
        Currencies[40] := 'EGP';
        Currencies[41] := 'ERN';
        Currencies[42] := 'ETB';
        Currencies[43] := 'EUR';
        Currencies[44] := 'FJD';
        Currencies[45] := 'FKP';
        Currencies[46] := 'FOK';
        Currencies[47] := 'GBP';
        Currencies[48] := 'GEL';
        Currencies[49] := 'GGP';
        Currencies[50] := 'GHS';
        Currencies[51] := 'GIP';
        Currencies[52] := 'GMD';
        Currencies[53] := 'GNF';
        Currencies[54] := 'GTQ';
        Currencies[55] := 'GYD';
        Currencies[56] := 'HKD';
        Currencies[57] := 'HNL';
        Currencies[58] := 'HRK';
        Currencies[59] := 'HTG';
        Currencies[60] := 'HUF';
        Currencies[61] := 'IDR';
        Currencies[62] := 'ILS';
        Currencies[63] := 'IMP';
        Currencies[64] := 'INR';
        Currencies[65] := 'IQD';
        Currencies[66] := 'IRR';
        Currencies[67] := 'ISK';
        Currencies[68] := 'JEP';
        Currencies[69] := 'JMD';
        Currencies[70] := 'JOD';
        Currencies[71] := 'JPY';
        Currencies[72] := 'KES';
        Currencies[73] := 'KGS';
        Currencies[74] := 'KHR';
        Currencies[75] := 'KID';
        Currencies[76] := 'KMF';
        Currencies[77] := 'KRW';
        Currencies[78] := 'KWD';
        Currencies[79] := 'KYD';
        Currencies[80] := 'KZT';
        Currencies[81] := 'LAK';
        Currencies[82] := 'LBP';
        Currencies[83] := 'LKR';
        Currencies[84] := 'LRD';
        Currencies[85] := 'LSL';
        Currencies[86] := 'LYD';
        Currencies[87] := 'MAD';
        Currencies[88] := 'MDL';
        Currencies[89] := 'MGA';
        Currencies[90] := 'MKD';
        Currencies[91] := 'MMK';
        Currencies[92] := 'MNT';
        Currencies[93] := 'MOP';
        Currencies[94] := 'MRU';
        Currencies[95] := 'MUR';
        Currencies[96] := 'MVR';
        Currencies[97] := 'MWK';
        Currencies[98] := 'MXN';
        Currencies[99] := 'MYR';
        Currencies[100] := 'MZN';
        Currencies[101] := 'NAD';
        Currencies[102] := 'NGN';
        Currencies[103] := 'NIO';
        Currencies[104] := 'NOK';
        Currencies[105] := 'NPR';
        Currencies[106] := 'NZD';
        Currencies[107] := 'OMR';
        Currencies[108] := 'PAB';
        Currencies[109] := 'PEN';
        Currencies[110] := 'PGK';
        Currencies[111] := 'PHP';
        Currencies[112] := 'PKR';
        Currencies[113] := 'PLN';
        Currencies[114] := 'PYG';
        Currencies[115] := 'QAR';
        Currencies[116] := 'RON';
        Currencies[117] := 'RSD';
        Currencies[118] := 'RUB';
        Currencies[119] := 'RWF';
        Currencies[120] := 'SAR';
        Currencies[121] := 'SBD';
        Currencies[122] := 'SCR';
        Currencies[123] := 'SDG';
        Currencies[124] := 'SEK';
        Currencies[125] := 'SGD';
        Currencies[126] := 'SHP';
        Currencies[127] := 'SLE';
        Currencies[128] := 'SLL';
        Currencies[129] := 'SOS';
        Currencies[130] := 'SRD';
        Currencies[131] := 'SSP';
        Currencies[132] := 'STN';
        Currencies[133] := 'SYP';
        Currencies[134] := 'SZL';
        Currencies[135] := 'THB';
        Currencies[136] := 'TJS';
        Currencies[137] := 'TMT';
        Currencies[138] := 'TND';
        Currencies[139] := 'TOP';
        Currencies[140] := 'TRY';
        Currencies[141] := 'TTD';
        Currencies[142] := 'TVD';
        Currencies[143] := 'TWD';
        Currencies[144] := 'TZS';
        Currencies[145] := 'UAH';
        Currencies[146] := 'UGX';
        Currencies[147] := 'USD';
        Currencies[148] := 'UYU';
        Currencies[149] := 'UZS';
        Currencies[150] := 'VES';
        Currencies[151] := 'VND';
        Currencies[152] := 'VUV';
        Currencies[153] := 'WST';
        Currencies[154] := 'XAF';
        Currencies[155] := 'XCD';
        Currencies[156] := 'XDR';
        Currencies[157] := 'XOF';
        Currencies[158] := 'XPF';
        Currencies[159] := 'YER';
        Currencies[160] := 'ZAR';
        Currencies[161] := 'ZMW';
        Currencies[162] := 'ZWL';

        for i := 1 to 162 do begin
            if Currencies[i] <> '' then begin
                if RatesObj.Get(Currencies[i], ValToken) then begin
                    if not ExRate.Get(Currencies[i]) then begin
                        ExRate.Init();
                        ExRate.CurrencyCode := CopyStr(Currencies[i], 1, 10);
                        ExRate.Insert(true);
                    end;
                    ExRate.Rate := ValToken.AsValue().AsDecimal();
                    ExRate.BaseCurrency := CopyStr(BaseCode, 1, 10);
                    ExRate.LastUpdated := CurrentDateTime();
                    ExRate.FetchStatus := 'Success';
                    ExRate.Modify(true);
                end;
            end;
        end;
    end;

    procedure FetchSpecificCurrencies()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        RatesObj: JsonObject;
        Token: JsonToken;
        RatesToken: JsonToken;   // ✅ fixed: was missing, Token was used instead
        ResponseText: Text;
        ExRate: Record "Exchange Rate";
        Url: Text;
        BaseCode: Text;
        Currencies: array[6] of Text;
        i: Integer;
        CurrRate: Decimal;
    begin
        // ✅ Fixed: array was never populated
        Currencies[1] := 'EUR';
        Currencies[2] := 'GBP';
        Currencies[3] := 'PKR';
        Currencies[4] := 'AED';
        Currencies[5] := 'SAR';
        Currencies[6] := 'JPY';

        Url := 'https://open.er-api.com/v6/latest/USD';
        Client.Timeout := 30000;

        if not Client.Get(Url, Response) then
            Error('Cannot connect to Exchange Rate API. Please check your internet connection.');

        if not Response.IsSuccessStatusCode() then
            Error('API request failed with status code %1: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

        Response.Content.ReadAs(ResponseText);

        if not JsonObj.ReadFrom(ResponseText) then
            Error('Exchange Rate API returned invalid JSON.');

        if JsonObj.Get('base_code', Token) then
            BaseCode := Token.AsValue().AsText();

        // ✅ Fixed: assign to RatesToken not Token
        if not JsonObj.Get('rates', RatesToken) then
            Error('No rates data found in API response.');

        if not RatesToken.IsObject then
            Error('Rates field is not a valid JSON object.');

        RatesObj := RatesToken.AsObject();

        for i := 1 to 6 do begin
            if RatesObj.Get(Currencies[i], Token) then begin
                CurrRate := Token.AsValue().AsDecimal();

                if not ExRate.Get(Currencies[i]) then begin
                    ExRate.Init();
                    ExRate.CurrencyCode := CopyStr(Currencies[i], 1, 10);
                    ExRate.Insert(true);
                end;
                ExRate.Rate := CurrRate;
                ExRate.BaseCurrency := CopyStr(BaseCode, 1, 10);
                ExRate.LastUpdated := CurrentDateTime();
                ExRate.FetchStatus := 'Success';
                ExRate.Modify(true);
            end;
        end;

        Message('Specific rates updated!\nEUR · GBP · PKR · AED · SAR · JPY');
    end;

    procedure GetRate(CurrencyCode: Code[10]): Decimal
    var
        ExRate: Record "Exchange Rate";
    begin
        if not ExRate.Get(CurrencyCode) then
            Error('Exchange rate for %1 not found. Please fetch rates first.', CurrencyCode);
        exit(ExRate.Rate);
    end;

    procedure ConvertFromUSD(Amount: Decimal; ToCurrency: Code[10]): Decimal
    var
        Rate: Decimal;
    begin
        Rate := GetRate(ToCurrency);
        if Rate = 0 then
            Error('Exchange rate for %1 is zero. Cannot convert.', ToCurrency);
        exit(Amount * Rate);
    end;
}