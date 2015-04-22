/**
 * Helper methods for IDOL and case index testing
 */
 
@isTest
public class IDOL_TestHelper {
    
    public static final String TEST_INDEX_NAME = 'test index1';
    
    public static final String TEST_IDOL_API_URL = 'https://api.idolondemand.com/1/api';
    public static final String TEST_IDOL_API_KEY = 'apykey';
    public static final String TEST_IDOL_API_Version = 'v1';
    
    // keep track of API invocation order when necessary
    private static Integer invocationOrder = 0;

    public static IDOL_API_Config__c createTestApiConfig(String name) {
        IDOL_API_Config__c config = new IDOL_API_Config__c(Name=name, API_URL__c=TEST_IDOL_API_URL, API_Key__c=TEST_IDOL_API_KEY,
                API_Version__c=TEST_IDOL_API_Version, API_Logging__c=false);
        insert config;
        return config;
    }
    
    public class MockIDOLSuccessResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            if (req.getEndpoint().contains(IDOLApi.LIST_INDEXES_PATH)) {            // List Indexes
                res.setBody(LIST_INDEXES_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.CREATE_TEXT_INDEX_PATH)) {    // Create Text Index
                res.setBody(CREATE_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.INDEX_STATUS_PATH)) { // Index Status
                res.setBody(INDEX_STATUS_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH) && req.getEndpoint().contains('confirm')) {   // Delete Text Index with confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE_WITH_CONFIRM);
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH)) {    // first Delete Text Index without confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.ADD_TO_TEXT_INDEX_PATH)) {    // Add To Text Index
                res.setBody(ADD_TO_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.LANGUAGE_IDENTIFICATION_PATH)) {  // Language Identification
                res.setBody(LANGUAGE_IDENTIFICATION_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.SENTIMENT_ANALYSIS_PATH)) {   // Sentiment Analysis
                res.setBody(SENTIMENT_ANALYSIS_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.FIND_SIMILAR_PATH)) { // Find Similar
                res.setBody(FIND_SIMILAR_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.FIND_RELATED_CONCEPTS_PATH)) {    // Find Related Concepts
                res.setBody(FIND_RELATED_CONCEPTS_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.QUERY_TEXT_INDEX_PATH)) { // Query Text Index
                res.setBody(FIND_SIMILAR_RESPONSE);
            } else if(req.getEndpoint().contains(IDOLApi.EXPAND_CONTAINER_PATH)){
                res.setBody(EXPAND_CONTAINER_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.TEXT_EXTRACTION_PATH)){
                res.setBody(TEXT_EXTRACTION_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.STORE_OBJECT_PATH)){
                res.setBody(STORE_OBJECT_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.OCR_PATH)){
                res.setBody(EXTRACT_TEXT_FROM_IMAGE_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.VIEW_DOCUMENT_PATH)){
                res.setBody(VIEWDOCUMENT_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.BARCODE_RECOGNITION_PATH)){
                res.setBody(RECOGNIZEBARCODES_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.FACE_DETECTION_PATH)){
                res.setBody(detectFaces_RESPONSE);
            }else if(req.getEndpoint().contains(IDOLApi.EXPAND_TERMS_PATH)){
                res.setBody(EXPANDTERMS_RESPONSE);
            }
            return res;
        }
    }

    public class MockIDOLFailureResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(400);
            // for the sake of simplicity, use single failure message
            res.setBody(FAILURE_RESPONSE);
            return res;
        }
    }
    
    public class MockResponseGeneratorForCreateIndex implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            if (req.getEndpoint().contains(IDOLApi.LIST_INDEXES_PATH)) {            // List Indexes
                if (invocationOrder == 0) {
                    invocationOrder ++;
                    res.setBody(LIST_INDEXES_RESPONSE_NO_INDEX);    // first no index
                } else {
                    res.setBody(LIST_INDEXES_RESPONSE);         // return index
                }
            } else if (req.getEndpoint().contains(IDOLApi.CREATE_TEXT_INDEX_PATH)) {    // Create Text Index
                res.setBody(CREATE_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.INDEX_STATUS_PATH)) { // Index Status
                res.setBody(INDEX_STATUS_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH) && req.getEndpoint().contains('confirm')) {   // Delete Text Index with confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE_WITH_CONFIRM);
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH)) {    // first Delete Text Index without confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.ADD_TO_TEXT_INDEX_PATH)) {    // Add To Text Index
                res.setBody(ADD_TO_TEXT_INDEX_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.LANGUAGE_IDENTIFICATION_PATH)) {  // Language Identification
                res.setBody(LANGUAGE_IDENTIFICATION_RESPONSE);
            } else if (req.getEndpoint().contains(IDOLApi.SENTIMENT_ANALYSIS_PATH)) {   // Sentiment Analysis
                res.setBody(SENTIMENT_ANALYSIS_RESPONSE);
            }
            return res;
        }
    }
    
    public class MockResponseGeneratorForDeleteIndex implements HttpCalloutMock {

        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            if (req.getEndpoint().contains(IDOLApi.LIST_INDEXES_PATH)) {            // List Indexes
                if (invocationOrder == 0) {
                    invocationOrder ++;
                    res.setBody(LIST_INDEXES_RESPONSE); // first return index
                } else {
                    res.setBody(LIST_INDEXES_RESPONSE_NO_INDEX);            // next no index
                }
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH) && req.getEndpoint().contains('confirm')) {   // Delete Text Index with confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE_WITH_CONFIRM);
            } else if (req.getEndpoint().contains(IDOLApi.DELETE_TEXT_INDEX_PATH)) {    // first Delete Text Index without confirm
                res.setBody(DELETE_TEXT_INDEX_RESPONSE);
            }
            return res;
        }
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {

        public HttpResponse respond(HTTPRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setStatus('Accepted');
            // for the sake of simplicity, use single failure message
            res.setBody('{ "property": "value1", "key": "value2" }');
            return res;
        }
    }
    
    //  ------- successful responses ---------------
    
    private static String LIST_INDEXES_RESPONSE = 
        '{ "public_index": ['+
        '        {'+
        '            "index": "wiki_eng",'+
        '            "type": "content"'+
        '        },'+
        '        {'+
        '            "index": "news_ita",'+
        '            "type": "content"'+
        '        }'+
        '    ],'+
        '    "index": ['+
        '        {'+
        '            "index": "'+TEST_INDEX_NAME+'",'+
        '            "flavor": "standard",'+
        '            "type": "content",'+
        '            "description": "initial testing",'+
        '            "date_created": "Mon May 05 2014 04:23:40 GMT+0000 (UTC)",'+
        '            "num_components": 1'+
        '        }'+
        '    ]'+
        '}';

    private static String LIST_INDEXES_RESPONSE_NO_INDEX = 
        '{ "public_index": ['+
        '        {'+
        '            "index": "wiki_eng",'+
        '            "type": "content"'+
        '        },'+
        '        {'+
        '            "index": "news_ita",'+
        '            "type": "content"'+
        '        }'+
        '    ],'+
        '    "index": ['+       // no index, API returns empty array, deserialized to empty collection
        '    ]'+
        '}';
        
    private static String CREATE_TEXT_INDEX_RESPONSE = 
        '{'+
        '    "index": "'+TEST_INDEX_NAME+'",'+
        '    "message": "message1"'+
        '}';

    private static String INDEX_STATUS_RESPONSE = 
        '{'+
        '    "total_documents": 1,'+
        '    "total_index_size": 296,'+
        '    "24hr_index_updates": 1'+
        '}';

    private static String DELETE_TEXT_INDEX_RESPONSE = 
        '{'+
        '    "deleted": false,'+
        '    "index": "'+TEST_INDEX_NAME+'",'+
        '    "confirm": "confirm1"'+
        '}';
        
    private static String DELETE_TEXT_INDEX_RESPONSE_WITH_CONFIRM = 
        '{'+
        '    "deleted": true,'+
        '    "index": "'+TEST_INDEX_NAME+'"'+
        '}';
    
    private static String ADD_TO_TEXT_INDEX_RESPONSE = 
        '{'+
        '    "index": "'+TEST_INDEX_NAME+'",'+
        '    "references": ['+
        '        {'+
        '            "reference": "reference1",'+
        '            "id": 1'+
        '        }'+
        '    ]'+
        '}';

    private static String LANGUAGE_IDENTIFICATION_RESPONSE = 
        '{'+
        '    "language": "english",'+
        '    "language_iso639_2b": "ENG",'+
        '    "encoding": "UTF8",'+
        '    "unicode_scripts": ['+
        '        "Basic Latin"'+
        '    ]'+
        '}';
        
    private static String SENTIMENT_ANALYSIS_RESPONSE = 
        '{'+
        '    "positive": ['+
        '        {'+
        '            "sentiment": "positive",'+
        '            "topic": "aspect",'+
        '            "score": 0.7176687736973063,'+
        '            "original_text": "aspect is positive",'+
        '            "original_length": 18,'+
        '            "normalized_text": "aspect is positive",'+
        '            "normalized_length": 18'+
        '        },'+
        '        {'+
        '            "sentiment": "improve",'+
        '            "topic": "null",'+
        '            "score": 0.5685799620527161,'+
        '            "original_text": "improve the overall accuracy",'+
        '            "original_length": 24,'+
        '            "normalized_text": "improve the overall accuracy",'+
        '            "normalized_length": 24'+
        '        }'+
        '    ],'+
        '    "negative": ['+
        '    ],'+
        '    "aggregate": {'+
        '        "sentiment": "positive",'+
        '        "score": 0.24889620949015628'+
        '    }'+
        '}';
        
    // find similar response
    private static String FIND_SIMILAR_RESPONSE = 
        '{'+
        '    "documents": ['+
        '        {'+
        '            "reference": "500d0000003H6HyAAK",'+
        '            "weight": 85.56,'+
        '            "links": ['+
        '                "APEX"'+
        '            ],'+
        '            "index": "'+TEST_INDEX_NAME+'",'+
        '            "title": "The Apex development team changed",'+
        '            "accountid": ['+
        '                "001d000000Aa3utAAB"'+
        '            ],'+
        '            "accountname": ['+
        '                "United Oil & Gas, UK"'+
        '            ],'+
        '            "contactid": ['+
        '                "003d000000AbX65AAF"'+
        '            ],'+
        '            "contactname": ['+
        '                "Ashley James"'+
        '            ],'+
        '            "recordtypeid": ['+
        '                "012d0000000hGLmAAM"'+
        '            ],'+
        '            "recordtypename": ['+
        '                "Issue"'+
        '            ],'+
        '            "type": ['+
        '                "Mechanical"'+
        '            ],'+
        '            "priority": ['+
        '                "Medium"'+
        '            ],'+
        '            "status": ['+
        '                "New"'+
        '            ],'+
        '            "created_date": ['+
        '                "2012-06-05T05:54:55.000Z"'+
        '            ],'+
        '            "last_modified_date": ['+
        '                "2014-05-12T01:01:11.000Z"'+
        '            ],'+
        '            "language": ['+
        '                "english"'+
        '            ],'+
        '            "content": "I am using version\\n"'+
        '        }'+
        '    ]'+
        '}';

    // find related concepts response
    private static String FIND_RELATED_CONCEPTS_RESPONSE = 
        '{'+
        '    "entities": ['+
        '        {'+
        '            "text": "JSON serialization",'+
        '            "docs_with_phrase": 2,'+
        '            "occurrences": 5,'+
        '            "docs_with_all_terms": 2,'+
        '            "cluster": -3'+
        '        }'+
        '    ]'+
        '}';

    // sample failed response
    private static String FAILURE_RESPONSE = 
        '{'+
        '    "error": 4004,'+
        '    "reason": "Invalid job action",'+
        '    "detail": {'+
        '        "message": "API not found",'+
        '        "action": "createtextindessx",'+
        '        "version": "v1"'+
        '    }'+
        '}';

    private static String EXPAND_CONTAINER_RESPONSE = 
        '{'+
            +'"files": ['+
                +'{'+
                    +'"name": "myfolder/worksheet.xls",'+
                    +'"reference": "e04beffc-ec71-4f6f-9d25-2ff988c8ab3c"'+
                +'} ]'+
        +'}';   

    private static String TEXT_EXTRACTION_RESPONSE = '{"document": [ { "reference": "root", "doc_iod_reference": "dd4a9c274eda24f9bac59c065cf979e4", "app_name": [ "Microsoft Office Word" ], "author": [ "janesmith" ], "content": "This is the content of my document..." } ]}';  
    private static String STORE_OBJECT_RESPONSE = '{"reference": "1f5b4d7d-cc91-4157-aadf-04f5b236a3e7"}';
    
    private static string EXTRACT_TEXT_FROM_IMAGE_RESPONSE = '{"text_block":[{"text": "Be aware of the following","left": 0,"top": 0,"width": 688,"height": 1096}]}';
    private static string VIEWDOCUMENT_RESPONSE = '{"document": "PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMC8vRU4iPgo8aHRtbD4KPGhlYWQ+CiAgICA8bWV0YSBuYW1lPSJBdXRob3IiIGNvbnRlbnQ9IiIgLz4KICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PXV0Zi04IiAvPgo8L2hlYWQ+Cjxib2R5Pgo8cCBzdHlsZT0idGV4dC1hbGlnbjpsZWZ0O21hcmdpbi10b3A6MC4wMGluO21hcmdpbi1ib3R0b206MC4wMGluOyI+Cjxmb250IHN0eWxlPSJmb250LXNpemU6MTJwdDsiPkkgbGlrZSBjYXRzPC9mb250Pgo8L3A+CjwvYm9keT4KPC9odG1sPg=="}';
    private static string RECOGNIZEBARCODES_RESPONSE = '{"barcode":[{"text":"2404105001722","barcode_type":"ean-13","left":49,"top":121,"width":128,"height":54,"additional_information":{"country":"Restricteddistribution(MOdefined)"}}]}';
    private static string detectFaces_RESPONSE = '{"face":[{"left":266,"top":196,"width":60,"height":67},{"left":147,"top":283,"width":102,"height":112},{"left":126,"top":126,"width":82,"height":74},{"left":373,"top":259,"width":60,"height":67}]}';
    private static string EXPANDTERMS_RESPONSE = '{"terms":[{"term":"PIRABEB"}]}';
}