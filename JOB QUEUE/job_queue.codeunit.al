codeunit 50105 "Nightly API Sync"
{
    trigger OnRun()
    begin
        SyncAllData();
    end;

    procedure SyncAllData()
    var
        LogEntry: Record "Job Queue Log";
        StartTime: DateTime;
        TotalRecs: Integer;
    begin
        StartTime := CurrentDateTime();

        LogEntry.Init();
        LogEntry.RunDateTime := StartTime;
        LogEntry.JobName := 'Nightly Full Sync';
        LogEntry.Status := LogEntry.Status::Started;
        LogEntry.Insert(true);


        TotalRecs := 0;

        TotalRecs += SyncExchangeRates();

        TotalRecs += SyncAPIUsers();

        LogEntry.Status := LogEntry.Status::Success;
        LogEntry.RecordsSynced := TotalRecs;
        LogEntry.FinishedAt := CurrentDateTime();
        LogEntry.DurationSeconds := Round((CurrentDateTime() - StartTime) / 1000, 0.01);
        LogEntry.Modify(true);


        Message('Nightly sync completed!\n' + 
        'Records synced: %1\n' + 
        'Duration: %2 seconds',
         TotalRecs, LogEntry.DurationSeconds);

    end;

    procedure SyncExchangeRates(): Integer
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        RatesObj: JsonObject;
        Token: JsonToken;
        RatesToken: JsonToken;
        ResponseText: Text;
        ExRate: Record "Exchange Rate";
        Keys: List of [Text];
        ValToken: JsonToken;
        CurrCode: Text;
        BaseCode: Text;
        Count: Integer;
        LogEntry: Record "Job Queue Log";
        StartTime: DateTime;

    begin
        StartTime := CurrentDateTime();
        Count := 0;



        LogEntry.Init();
        LogEntry.RunDateTime := StartTime;
        LogEntry.JobName := 'Exchange Rate Sync';
        LogEntry.Status := LogEntry.Status::Started;
        LogEntry.Insert(true);



        Client.Timeout := 30000;


        if not Client.Get('https://open.er-api.com/v6/latest/USD',
                        Response) then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'Cannot connect to exchange rate API.';
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;

        if not Response.IsSuccessStatusCode then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'API error: ' + Response.ReasonPhrase();
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;

        Response.Content.ReadAs(ResponseText);

        if not JsonObj.ReadFrom(ResponseText) then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'Invalid JSON form API.';
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;

        if not RatesToken.IsObject then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'Unexpected JSON format from API.';
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;

        RatesObj := RatesToken.AsObject();
        Keys := RatesObj.Keys();

        foreach CurrCode in Keys do begin
            if RatesObj.Get(CurrCode, ValToken) then begin
                if not ExRate.Get(CurrCode) then begin
                    ExRate.Init();
                    ExRate.CurrencyCode := CopyStr(CurrCode, 1, 3);
                    ExRate.Insert(true);
                end;
                ExRate.Rate := ValToken.AsValue().AsDecimal();
                ExRate.BaseCurrency := CopyStr(BaseCode, 1, 3);
                ExRate.LastUpdated := CurrentDateTime();
                ExRate.FetchStatus := 'Job Queue Sync';
                ExRate.Modify(true);
            end;
        end;

        LogEntry.Status := LogEntry.Status::Success;
        LogEntry.RecordsSynced := Keys.Count;
        LogEntry.FinishedAt := CurrentDateTime();
        LogEntry.DurationSeconds := Round((CurrentDateTime() - StartTime) / 1000, 0.01);
        LogEntry.Modify(true);
        exit(Keys.Count);
    end;

    procedure SyncAPIUsers(): Integer
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JsonArr: JsonArray;
        JsonObj: JsonObject;
        NestedObj: JsonObject;
        Token: JsonToken;
        ResponseText: Text;
        UserData: Record "User API Data";
        LogEntry: Record "Job Queue Log";
        StartTime: DateTime;
        UserId: Integer;
        i: Integer;
    begin
        StartTime := CurrentDateTime();

        // ── Log start ─────────────────────────────────
        LogEntry.Init();
        LogEntry.RunDateTime := StartTime;
        LogEntry.JobName := 'API User Sync';
        LogEntry.Status := LogEntry.Status::Started;
        LogEntry.Insert(true);

        Client.Timeout := 30000;

        if not Client.Get(
            'https://jsonplaceholder.typicode.com/users',
            Response) then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'Cannot connect to users API.';
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;

        if not Response.IsSuccessStatusCode then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage :=
                'API error: ' + Response.ReasonPhrase();
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;


        Response.Content.ReadAs(ResponseText);

        if not JsonArr.ReadFrom(ResponseText) then begin
            LogEntry.Status := LogEntry.Status::Failed;
            LogEntry.ErrorMessage := 'Response is not a JSON array.';
            LogEntry.FinishedAt := CurrentDateTime();
            LogEntry.Modify(true);
            exit(0);
        end;


        for i := 0 to JsonArr.Count - 1 do begin
            JsonArr.Get(i, Token);
            JsonObj := Token.AsObject();

            UserId := 0;
            if JsonObj.Get('id', Token) then
                UserId := Token.AsValue().AsInteger();

            if UserId > 0 then begin
                if not UserData.Get(UserId) then begin
                    UserData.Init();
                    UserData.ID := UserId;
                    UserData.Insert(true);
                end;

                if JsonObj.Get('name', Token) then
                    UserData.Name :=
                        CopyStr(Token.AsValue().AsText(), 1, 100);

                if JsonObj.Get('email', Token) then
                    UserData.Email :=
                        CopyStr(Token.AsValue().AsText(), 1, 100);

                if JsonObj.Get('phone', Token) then
                    UserData.Phone :=
                        CopyStr(Token.AsValue().AsText(), 1, 50);

                if JsonObj.Get('company', Token) then
                    if Token.IsObject then begin
                        NestedObj := Token.AsObject();
                        if NestedObj.Get('name', Token) then
                            UserData.CompanyName :=
                                CopyStr(Token.AsValue().AsText(), 1, 100);
                    end;

                UserData.LastSyncDateTime := CurrentDateTime();
                UserData.LastMethod := 'Job Queue';
                UserData.LastStatus := '200';
                UserData.LastMessage := 'Synced by Job Queue';
                UserData.Modify(true);
            end;
        end;

        // ── Log success ───────────────────────────────
        LogEntry.Status := LogEntry.Status::Success;
        LogEntry.RecordsSynced := JsonArr.Count;
        LogEntry.FinishedAt := CurrentDateTime();
        LogEntry.DurationSeconds :=
            Round((CurrentDateTime() - StartTime) / 1000, 0.01);
        LogEntry.Modify(true);

        exit(JsonArr.Count);
    end;
}




