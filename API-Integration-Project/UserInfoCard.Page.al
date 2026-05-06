page 50100 "User API Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'User API Card';


    layout
    {
        area(Content)
        {
            group(UserInput)
            {
                Caption = 'User Input';
                field(ID; ID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    ToolTip = 'Type user id 1-10 to load the data.';

                }


            }
            group(UserData)
            {
                Caption = 'User Data';
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Name returned from API';
                }
                field(Email; Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Email returned from API';
                }
                field(Phone; Phone)
                {
                    ApplicationArea = All;
                    Caption = 'Phone';
                    ToolTip = 'Phone returned from API';
                }
                field(CompanyName; CompanyName)
                {
                    ApplicationArea = All;
                    Caption = 'Company';
                    ToolTip = 'Companyname returned form API';
                }


            }
            group(StatusInfo)
            {
                Caption = 'Last API Status';
                field(LastStatus; LastStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Status Code';
                    ToolTip = 'HTTP status code of last API call.';
                }
                field(LastMethod; LastMethod)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Last Method Used';
                    ToolTip = 'Last HTTP method called.';
                }
                field(LastMessage; LastMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Last Message';
                    ToolTip = 'Result of last API call';
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Get)
            {
                Caption = 'GET User';
                ApplicationArea = All;
                Image = GetEntries;
                ToolTip = 'Fetch user by ID from the API.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GetUserInfo();

                end;
            }

            action(POST)
            {
                Caption = 'POST User';
                ApplicationArea = All;
                Image = Post;
                ToolTip = 'Create a new user via POST.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostUserInfo();
                end;
            }

            action(PUT)
            {
                Caption = 'PUT User';
                ApplicationArea = All;
                Image = UpdateDescription;
                ToolTip = 'Update user via PUT.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PutUserInfo();

                end;
            }

            action(DELETE)
            {
                Caption = 'DELETE User';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete user by ID from the DELETE.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DeleteUserInfo();

                end;
            }

            action(Clear)
            {
                Caption = 'Clear Fields';
                ApplicationArea = All;
                Image = ClearFilter;
                ToolTip = 'Clear all fields.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClearAllFields();

                end;
            }

            action(SavetoBCTable)
            {
                Caption = 'Save to BC Table';
                ApplicationArea = All;
                Image = Save;
                ToolTip = 'Save the fetched API data permanently to BC database.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SaveToTable();
                end;
            }
        }
    }
    procedure LoadRecord(VAR RecToLoad: Record "User API data")
    begin
        ID := RecToLoad.ID;
        Name := RecToLoad.Name;
        Email := RecToLoad.Email;
        Phone := RecToLoad.Phone;
        CompanyName := RecToLoad.CompanyName;
        LastStatus := RecToLoad.LastStatus;
        LastMethod := RecToLoad.LastMethod;
        LastMessage := RecToLoad.LastMessage;
        CurrPage.Update(false);
    end;

    procedure GetUserInfo()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Object: JsonObject;
        Token: JsonToken;
        JsonText: Text;
        Url: Text;
    begin
        if ID <= 0 then
            Error(ErrorInfo.Create('Please Enter a valid user ID (1-10)'));

        Url := 'https://jsonplaceholder.typicode.com/users/' + Format(ID);

        if not Client.Get(Url, Response) then begin
            LastStatus := 'Connection Failed';
            LastMethod := 'Get';
            LastMessage := 'Could not connect to API';
            Error(ErrorInfo.Create('Get request failed, please check your network connection.'));
        end;

        LastStatus := Format(Response.HttpStatusCode());
        LastMethod := 'Get';

        if not Response.IsSuccessStatusCode then begin
            LastMessage := 'Get Failed' + Response.ReasonPhrase();
            Error('API returend error: %1-%2', Response.HttpStatusCode(), Response.ReasonPhrase());
        end;

        Response.Content.ReadAs(JsonText);
        if not Object.ReadFrom(JsonText) then
            Error(ErrorInfo.Create('Response was not valid Json'));

        if Object.Get('name', Token) then
            Name := Token.AsValue().AsText();

        if Object.Get('email', Token) then
            Email := Token.AsValue().AsText();

        if Object.Get('phone', Token) then
            Phone := Token.AsValue().AsText();

        if Object.Get('company', Token) then
            if Token.AsObject().Get('name', Token) then
                CompanyName := Token.AsValue().AsText();
        LastMessage := 'GET Successful--User loaded.';
        CurrPage.Update();



    end;

    local procedure PostUserInfo()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RequestObj: JsonObject;
        ResponseObj: JsonObject;
        Token: JsonToken;
        JsonText: Text;
        ResponseText: Text;
        Url: Text;

    begin
        if Name = '' then
            Error('Please Enter a Name before enter the post.');

        Url := 'https://jsonplaceholder.typicode.com/users';

        RequestObj.Add('name', Name);
        RequestObj.Add('email', Email);
        RequestObj.Add('phone', Phone);
        RequestObj.Add('username', Name);
        RequestObj.WriteTo(JsonText);

        //  set content type header
        Content.WriteFrom(JsonText);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        // Buil request
        Request.Method := 'Post';
        Request.SetRequestUri(Url);
        Request.Content := Content;

        if not Client.Send(Request, Response) then begin
            LastMethod := 'POST';
            LastStatus := 'Failed';
            Error('Post rrequest failed. Check connection');

        end;


        LastStatus := Format(Response.HttpStatusCode());
        LastMethod := 'POST';

        if not Response.IsSuccessStatusCode then begin

            Error('POST failed: %1', Response.ReasonPhrase());
        end;

        Response.Content.ReadAs(ResponseText);
        if ResponseObj.ReadFrom(ResponseText) then
            if ResponseObj.Get('id', Token) then begin
                ID := Token.AsValue().AsInteger();
                LastMessage := 'POST successful! New ID: ' +
                    Format(Token.AsValue().AsInteger());
                SaveToTable();
                CurrPage.Update();
                Message('POST successful!\nNew user created with ID: %1',
                    Token.AsValue().AsInteger());

            end;

    end;

    local procedure PutUserInfo()
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RequestObj: JsonObject;
        JsonText: Text;
        Url: Text;
    begin
        if ID <= 0 then
            Error('Please enter a User ID before updating.');

        if Name = '' then
            Error('Please enter a Name before sending PUT.');

        // PUT targets specific record by ID
        Url := 'https://jsonplaceholder.typicode.com/users/' + Format(ID);

        RequestObj.Add('id', ID);
        RequestObj.Add('name', Name);
        RequestObj.Add('email', Email);
        RequestObj.Add('phone', Phone);
        RequestObj.Add('username', Name);
        RequestObj.WriteTo(JsonText);

        Content.WriteFrom(JsonText);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        // Build request
        Request.Method := 'PUT';
        Request.SetRequestUri(Url);
        Request.Content := Content;

        // Send
        if not Client.Send(Request, Response) then begin
            LastMethod := 'PUT';
            LastStatus := 'Failed';

            Error('PUT request failed. Check connection.');
        end;

        LastStatus := Format(Response.HttpStatusCode());
        LastMethod := 'PUT';

        if not Response.IsSuccessStatusCode then begin
            LastMessage := 'PUT failed: ' + Response.ReasonPhrase();

            Error('PUT failed: %1', Response.ReasonPhrase());
        end;

        LastMessage := 'PUT successful! User ' + Format(ID) + ' fully updated.';
        Message('PUT successful!\nUser %1 has been fully updated.', ID);
        SaveToTable();
        CurrPage.Update();

    end;


    local procedure DeleteUserInfo()
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Url: Text;
    begin
        if ID <= 0 then
            Error('Please enter a User ID before deleting.');

        // Confirm before deleting
        if not Confirm('Are you sure you want to DELETE user %1?\nThis cannot be undone.', false, ID) then
            exit;

        // DELETE targets specific record by ID
        Url := 'https://jsonplaceholder.typicode.com/users/' + Format(ID);

        // DELETE has no body — just method and URL
        Request.Method := 'DELETE';
        Request.SetRequestUri(Url);
        if not Client.Send(Request, Response) then begin
            LastMethod := 'DELETE';
            LastStatus := 'Failed';

            Error('DELETE request failed. Check connection.');
        end;

        if not Response.IsSuccessStatusCode then begin
            LastMessage := 'DELETE failed: ' + Response.ReasonPhrase();
            Error('DELETE failed: %1', Response.ReasonPhrase());
        end;

        // Clear all fields after successful delete
        ClearAllFields();
        LastMessage := 'DELETE successful! User removed.';
        CurrPage.Update();
        Message('DELETE successful!\nUser has been removed from the system.');



    end;


    local procedure ClearAllFields()

    begin
        ID := 0;
        Name := '';
        Email := '';
        Phone := '';
        CompanyName := '';
        LastStatus := '';
        LastMethod := '';
        LastMessage := '';
        CurrPage.Update(false);
    end;

    procedure SaveToTable()
    var
        UserAPIdata: Record "User API data";
    begin
        if not UserAPIdata.Get(ID) then begin
            UserAPIdata.Init();
            UserAPIdata.ID := ID;
            UserAPIdata.Insert(true);
        end;

        UserAPIData.Name := Name;
        UserAPIData.Email := Email;
        UserAPIData.Phone := Phone;
        UserAPIData.CompanyName := CompanyName;
        UserAPIData.LastStatus := LastStatus;
        UserAPIData.LastMethod := LastMethod;
        UserAPIData.LastMessage := LastMessage;
        UserAPIData.LastSyncDateTime := CurrentDateTime();
        UserAPIData.Modify(true);

        Message('User %1 — %2 saved to BC table successfully!', ID, Name);
        CurrPage.Update();
    end;


    procedure FetchAllAndStore()
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            ID := i;
            GetUserInfo();
            SaveToTable();
        end;
    end;




    // ── Variables ────────────────────────────────────
    var
        ID: Integer;
        Name: Text;
        Email: Text;
        Phone: Text;
        CompanyName: Text;
        LastStatus: Text;
        LastMethod: Text;
        LastMessage: Text;

}

