/*************************************************************
@Name: DataDictionaryGeneratorControllerTest
@Author: Apsarabhanu Devara
@Description: Test class to cover the functionality of DataDictionaryGeneratorController class
@CodeCoverage: 100% 
******************************************************************/
@isTest
public class DataDictionaryGeneratorControllerTest {
    @isTest
    static void testGetSObjects(){
        List<DataDictionaryGeneratorController.SObjectWrapper> sObjects = DataDictionaryGeneratorController.getSObjects();
        System.assertNotEquals(0, sObjects.size());
    }
    
    @isTest
    static void testGenerateCsv(){
        List<String> emptyList = new List<String>();
        String csvOutput = DataDictionaryGeneratorController.generateCsv(emptyList);
        System.assertEquals('"Object Label","Object Api Name","Field Label","Field Api Name","Standard/Custom","Type","Help Text","Picklist Values","External Id","Unique","Required"\n', csvOutput);
        List<String> singleObjectList = new List<String>{ 'Account' };
        csvOutput = DataDictionaryGeneratorController.generateCsv(singleObjectList);
    }

}