package com.example;

import com.salesforce.functions.jvm.sdk.Context;
import com.salesforce.functions.jvm.sdk.InvocationEvent;
import com.salesforce.functions.jvm.sdk.SalesforceFunction;
import com.salesforce.functions.jvm.sdk.data.Record;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Describe JsontoxmlFunction here.
 */
public class JsontoxmlFunction implements SalesforceFunction<FunctionInput, FunctionOutput> {
  private static final Logger LOGGER = LoggerFactory.getLogger(JsontoxmlFunction.class);
  public static String TEST_XML_Json = "{'glossary':{'title':'exampleglossary','GlossDiv':{'title':'S','GlossList':{'GlossEntry':{'ID':'SGML','SortAs':'SGML','GlossTerm':'StandardGeneralizedMarkupLanguage','Acronym':'SGML','Abbrev':'ISO8879:1986','GlossDef':{'para':'Ameta-markuplanguage,usedtocreatemarkuplanguagessuchasDocBook.','GlossSeeAlso':['GML','XML']},'GlossSee':'markup'}}}}}";

  @Override
  public FunctionOutput apply(InvocationEvent<FunctionInput> event, Context context)
      throws Exception {

    // List<Record> records =
    // context.getOrg().get().getDataApi().query("SELECT Id, Name FROM
    // Account").getRecords();

    // LOGGER.info("Function successfully queried {} account records!",
    // records.size());

    // List<Account> accounts = new ArrayList<>();
    // for (Record record : records) {
    // String id = record.getStringField("Id").get();
    // String name = record.getStringField("Name").get();

    // accounts.add(new Account(id, name));
    // }
    String xml = "{}";
    try {

      JSONObject json = new JSONObject(TEST_XML_Json);
      xml = XML.toString(json);
    } catch (JSONException je) {
      System.out.println(je.toString());
    }
    return new FunctionOutput(xml);
  }
}
