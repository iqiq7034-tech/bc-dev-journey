page 50111 "Inspection Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Inspection Header";
    Caption = 'Vendor Inspection';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Inspection Date"; Rec."Inspection Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            part(Lines; "Inspection Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post Inspection';
                ApplicationArea = All;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                begin
                    InspectMgt.PostInspection(Rec);

                end;
            }
        }
    }

    var
        InspectMgt: Codeunit "Inspection Management";
}