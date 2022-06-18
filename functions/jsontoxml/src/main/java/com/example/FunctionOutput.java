package com.example;

import java.util.List;

public class FunctionOutput {
 
  String jsonString;
  public FunctionOutput(String val) {
    this.jsonString = val;
  }

  public String getAccounts() {
    return jsonString;
  }
}
