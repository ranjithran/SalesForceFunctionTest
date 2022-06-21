public with sharing class JsonToxml_cc {
	@AuraEnabled
	public static String jsonToXmls(String jsonString) {
		return new JsonToXml().jsonToXmls(jsonString);
	}
	@AuraEnabled
	public static string fromSerzialze(String jsonString) {
		XMLSerializer xml = new XMLSerializer();
		return xml.jsonToXML(jsonString);
	}
}
