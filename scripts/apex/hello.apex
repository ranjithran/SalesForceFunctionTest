// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

XMLSerializer serializer = new XMLSerializer();
Book library = new Book();

//Serialize Apex object to XML
String serializedXML = serializer.serialize(library,true, null);

System.debug('Serialized XML:' + serializedXML);

