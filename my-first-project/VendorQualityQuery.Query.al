query 50110 "Vendor Quality Summary"
{
    QueryType = Normal;
    Caption = 'Vendor Quality Summary';

    elements
    {
        dataitem(Vendor; Vendor)
        {
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(Average_Quality_Rating; "Average Quality Rating")
            {

            }
            column(Inspection_Count; "Inspection Count")
            {

            }
            dataitem(Inspection_Header; "Inspection Header")
            {
                DataItemLink = "Vendor No." = Vendor."No.";
                SqlJoinType = InnerJoin;
                column(Inspection_Date; "Inspection Date") { }
                column(Status; Status) { }

            }

        }

    }


}