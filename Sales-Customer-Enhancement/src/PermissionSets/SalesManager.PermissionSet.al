permissionset 50100 "SALES-MANAGER"
{
    Caption = 'Sales Manager';
    Assignable = true;

    Permissions =
        tabledata CustomerVisitLog = RIMD,
        tabledata CustomerFeedback = RIMD,
        tabledata "Sales Approval" = RIMD,
        table CustomerVisitLog = X,
        table CustomerFeedback = X,
        table "Sales Approval" = X,
        page "Customer Visit Log Card" = X,
        page "Customer Visit Log List" = X,
        page "Customer Feedback Card" = X,
        page "Customer Feedback List" = X,
        page "Sales Approval List" = X,
        codeunit "Customer Mgmt" = X,
        codeunit "Sales Approval Mgt" = X,
        codeunit "Discount Mgt" = X,
        report "Customer Analysis" = X;
}