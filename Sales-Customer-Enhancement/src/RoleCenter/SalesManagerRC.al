profile "SCE-SALES-MANAGER-PROFILE"
{
    Caption = 'SCE Sales Manager';
    ProfileDescription = 'Custom profile for Sales Managers';
    RoleCenter = "SCE Sales Manager RC";
    Enabled = true;
    Promoted = true;
}

page 50106 "SCE Sales Manager RC"
{
    PageType = RoleCenter;
    Caption = 'SCE Sales Manager RC';
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part(SalesApprovals; "Sales Approval List")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approvals';
                }
                part(VisitLog; "Customer Visit Log List")
                {
                    ApplicationArea = All;
                    Caption = 'Recent Customer Visits';
                }
                part(Feedback; "Customer Feedback List")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Feedback';
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Customers)
            {
                Caption = 'Customers';
                Image = Customer;

                action(CustomerList)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    RunObject = page "Customer List";
                    Image = Customer;
                }
                action(VisitLogAction)
                {
                    ApplicationArea = All;
                    Caption = 'Visit Log';
                    RunObject = page "Customer Visit Log List";
                    Image = History;
                }
                action(FeedbackAction)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Feedback';
                    RunObject = page "Customer Feedback List";
                    Image = CreateRating;
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;

                action(SalesOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Orders';
                    RunObject = page "Sales Order List";
                    Image = Document;
                }
                action(SalesInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoices';
                    RunObject = page "Sales Invoice List";
                    Image = Invoice;
                }
                action(ApprovalsAction)
                {
                    ApplicationArea = All;
                    Caption = 'Approval Requests';
                    RunObject = page "Sales Approval List";
                    Image = Approval;
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = Reports;

                action(CustomerAnalysisReport)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Analysis';
                    RunObject = report "Customer Analysis";
                    Image = Report;
                }
            }
        }
    }
}