page 50109 "API Health Log List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "API Health Log";
    Caption = 'API Health Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Logs)
            {
                field(EntryNo; Rec.EntryNo)
                { ApplicationArea = All; Caption = 'No.'; }

                field(CheckedAt; Rec.CheckedAt)
                { ApplicationArea = All; Caption = 'Checked At'; }

                field(StatusCode; Rec.StatusCode)
                { ApplicationArea = All; Caption = 'HTTP Status'; }

                field(IsHealthy; Rec.IsHealthy)
                {
                    ApplicationArea = All;
                    Caption = 'Healthy';
                    Style = Favorable;
                    StyleExpr = Rec.IsHealthy;
                }

                field(ResponseTimeMs; Rec.ResponseTimeMs)
                { ApplicationArea = All; Caption = 'Response (ms)'; }

                field(ErrorMessage; Rec.ErrorMessage)
                { ApplicationArea = All; Caption = 'Error'; }
            }
        }
    }
}