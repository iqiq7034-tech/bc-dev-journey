page 50104 "Exchange Rate Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Exchange Rate";
    Caption = 'Exchange Rate Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(CurrencyCode; Rec.CurrencyCode)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
                    ToolTip = 'The ISO currency code, e.g. EUR, GBP, PKR.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Caption = 'Rate vs USD';
                    ToolTip = 'Exchange rate relative to USD.';
                }
                field(BaseCurrency; Rec.BaseCurrency)
                {
                    ApplicationArea = All;
                    Caption = 'Base Currency';
                    ToolTip = 'The base currency used for this rate (always USD).';
                }
            }
            group(Status)
            {
                Caption = 'Status';

                field(LastUpdated; Rec.LastUpdated)
                {
                    ApplicationArea = All;
                    Caption = 'Last Updated';
                    ToolTip = 'When this rate was last fetched from the API.';
                }
                field(FetchStatus; Rec.FetchStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Fetch Status';
                    ToolTip = 'Whether the last fetch was successful.';
                    StyleExpr = StatusStyle;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchThisRate)
            {
                Caption = 'Refresh This Rate';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Re-fetch all rates and refresh this record.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ExRateMgmt: Codeunit "Exchange Rate Mgmt";
                begin
                    ExRateMgmt.FetchAndStoreRates();
                    CurrPage.Update();
                end;
            }
            action(TestConvert)
            {
                Caption = 'Test: Convert 100 USD';
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ExRateMgmt: Codeunit "Exchange Rate Mgmt";
                    PKRAmount: Decimal;
                    EURAmount: Decimal;
                    GBPAmount: Decimal;
                begin
                    PKRAmount := ExRateMgmt.ConvertFromUSD(100, 'PKR');
                    EURAmount := ExRateMgmt.ConvertFromUSD(100, 'EUR');
                    GBPAmount := ExRateMgmt.ConvertFromUSD(100, 'GBP');

                    Message('100 USD =\n%1 PKR\n%2 EUR\n%3 GBP',
                        PKRAmount, EURAmount, GBPAmount);
                end;
            }
        }
        area(Navigation)
        {
            action(BackToList)
            {
                Caption = 'Exchange Rate List';
                ApplicationArea = All;
                Image = List;
                ToolTip = 'Go back to the full list of exchange rates.';
                RunObject = Page "Exchange Rate List";
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.FetchStatus = 'Success' then
            StatusStyle := 'Favorable'
        else
            StatusStyle := 'Unfavorable';
    end;
}