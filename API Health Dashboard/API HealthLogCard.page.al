page 50110 "API Health Dashboard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'API Health Dashboard';
    Editable = false;

    layout
    {
        area(Content)
        {
            // ── SECTION 1: Webhook Status ─────────────────
            group(WebhookStatus)
            {
                Caption = 'Webhook Status';

                field(LastWebhookReceived; LastWebhookReceived)
                {
                    ApplicationArea = All;
                    Caption = 'Last Webhook Received';
                    ToolTip = 'Timestamp of the most recent incoming webhook.';
                }
                field(TotalWebhooks; TotalWebhooks)
                {
                    ApplicationArea = All;
                    Caption = 'Total Webhooks Logged';
                }
                field(UnprocessedWebhooks; UnprocessedWebhooks)
                {
                    ApplicationArea = All;
                    Caption = 'Unprocessed';
                    Style = Attention;
                    StyleExpr = UnprocessedWebhooks > 0;
                }
            }

            // ── SECTION 2: API Ping Status ─────────────────
            group(APIStatus)
            {
                Caption = 'API Ping Status';

                field(LastCheck; LastCheck)
                {
                    ApplicationArea = All;
                    Caption = 'Last Checked';
                }
                field(LastStatusCode; LastStatusCode)
                {
                    ApplicationArea = All;
                    Caption = 'HTTP Status';
                }
                field(APIHealthy; APIHealthy)
                {
                    ApplicationArea = All;
                    Caption = 'Healthy';
                    Style = Favorable;
                    StyleExpr = APIHealthy;
                }
                field(LastResponseMs; LastResponseMs)
                {
                    ApplicationArea = All;
                    Caption = 'Response Time (ms)';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PingNow)
            {
                Caption = 'Ping API Now';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Run a health check immediately and refresh the dashboard.';

                trigger OnAction()
                var
                    HealthChecker: Codeunit "API Health Checker";
                begin
                    HealthChecker.RunHealthCheck();
                    RefreshData();
                    CurrPage.Update(false);
                    Message('✅ Ping complete. Dashboard refreshed.');
                end;
            }

            action(OpenWebhookLog)
            {
                Caption = 'Open Webhook Log';
                ApplicationArea = All;
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Webhook Log List";
            }

            action(OpenHealthLog)
            {
                Caption = 'Open Health Log';
                ApplicationArea = All;
                Image = History;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Page.Run(Page::"API Health Log List");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RefreshData();
    end;

    var
        LastWebhookReceived: DateTime;
        TotalWebhooks: Integer;
        UnprocessedWebhooks: Integer;
        LastCheck: DateTime;
        LastStatusCode: Integer;
        APIHealthy: Boolean;
        LastResponseMs: Integer;

    local procedure RefreshData()
    var
        HealthChecker: Codeunit "API Health Checker";
    begin
        HealthChecker.GetLastWebhookInfo(
            LastWebhookReceived,
            TotalWebhooks,
            UnprocessedWebhooks);

        HealthChecker.GetLastHealthStatus(
            LastCheck,
            LastStatusCode,
            APIHealthy,
            LastResponseMs);
    end;
}