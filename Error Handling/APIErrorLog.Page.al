page 50102 "API Error Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "API Error Log";
    Caption = 'API Error Log';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LogLines)
            {
                field(EntryNo; Rec.EntryNo) { ApplicationArea = All; }
                field(LogDateTime; Rec.LogDateTime) { ApplicationArea = All; }
                field(Method; Rec.Method) { ApplicationArea = All; }
                field(Url; Rec.Url) { ApplicationArea = All; }
                field(StatusCode; Rec.StatusCode) { ApplicationArea = All; }
                field(StatusMessage; Rec.StatusMessage) { ApplicationArea = All; }
                field(Success; Rec.Success) { ApplicationArea = All; }
                field(ErrorDetails; Rec.ErrorDetails) { ApplicationArea = All; }
            }
        }
    }
}