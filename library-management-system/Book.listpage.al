page 50102 "Book List"
{
    Caption = 'Book List';
    PageType = List;
    ApplicationArea = All;
    CardPageId = "Book Card";
    UsageCategory = Lists;
    SourceTable = Book;

    layout
    {
        area(Content)
        {
            repeater(Book_Info)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Book Number';
                    ToolTip = 'Unique identifier for the book.';
                    ApplicationArea = All;

                }
                field("Title"; Rec."Title")
                {
                    Caption = 'Book Title';
                    ToolTip = 'Title of the book.';
                    ApplicationArea = All;

                }
                field("Author"; Rec."Author")
                {
                    Caption = 'Book Author';
                    ToolTip = 'Author of the book.';
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    Caption = 'Book Status';
                    ToolTip = 'Current status of the book.';
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("Last Borrowed Date"; Rec."Last Borrowed Date")
                {
                    Caption = 'Last Borrowed Date';
                    ToolTip = 'Date when the book was last borrowed.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                }


            }
        }
    }



    var
        StatusStyle: Text[20];

    trigger OnAfterGetCurrRecord()
    begin

        case Rec.Status of
            "Book Status"::Available:
                StatusStyle := 'favorable';
            "Book Status"::Borrowed:
                StatusStyle := 'unfavorable';
            "Book Status"::Inrepair:
                StatusStyle := 'ambuiguous';
            else
                StatusStyle := 'None';

        end;
    end;
}