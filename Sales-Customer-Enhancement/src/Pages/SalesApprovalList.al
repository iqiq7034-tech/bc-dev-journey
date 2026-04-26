page 50105 "Sales Approval List"
{
    PageType = List;
    SourceTable = "Sales Approval";
    Caption = 'Sales Approval List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the entry number.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the document number.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the customer number.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the customer name.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows who requested approval.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the request date.';
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the order amount.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the approval status.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows who approved this request.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approve this sales order.';

                trigger OnAction()
                var
                    SalesApprovalMgt: Codeunit "Sales Approval Mgt";
                begin
                    SalesApprovalMgt.ApproveRequest(Rec);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject this sales order.';

                trigger OnAction()
                var
                    SalesApprovalMgt: Codeunit "Sales Approval Mgt";
                begin
                    SalesApprovalMgt.RejectRequest(Rec);
                end;
            }
        }
    }
}