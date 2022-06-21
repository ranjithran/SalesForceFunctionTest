/**
@Description: Contains methods for serializing Json String or Apex Objects into XML format using DOM. 
@Refernce : https://github.com/skolakan/Apex-XML-Serializer
**/

public with sharing class JsonToXml {
	DOM.Document doc;
	String Name = 'default';
	public JsonToXml() {
		doc = new DOM.Document();
	}
	public JsonToXml(String name) {
		this.Name = name;
	}

	/*
@Description    : Serializes the object passed to XML string
@Parameter      : apexObject = Apex object to serialize into XML
@Returns        : XML String
*/
	public String apexObjectToXML(Object apexObject) {
		return jsonToXmls(JSON.serialize(apexObject));
	}
	/*
@Description    : Serializes the json String to XML string
@Parameter      : jsonString = Json String to serialize into XML
@Returns        : XML String
*/
	public String jsonToXmls(String jsonString) {
		dom.XmlNode body = doc.createRootElement(Name, null, null);
		Object vals = JSON.deserializeUntyped(jsonString);

		if (vals instanceof List<Object>) {
			List<Object> listofObjects = (List<Object>) vals;
			serializeObjectList(listofObjects, 'Row', body);
		} else {
			Map<String, Object> namevsObjects = (Map<String, Object>) vals;
			serializeObjectMap(namevsObjects, body);
		}
		return doc.toXmlString();
	}

	/*
@Description    : serializeObjectMap method
@Parameter      : objectMap = Map of String and objects
@Paremeter      : body = dom.XmlNode
*/
	private void serializeObjectMap(Map<String, Object> objectMap, dom.XmlNode body) {
		dom.XmlNode bb = body;
		for (String key : objectMap.keySet()) {
			Object value = objectMap.get(key);
			if (checkInstanceOf(value) == 'Object' || checkInstanceOf(value) == 'String') {
				bb.addChildElement(key, null, null).addTextNode(value == null ? '' : String.valueOf(value));
			} else if (checkInstanceOf(value) == 'List') {
				serializeObjectList((List<Object>) value, key, bb);
			} else {
				serializeObjectMap((Map<String, Object>) value, bb.addChildElement(key, null, null));
			}
		}
	}
	/*
@Description    : serializeObjectList method
@Parameter      : objectList = List of objects
@Parameter      : key = key to wrap all elements of the list with 
@Paremeter      : body = dom.XmlNode
*/
	private void serializeObjectList(List<Object> objectList, String key, dom.XmlNode body) {
		dom.XmlNode bb = body;
		for (Object var : objectList) {
			if (checkInstanceOf(var) == 'String' || checkInstanceOf(var) == 'Object') {
				bb.addChildElement(key, null, null).addTextNode(var == null ? '' : String.valueOf(var));
			} else if (checkInstanceOf(var) == 'List') {
				serializeObjectList((List<Object>) objectList, key, bb);
			} else {
				serializeObjectMap((Map<String, Object>) var, bb.addChildElement(key, null, null));
			}
		}
	}

	private String checkInstanceOf(Object o) {
		String result = 'Object';
		if (o instanceof List<Object>)
			return 'List';
		if (o instanceof Map<String, Object>)
			return 'Map';
		if (o instanceof String)
			return 'String';
		return result;
	}
}
