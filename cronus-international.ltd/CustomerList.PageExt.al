// pageextension 50102 CustomerList extends "Customer List"
// {


//     actions
//     {
//         addlast("&Customer")
//         {
//             action(ExportToXml)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Export to XML';
//                 tooltip = 'Export the customer list to an XML file.';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Image = Export;

//                 trigger OnAction()
//                 var
//                     CustomerXML: XmlPort "Customer XML";
//                     TempBlob: Codeunit "Temp Blob";
//                     Outstr: OutStream;
//                     Instr: InStream;
//                     FileName: Text;
//                 begin
//                     TempBlob.CreateOutStream(Outstr);
//                     CustomerXML.SetDestination(Outstr);
//                     CustomerXML.Export();
//                     TempBlob.CreateInStream(Instr);
//                     FileName := 'Customers.xml';
//                     File.DownloadFromStream(Instr, 'Download', '', '', FileName)

//                 end;
//             }

//             action(ImportToXml)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Import to XML';
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 Image = Import;

//                 trigger OnAction()
//                 var
//                     customerXML: XmlPort "Customer XML";
//                     instr: InStream;
//                     filename: Text;
//                 begin
//                     if UploadIntoStream('Select the xml file to import', '', 'XML files (*.xml)|*.xml', filename, instr) then
//                         customerXML.SetSource(instr);
//                     customerXML.Import();
//                     Message('Import from %1 completed.', filename);
//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }