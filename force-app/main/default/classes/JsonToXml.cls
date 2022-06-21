public with sharing class JsonToXml {
  static DOM.Document doc = new DOM.Document();

  static dom.XmlNode body;
  static Boolean isRowMode = false;

  @AuraEnabled
  public static String jsonToXmls(String jsonString) {
    body = doc.createRootElement('Envelope', null, null);
    Object vals = JSON.deserializeUntyped(jsonString);

    if (vals instanceof List<Object>) {
      List<Object> listofObjects = (List<Object>) vals;
      isRowMode = true;
      serializeListOfObject(listofObjects);
    } else {
      Map<String, Object> namevsObjects = (Map<String, Object>) vals;
      serializeMapOfObject(namevsObjects);
    }
    return doc.toXmlString();
  }
  private static void serializeMapOfObject(Map<String, Object> vals) {
    dom.XmlNode bb = body;
    for (String str : vals.keySet()) {
      Object var = vals.get(str);
      if (checkInstanceOf(var) == 'List') {
        body = bb.addChildElement(str, null, null);
        serializeListOfObject((List<Object>) var);
      }
      if (checkInstanceOf(var) == 'Object') {
        System.debug('---> object in map ' + str + '--' + var);
        bb.addChildElement(str, null, null)
          .addTextNode(var == null ? '' : String.valueOf(var));
      }
      if (checkInstanceOf(var) == 'Map') {
        body = bb.addChildElement(str, null, null);
        serializeMapOfObject((Map<String, Object>) var);
      }
    }
  }
  private static void serializeListOfObject(List<Object> vals) {
    dom.XmlNode bb = body;
    System.debug('--> list');
    for (Object var : vals) {
      if (checkInstanceOf(var) == 'List') {
        serializeListOfObject((List<Object>) vals);
      }
      if (checkInstanceOf(var) == 'Map') {
        if (isRowMode) {
          body = bb.addChildElement('Row', null, null);
        }
        serializeMapOfObject((Map<String, Object>) var);
      }
    }
  }

  private static String checkInstanceOf(Object o) {
    String result = 'Object';
    if (o instanceof List<Object>)
      return 'List';
    if (o instanceof Map<String, Object>)
      return 'Map';
    return result;
  }
}
