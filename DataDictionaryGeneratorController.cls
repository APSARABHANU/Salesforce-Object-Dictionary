/*****************************************************************************************
@ClassName: DataDictionaryGeneratorController
@Author: Apsarabhanu Devara
@Description: This controller is used for getting all objects and associated fields .
******************************************************************************************/
public with sharing class DataDictionaryGeneratorController {
    public static final String SEPERATOR = ',';
    private static final String NEW_LINE = '\n';
    
    //Inner class for wrapping SObject information
    public class SObjectWrapper{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}

        public SObjectWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        } 
    }
    
    /*****************************************************************************************
	@Description: Method to return the List of Objects
	@return: sObjectList - list of Objects in Org
	*********************************************************************************************/
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
    
    /*****************************************************************************************
	@Description: method to generate CSV data based on selected SObjects
    @Param: List<String> selectedObject - list of selected Objects
	@return: CSVString - String which contains fields for selected Object
	*********************************************************************************************/
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
    
    /*****************************************************************************************
	@Description: Helper method to process picklist values
    @Param: List<Schema.PicklistEntry> picklistValues - process picklist values
	@return: returning picklist Values
	*********************************************************************************************/
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