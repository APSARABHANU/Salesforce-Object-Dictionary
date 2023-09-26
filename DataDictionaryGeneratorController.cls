public with sharing class DataDictionaryGeneratorController {
    public static final String SEPERATOR = ',';
    private static final String NEW_LINE = '\n';
    public class SObjectWrapper{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}

        public SObjectWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        } 
    }
    @AuraEnabled
    public static List<SObjectWrapper> getSObjects(){
        List<SObjectWrapper> sObjectList = new List<SObjectWrapper>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            String sObjectLabel = objTyp.getDescribe().getLabel();
            String sObjectName = objTyp.getDescribe().getName();
            sObjectList.add(new SObjectWrapper(sObjectLabel, sObjectName));
        }
        return sObjectList;
    }
    
    @AuraEnabled
    public static String generateCsv (List<String> selectedObject){
        String CSVString = '"Object Label"' + SEPERATOR + '"Object Api Name"' + SEPERATOR + '"Field Label"'+
                            SEPERATOR + '"Field Api Name"' + SEPERATOR + '"Standard/Custom"' + SEPERATOR + '"Type"' + 
                            SEPERATOR + + '"Help Text"' + SEPERATOR + '"Picklist Values"' + 
                            SEPERATOR + '"External Id"' + SEPERATOR + '"Unique"' + SEPERATOR + '"Required"' + '\n';
                            Set<String> objFieldNames = new Set<String>();
                            for(String objName : selectedObject){
                                Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
                                if(objType != null){
                                    Schema.DescribeSObjectResult objectResult = objType.getDescribe();
                                    
                                    // * Getting the map of OBJECT fields
                                    //Map<String, Schema.SObjectField> fieldsMap = objectResult.fields.getMap().values();
                                    for (Schema.SObjectField objectField : objectResult.fields.getMap().values()) {
                                    Schema.DescribeFieldResult fieldResult = objectField.getDescribe();
                                    Schema.DisplayType fieldType = fieldResult.getType();
                                    List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
                                    // String picklistEntries = '';
                                    // for (Schema.PicklistEntry picklistValue : picklistValues) {
                                    //      picklistEntries += picklistValue.getValue() + ', ';
                                    // }
                                    // if (picklistEntries.endsWith(', ')) {
                                    //     picklistEntries = picklistEntries.substring(0, picklistEntries.length() - 2);
                                    // }
                                    CSVString +=  objectResult.getLabel() + SEPERATOR;
                                    CSVString +=  objectResult.getName()  + SEPERATOR;
                                    CSVString +=  fieldResult.getLabel()  + SEPERATOR;
                                    CSVString +=  fieldResult.getName()  + SEPERATOR;
                                    CSVString +=  (fieldResult.isCustom() ? 'Custom' : 'Standard')  + SEPERATOR;
                                    CSVString +=  fieldType.name()  + SEPERATOR;
                                    CSVString +=  (String.isNotBlank(fieldResult.getInlineHelpText()) ?  fieldResult.getInlineHelpText() : '')  + SEPERATOR;
                                    CSVString +=  processPicklistValues(fieldResult.getPicklistValues())  + SEPERATOR;
                                    CSVString +=  fieldResult.isExternalID()  + SEPERATOR;
                                    CSVString +=  fieldResult.isUnique()  + SEPERATOR;
                                    CSVString +=  (!fieldResult.isNillable())  + '\n';

                                }

                            }
                            }
        return CSVString;
    }
    private static String processPicklistValues(List<Schema.PicklistEntry> picklistValues) {
        String picklistAsString = '';
        if (picklistValues != null) {
            for (Schema.PicklistEntry picklistValue : picklistValues) {
                if (picklistValue.isActive()) {
                    picklistAsString += picklistValue.getValue();
                }
            }
        }
        return picklistAsString;
    }
    
}