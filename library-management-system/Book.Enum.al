enum 50101 "Book Status"
{
    Extensible = true;

    value(1; Available)
    {
        Caption = 'Available';
    }
    value(2; Borrowed)
    {
        Caption = 'Borrowed';
    }
    value(3; Inrepair)
    {
        Caption = 'In Repair';
    }
}