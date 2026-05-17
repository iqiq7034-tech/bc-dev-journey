codeunit 50100 "API Logger"
{
    procedure LogAPICall(
        Method: Text;
        Url: Text;
        StatusCode: Text;
        StatusMessage: Text;
        IsSuccess: Boolean;
        ErrorDetails: Text
    )
    var
        LogEntry: Record "API Error Log";
    begin
        LogEntry.Init();
        LogEntry.LogDateTime := CurrentDateTime;
        LogEntry.Method := CopyStr(Method, 1, 10);
        LogEntry.Url := CopyStr(Url, 1, 250);
        LogEntry.StatusCode := CopyStr(StatusCode, 1, 10);
        LogEntry.StatusMessage := CopyStr(StatusMessage, 1, 250);
        LogEntry.Success := IsSuccess;
        LogEntry.ErrorDetails := CopyStr(ErrorDetails, 1, 500);
        LogEntry.Insert(true);

    end;








}


