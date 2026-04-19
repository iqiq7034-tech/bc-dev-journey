codeunit 50110 "Inspection Management"
{
    procedure PostInspection(var Header: Record "Inspection Header")

    var
        Line: Record "Inspection Line";
        Vend: Record Vendor;
        TotalScore: Decimal;
        LineCount: Integer;

    begin
        if Header.Status = Header.Status::Posted then
            Error('This inspection is already posted.');

        Line.SetRange("Document No.", Header."No.");
        if Line.FindSet() then begin
            repeat
                TotalScore += Line."Score (1-5)";
                LineCount += 1;
            until Line.Next() = 0;

        end;
        if LineCount = 0 then
            Error('You cannot post an inspection with no lines!');
        if Vend.Get(Header."Vendor No.") then begin
            Vend."Total Quality Score" += TotalScore;
            Vend."Inspection Count" += 1;
            Vend."Average Quality Rating" := Vend."Total Quality Score" / Vend."Inspection Count";
            Vend.Modify();
        end;
        Header.Status := Header.Status::Posted;
        Header.Modify();
        Message('Inspection for %1 has been posted. Vendor rating updated!', Header."Vendor Name");
    end;


}