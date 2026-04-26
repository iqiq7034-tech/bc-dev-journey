codeunit 50106 "Sales Event Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        DiscountMgt: Codeunit "Discount Mgt";
    begin
        if Rec.IsTemporary() then
            exit;

        if Rec.Type = Rec.Type::Item then
            DiscountMgt.ApplyAutomaticDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure OnAfterValidateLineDiscount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        DiscountMgt: Codeunit "Discount Mgt";
    begin
        if Rec.IsTemporary() then
            exit;

        DiscountMgt.ValidateLineDiscount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::CustomerVisitLog, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertVisitLog(var Rec: Record CustomerVisitLog; RunTrigger: Boolean)
    var
        CustomerMgmt: Codeunit "Customer Mgmt";
    begin
        if Rec.IsTemporary() then
            exit;

        CustomerMgmt.UpdateLastVisitDate(Rec.CustomerNo, Rec.VisitDate);
    end;
}