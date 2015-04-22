/**
* ApexClass : IDOLUtil
* @description : This class holds the utility methods
*/
public with sharing class IDOLUtil {
    
    public static List<String> exclusionTerms = new List<String>(); //List of cached exlusive tersm which will be used for filtering
    static{
        //Fetching exlusive terms
        for(Exclusion_Term__c exclustionTerm : [SELECT Id, Text__c From Exclusion_Term__c ]){
            if(exclustionTerm.text__c == '' || exclustionTerm.text__c == null) continue;
            exclusionTerms.add(exclustionTerm.Text__c);
        }
    }
    
    /**
    * @param  : List of IDOL.FindRelatedConceptsEntity which needs to be filtered out
    * @return : List of filtered IDOL.FindRelatedConceptsEntity
    */
    public static IDOL.FindRelatedConceptsEntity[] getFilteredEntities(IDOL.FindRelatedConceptsEntity[] entities){
        IDOL.FindRelatedConceptsEntity[] tempEntities = new List<IDOL.FindRelatedConceptsEntity>();
        for(IDOL.FindRelatedConceptsEntity entity :  entities){
            Boolean isIgnore = false;
            for(String exlusionTerm : exclusionTerms){//considering every exlusive term
                //applying filter
                if(entity.text !=null && entity.text.containsIgnoreCase(exlusionTerm) ){
                    isIgnore = true;
                    break;
                }
            }
            if(!isIgnore){
                tempEntities.add(entity);
            }
        }
        return tempEntities;
    }
    
    
}