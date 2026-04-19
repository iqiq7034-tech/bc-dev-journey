codeunit 50101 "Book Management"
{
    procedure ReturnBook(var BookRec: Record Book)
    begin
        if BookRec.Status = BookRec.Status::Available then
            exit;
        BookRec.Validate(BookRec.Status, BookRec.Status::Available);
        BookRec.Modify(true);
        Message('Book "%1" has been returned and is now available.', BookRec.Title);

    end;

}