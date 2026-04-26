table 50103 CustomerFeedback
{
    DataClassification = CustomerContent;
    Caption = 'Customer Feedback';

    fields
    {
        field(1; EntryNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entery No.';
            AutoIncrement = true;
        }
        field(2; CustomerNo; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            Caption = 'Customer No.';
        }
        field(3; CustomerName; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field(CustomerNo)));
            Editable = false;
        }
        field(4; FeedbackDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Feedback Date';
        }
        field(5; Rating; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Rating';
            OptionMembers = " ","1","2","3","4","5";
            OptionCaption = ' , 1,2,3,4,5';
        }
        field(6; FeedbackType; Enum FeedbackType)
        {
            Caption = 'Feedback Type';
            DataClassification = CustomerContent;
        }
        field(7; Comments; Text[500])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(8; Resolved; Boolean)
        {
            Caption = 'Resolved';
            DataClassification = CustomerContent;
        }
        field(9; ResolvedDate; Date)
        {
            Caption = 'Resolved Date';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Pk; EntryNo)
        {
            Clustered = true;
        }
        key(CustomerKey; "CustomerNo", "FeedbackDate")
        { }
    }


}