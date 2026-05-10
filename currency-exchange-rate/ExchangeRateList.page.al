page 50105 "Exchange Rate List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Exchange Rate";
    Caption = 'Exchange Rates';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Rates)
            {
                field(CurrencyCode; Rec.CurrencyCode)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    Caption = 'Rate vs USD';
                }
                field(BaseCurrency; Rec.BaseCurrency)
                {
                    ApplicationArea = All;
                    Caption = 'Base';
                }
                field(LastUpdated; Rec.LastUpdated)
                {
                    ApplicationArea = All;
                    Caption = 'Last Updated';
                }
                field(FetchStatus; Rec.FetchStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FetchRates)
            {
                Caption = 'Fetch Latest Rates';
                ApplicationArea = All;
                Image = Refresh;
                ToolTip = 'Call the exchange rate API and update all rates.';
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

            action(FetchSpecific)
            {
                Caption = 'Fetch Specific Currencies';
                ApplicationArea = All;
                Image = Currency;
                ToolTip = 'Fetch only EUR GBP PKR AED SAR.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExRateMgmt: Codeunit "Exchange Rate Mgmt";
                begin
                    ExRateMgmt.FetchSpecificCurrencies();
                    CurrPage.Update();
                end;
            }

            action(ClearRates)
            {
                Caption = 'Clear All Rates';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete all stored exchange rates.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExRate: Record "Exchange Rate";
                begin
                    if Confirm('Are you sure you want to delete all exchange rates?', false) then begin
                        ExRate.DeleteAll();
                        Message('All rates cleared.');
                    end;
                end;
            }
        }
    }
}