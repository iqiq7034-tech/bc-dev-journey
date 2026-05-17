codeunit 50107 "API Health Checker"
{
    procedure RunHealthCheck()
    var
        HealthLog: Record "API Health Log";
        Client: HttpClient;
        Response: httpResponseMessage;
        StartTime: DateTime;
        EndTime: DateTime;
        URL: Text;
    begin
        Url := 'http://localhost:7048/BC230/api/v2.0/companies';

        HealthLog.Init();
        HealthLog.CheckedAt := CurrentDateTime();
        HealthLog.EndpointUrl := CopyStr(URL, 1, 250);


        StartTime := CurrentDateTime();
        if Client.Get(URL, Response) then begin
            EndTime := CurrentDateTime();
            HealthLog.StatusCode := Response.HttpStatusCode();
            HealthLog.IsHealthy := Response.IsSuccessStatusCode();
            HealthLog.ResponseTimeMs := EndTime - StartTime;
        end else begin
            EndTime := CurrentDateTime();
            HealthLog.StatusCode := 0;
            HealthLog.IsHealthy := false;
            HealthLog.ErrorMessage := 'Connection failed - host unreachable';
            HealthLog.ResponseTimeMs := EndTime - StartTime;
        end;
        HealthLog.Insert(true);
    end;


    procedure GetLastWebhookInfo(
       var LastRecieved: DateTime;
       var TotalCount: Integer;
       var UnProcessedCount: Integer
    )
    var
        WebhookLog: Record "API Health Log";
    begin
        TotalCount := WebhookLog.Count();

        WebhookLog.SetCurrentKey(CheckedAt);
        if WebhookLog.FindLast() then
            LastRecieved := WebhookLog.CheckedAt
        else
            LastRecieved := 0DT;


        WebhookLog.Reset();
        UnProcessedCount := WebhookLog.Count();
    end;


    procedure GetLastHealthStatus(
       var LastChecked: DateTime;
       var LastStatusCode: Integer;
       var LastHealthy: Boolean;
       var LastresponseMs: Integer)
    var
        HealthLog: Record "API Health Log";
    begin
        HealthLog.SetCurrentKey(CheckedAt);
        if HealthLog.FindLast() then begin
            LastChecked := HealthLog.CheckedAt;
            LastHealthy := HealthLog.IsHealthy;
            LastStatusCode := HealthLog.StatusCode;
            LastresponseMs := HealthLog.ResponseTimeMs;
        end else begin
            LastChecked := 0DT;
            LastHealthy := false;
            LastStatusCode := 0;
            LastresponseMs := 0;
        end;
    end;
}