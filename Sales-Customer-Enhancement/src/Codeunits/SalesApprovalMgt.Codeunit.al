codeunit 50104 "Sales Approval Mgt"
{
    procedure CreateApprovalRequest(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesApproval: Record "Sales Approval";
        TotalAmount: Decimal;
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                TotalAmount += SalesLine."Line Amount";
            until SalesLine.Next() = 0;
        SalesApproval.Init();
        SalesApproval."Document No." := SalesHeader."No.";
        SalesApproval."Customer No." := SalesHeader."Sell-to Customer No.";
        SalesApproval."Requested By" := UserId();
        SalesApproval."Request Date" := Today();
        SalesApproval."Approval Status" := SalesApproval."Approval Status"::Pending;
        SalesApproval."Order Amount" := TotalAmount;
        SalesApproval.Insert(true);


        Message('Approval request created for Sales Order %1.', SalesHeader."No.");

    end;

    procedure ApproveRequest(var SalesApproval: Record "Sales Approval")
    begin
        if SalesApproval."Approval Status" <> SalesApproval."Approval Status"::Pending then
            Error('Only pending requests can be approved.');

        SalesApproval."Approval Status" := SalesApproval."Approval Status"::Approved;
        SalesApproval."Approved By" := UserId();
        SalesApproval."Approval Date" := Today();
        SalesApproval.Modify(true);

        UpdateSalesHeader(SalesApproval."Document No.", UserId(), Today());
        Message('Sales Order %1 has been approved successfully.', SalesApproval."Document No.");
    end;

    procedure RejectRequest(var SalesApproval: Record "Sales Approval")
    var
        RejectionReason: Text[250];
    begin
        if SalesApproval."Approval Status" <> SalesApproval."Approval Status"::Pending then
            Error('Only pending requests can be rejected.');

        if not Confirm('Are you sure you want to reject this request?') then
            exit;

        SalesApproval."Approval Status" := SalesApproval."Approval Status"::Rejected;
        SalesApproval."Approved By" := UserId();
        SalesApproval."Approval Date" := Today();
        SalesApproval.Modify(true);

        Message('Sales Order %1 has been rejected.', SalesApproval."Document No.");
    end;

    local procedure UpdateSalesHeader(DocumentNo: Code[20]; ApprovedBy: Text[100]; ApprovalDate: Date)
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, DocumentNo) then begin
            SalesHeader."Approved By" := ApprovedBy;
            SalesHeader."Approval Date" := ApprovalDate;
            SalesHeader.Modify(true);
        end;
    end;
}