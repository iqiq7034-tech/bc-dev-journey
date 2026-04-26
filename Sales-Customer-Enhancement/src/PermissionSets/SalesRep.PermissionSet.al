permissionset 50101 "SALES-REP"
{
    Caption = 'Sales Representative';
    Assignable = true;

    Permissions =
        tabledata CustomerVisitLog = RIM,
        tabledata CustomerFeedback = RIM,
        tabledata "Sales Approval" = RI,
        table CustomerVisitLog = X,
        table CustomerFeedback = X,
        table "Sales Approval" = X,
        page "Customer Visit Log Card" = X,
        page "Customer Visit Log List" = X,
        page "Customer Feedback Card" = X,
        page "Customer Feedback List" = X,
        codeunit "Customer Mgmt" = X,
        codeunit "Discount Mgt" = X,
        report "Customer Analysis" = X;
}