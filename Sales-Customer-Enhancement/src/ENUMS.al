enum 50100 CustomerCategory
{
    Extensible = true;

    value(1; Gold)
    {
        Caption = 'Gold';
    }
    value(2; Silver)
    {
        Caption = 'Silver';
    }
    value(3; Bronze)
    {
        Caption = 'Bronze';
    }
}

enum 50101 DeliveryPriority
{
    Extensible = true;

    value(1; Normal)
    {
        Caption = 'Normal';
    }
    value(2; Urgent)
    {
        Caption = 'Urgent';
    }
    value(3; Express)
    {
        Caption = 'Express';
    }
}

enum 50102 CustomerSatisfaction
{
    Extensible = true;

    value(1; Pending)
    {
        Caption = 'Pending';
    }
    value(2; Satisfied)
    {
        Caption = 'Satisfied';
    }
    value(3; Unsatisfied)
    {
        Caption = 'Unsatisfied';
    }
}

enum 50103 QualityCheckStatus
{
    Extensible = true;

    value(0; Option)
    {
        Caption = 'Option';
    }
    value(1; Pending)
    {
        Caption = 'Pending';
    }
    value(2; Passed)
    {
        Caption = 'Passed';
    }
    value(3; Failed)
    {
        Caption = 'Failed';
    }
}

enum 50104 FeedbackType
{
    Extensible = true;

    value(0; Service)
    {
        Caption = 'Service';
    }
    value(1; Delivery)
    {
        Caption = 'Delivery';
    }
    value(2; Product)
    {
        Caption = 'Product';
    }
}

enum 50105 ApprovalStatus
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Approved)
    {
        Caption = 'Approved';
    }
    value(2; Rejected)
    {
        Caption = 'Rejected';
    }
}