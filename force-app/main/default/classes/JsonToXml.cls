public with sharing class JsonToXml {
	DOM.Document doc;
	String Name = 'default';
	public JsonToXml() {
		doc = new DOM.Document();
	}
	public JsonToXml(String name) {
		this.Name = name;
	}
	public String jsonToXmls(String jsonString) {
		dom.XmlNode body = doc.createRootElement(Name, null, null);
		Object vals = JSON.deserializeUntyped(jsonString);

		if (vals instanceof List<Object>) {
			List<Object> listofObjects = (List<Object>) vals;
			serializeListOfObject(listofObjects, 'Row', body);
		} else {
			Map<String, Object> namevsObjects = (Map<String, Object>) vals;
			serializeMapOfObject(namevsObjects, body);
		}
		return doc.toXmlString();
	}
	private void serializeMapOfObject(Map<String, Object> vals, dom.XmlNode body) {
		dom.XmlNode bb = body;
		for (String key : vals.keySet()) {
			Object value = vals.get(key);
			if (checkInstanceOf(value) == 'Object' || checkInstanceOf(value) == 'String') {
				bb.addChildElement(key, null, null).addTextNode(value == null ? '' : String.valueOf(value));
			} else if (checkInstanceOf(value) == 'List') {
				serializeListOfObject((List<Object>) value, key, bb);
			} else {
				serializeMapOfObject((Map<String, Object>) value, bb.addChildElement(key, null, null));
			}
		}
	}
	private void serializeListOfObject(List<Object> vals, String key, dom.XmlNode body) {
		dom.XmlNode bb = body;
		for (Object var : vals) {
			if (checkInstanceOf(var) == 'String' || checkInstanceOf(var) == 'Object') {
				bb.addChildElement(key, null, null).addTextNode(var == null ? '' : String.valueOf(var));
			} else if (checkInstanceOf(var) == 'List') {
				serializeListOfObject((List<Object>) vals, key, bb);
			} else {
				serializeMapOfObject((Map<String, Object>) var, bb.addChildElement(key, null, null));
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
