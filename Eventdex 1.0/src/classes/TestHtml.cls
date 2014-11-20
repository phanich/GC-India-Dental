public with sharing class TestHtml {

    public String hiddenValue { get; set; }
    
    public String abc{get;set;}

    public PageReference save() {
    
    
    System.debug('Hidden Value '+hiddenValue);
    System.debug('Visualforce Value '+abc);
        return null;
    }

}