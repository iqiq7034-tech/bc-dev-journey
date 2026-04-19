page 50103 "Book Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Book;

    layout
    {
        area(Content)
        {
            group(General)
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
                field("Last Borrowed Date"; Rec."Last Borrowed Date")
                {
                    Caption = 'Last Borrowed Date';
                    ToolTip = 'Date when the book was last borrowed.';
                    ApplicationArea = All;
                }



                field(Status; Rec.Status)
                {
                    Caption = 'Book Status';
                    ToolTip = 'Current status of the book.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReturnBook)
            {
                Caption = 'Return Book';
                ToolTip = 'Return the book and update its status to Available.';
                ApplicationArea = All;
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;


                trigger OnAction()

                var
                    BookMgt: Codeunit "Book Management";
                begin
                    BookMgt.ReturnBook(Rec);

                end;
            }
        }
    }

    var
        myInt: Integer;
}