table 50102 CustomerVisitLog
{
    DataClassification = CustomerContent;
    Caption = 'Customer Visit Log';

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
        field(4; VisitDate; Date)
        {
            Caption = 'Visit Date';
            DataClassification = CustomerContent;
        }
        field(5; VisitPurpose; Text[250])
        {
            Caption = 'Visit Purpose';
            DataClassification = CustomerContent;
        }
        field(6; SalesRepName; Text[100])
        {
            Caption = 'Sales Rep Name';
            DataClassification = CustomerContent;
        }
        field(7; FollowUpDate; Date)
        {
            Caption = 'Follow Up Date';
            DataClassification = CustomerContent;
        }
        field(8; VisitNotes; Text[250])
        {
            Caption = 'Visit Notes';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Pk; EntryNo)
        {
            Clustered = true;
        }
        key(CustomerKey; CustomerNo, VisitDate)
        { }
    }



}