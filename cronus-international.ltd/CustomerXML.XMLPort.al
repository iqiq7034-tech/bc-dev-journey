// xmlport 50103 "Customer XML"
// {
//     Caption = 'Export Customer(s) to XML';
//     Format = xml;
//     Direction = Both;

//     schema
//     {
//         textelement(Customers)
//         {
//             XmlName = 'Customers';
//             tableelement(Customer; Customer)
//             {
//                 fieldattribute(Number; Customer."No.") { }

//                 fieldattribute(Language_Code; Customer."Language Code") { }

//                 fieldelement(Name; Customer.Name) { }

//                 fieldelement(Phone_No; Customer."Phone No.") { }


//                 textelement(Address)
//                 {
//                     XmlName = 'Address';
//                     fieldelement(Address; Customer.Address) { }

//                     fieldelement(Post_Code; Customer."Post Code") { }

//                     fieldelement(City; Customer.City) { }


//                 }
//             }
//         }

//     }

// }