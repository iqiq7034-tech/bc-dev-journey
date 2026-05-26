page 50201 "Shopify Customer API"
{
    PageType = API;
    APIPublisher = 'shopifybc';
    APIGroup = 'shopify';
    APIVersion = 'v1.0';
    EntityName = 'shopifyCustomer';
    EntitySetName = 'shopifyCustomers';
    SourceTable = Customer;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Caption = 'Shopify Customer API';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'number';
                    Editable = false;
                }
                field(displayName; Rec.Name)
                {
                    Caption = 'displayName';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'email';
                }
                field(phoneNumber; Rec."Phone No.")
                {
                    Caption = 'phoneNumber';
                }
                field(address; Rec.Address)
                {
                    Caption = 'address';
                }
                field(city; Rec.City)
                {
                    Caption = 'city';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'postCode';
                }
                field(country; Rec."Country/Region Code")
                {
                    Caption = 'country';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'blocked';
                    Editable = false;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'currencyCode';
                }
                field(balance; Rec.Balance)
                {
                    Caption = 'balance';
                    Editable = false;
                }
            }
        }
    }
}