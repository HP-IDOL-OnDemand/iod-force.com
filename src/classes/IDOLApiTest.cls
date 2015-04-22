/**
 * Test IDOLApi class
 */
@isTest
private class IDOLApiTest {
    
    private static IDOL_API_Config__c apiConfig;
    private static IDOLApi idolApi;
    
    // test IDOL List Indexes
    // expect successful List Indexes response
    @isTest
    private static void testListIndexes() {
        testSetup(true);
        
        Test.startTest();
        IDOL.ListIndexesResponse resp = idolApi.listIndexes();
        
        // assert
        System.assertEquals(2, resp.public_index.size());
        System.assertEquals(1, resp.index.size());
        IDOL.Index index = resp.index.get(0);
        System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, index.index);
        System.assertEquals('content', index.type);
        System.assertEquals('standard', index.flavor);
        Test.stopTest();
    }
    
    // test IDOL Create Text Index
    // expect successful Create Text Index reponse
    @isTest
    private static void testCreateTextIndex() {
        testSetup(true);

        Test.startTest();
        IDOL.CreateTextIndexResponse resp = idolApi.createTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, IDOL.IndexFlavor.standard, 'description1');
        
        // assert
        System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
        System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
        System.assertEquals('message1', resp.message);
        Test.stopTest();
    }

    // test IDOL Index Status
    // expect successful Index Status response
    @isTest
    private static void testIndexStatus() {
        testSetup(true);

        Test.startTest();
        // first delete request return confirm hash
        IDOL.IndexStatusResponse resp = idolApi.indexStatus(IDOL_TestHelper.TEST_INDEX_NAME);
        
        // assert
        IDOL.IndexStatus indexstatus = resp.indexstatus;
        System.assertEquals(1, indexstatus.total_documents);
        System.assertEquals(296, indexstatus.total_index_size);
        System.assertEquals(1, indexstatus.hr24_index_updates);
    }
    
    // test IDOL Delete Text Index
    // expect successful Delete Text Index
    @isTest
    private static void testDeleteTextIndex() {
        testSetup(true);

        Test.startTest();
        
            // first delete request return confirm hash
            IDOL.DeleteTextIndexResponse resp = idolApi.deleteTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, null);
            
            // assert
            System.assertEquals(false, resp.deleted);
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
            System.assert(resp.confirm != null);
            
            // second request with confirm deletes the index
            resp = idolApi.deleteTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, resp.confirm);
            System.assertEquals(true, resp.deleted);
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
            
        Test.stopTest();
    }
    
    // test IDOL Add To Text Index
    // expect successful Add To Text Index reponse
    @isTest
    private static void testAddToTextIndex() {
        testSetup(true);
        
        IDOL.AddToTextIndexDocument document = new IDOL.AddToTextIndexDocument();
        document.title = 'This is my document';
        document.reference = 'CaseId-12345';
        document.content = 'document content';
        IDOL.AddToTextIndexDocument[] documents = new IDOL.AddToTextIndexDocument[] {document};
        IDOL.AddToTextIndexDocumentInput documentInput = new IDOL.AddToTextIndexDocumentInput();
        documentInput.documents = documents;
        
        Test.startTest();
        
            // use json for text input
            IDOL.AddToTextIndexResponse resp = idolApi.addToTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, IDOL.InputSource.json, documentInput, IDOL.DuplicateMode.replace);
            
            // assert
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
            System.assertEquals(1, resp.references.size());
            IDOL.AddToTextIndexResponseReference references = resp.references.get(0);
            System.assertEquals(1, references.id);
            System.assertEquals('reference1', references.reference);
            
        Test.stopTest();
    }
    
    @isTest
    private static void testAddToTextIndex1() {
        testSetup(true); 
        Test.startTest();
        
            IDOL.AddToTextIndexRequest req = new IDOL.AddToTextIndexRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            req.index = IDOL_TestHelper.TEST_INDEX_NAME;
            IDOL.AddToTextIndexResponse resp = idolApi.AddToTextIndex(req);
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, resp.index);
            
        Test.stopTest();
    }
    // test IDOL Language Identification
    // expect successful Language Identification response
    @isTest
    private static void testLanguageIdentification() {
        testSetup(true); 

        Test.startTest();
        
            // use text for text input
            IDOL.languageIdentificationRequest req = new IDOL.languageIdentificationRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'input text should be at least three words';
            IDOL.LanguageIdentificationResponse resp = idolApi.identifyLanguage(req);
            
            // assert
            System.assertEquals(IDOL.Language.english.name(), resp.language);
            System.assertEquals(IDOL.LanguageIso639_2b.ENG.name(), resp.language_iso639_2b);
            System.assertEquals(IDOL.Encoding.UTF8.name(), resp.encoding);
            System.assertEquals(1, resp.unicode_scripts.size());
            System.assertEquals('Basic Latin', resp.unicode_scripts.get(0));
            
        Test.stopTest();
    }
    
    // test IDOL Sentiment Analysis
    // expect successful Sentiment Analysis response
    @isTest
    private static void testSentimentAnalysis() {
        testSetup(true);
        
        Test.startTest();
        
            // use text for text input
            IDOL.SentimentAnalysisRequest req = new IDOL.SentimentAnalysisRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'this is going to be good year for me';
            IDOL.SentimentAnalysisResponse resp = idolApi.analyzeSentiment(req);
            
            // assert
            System.assertEquals(IDOL.Sentiment.positive.name(), resp.aggregate.sentiment);
            System.assertEquals(2, resp.positive.size());
            System.assertEquals(0, resp.negative.size());
            IDOL.SentimentAnalysisResponseEntity entity = resp.positive.get(0);
            System.assertEquals(IDOL.Sentiment.positive.name(), entity.sentiment);
            System.assertEquals('aspect', entity.topic);
            System.assertEquals('aspect is positive', entity.original_text);
            System.assertEquals(18, entity.original_length);
            System.assertEquals('aspect is positive', entity.normalized_text);
            System.assertEquals(18, entity.normalized_length);
            
        Test.stopTest();
    }
    
    // test IDOL Find Similar request
    // expect successful Find Similar response
    @isTest
    private static void testFindSimilar() {
        testSetup(true);
        
        Test.startTest();
        
            // use text for text input
            IDOL.FindSimilarRequest req = new IDOL.FindSimilarRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'search keyword';
            req.print = IDOL.Print.all.name();
            req.indexes = IDOL_TestHelper.TEST_INDEX_NAME;
            IDOL.FindSimilarResponse resp = idolApi.findSimilar(req);
            IDOL.FindSimilarResponseDocument doc = resp.documents.get(0);  // there is one document
            
            // assert
            System.assertEquals('500d0000003H6HyAAK', doc.reference);
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, doc.index);
            //System.assertEquals('Ashley James', doc.contactname.get(0));

        Test.stopTest();
    }

    // test IDOL Query Text Index request
    // expect successful Query Text Index response
    @isTest
    private static void testSearchTextIndex() {
        testSetup(true);
        
        Test.startTest();
        
            // use text for text input
            IDOL.QueryTextIndexRequest req = new IDOL.QueryTextIndexRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'search keyword';
            req.print = IDOL.Print.all.name();
            req.indexes = IDOL_TestHelper.TEST_INDEX_NAME;
            IDOL.QueryTextIndexResponse resp = idolApi.queryTextIndex(req);
            IDOL.QueryTextIndexResponseDocument doc = resp.documents.get(0);  // there is one document
            
            // assert
            System.assertEquals('500d0000003H6HyAAK', doc.reference);
            System.assertEquals(IDOL_TestHelper.TEST_INDEX_NAME, doc.index);
            //System.assertEquals('Ashley James', doc.contactname.get(0));

        Test.stopTest();
    }
    
    // test IDOL Find Related Concepts
    // expect successful Find Related Concepts response
    @isTest
    private static void testFindRelatedConcepts() {
        testSetup(true);
        
        Test.startTest();
        
            // use text for text input
            IDOL.FindRelatedConceptsRequest req = new IDOL.FindRelatedConceptsRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'search keyword';
            req.index = IDOL_TestHelper.TEST_INDEX_NAME;
            IDOL.FindRelatedConceptsResponse resp = idolApi.findRelatedConcepts(req);
            
            // assert
            System.assertEquals(1, resp.entities.size());
            IDOL.FindRelatedConceptsEntity entity = resp.entities.get(0);
            System.assertEquals(2, entity.docs_with_phrase);
            System.assertEquals(5, entity.occurrences);

        Test.stopTest();
    }
    
    // test IDOL Store Object
    // expect successful Store Object response
    
    @isTest
    private static void testStoreObject() {
        testSetup(true);
        string Name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
        
            // by image URL
            IDOL.StoreObjectRequest req = new IDOL.StoreObjectRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            IDOL.StoreObjectResponse resp = idolApi.storeObject(req);
            System.assertEquals('1f5b4d7d-cc91-4157-aadf-04f5b236a3e7', resp.reference);
            
            // by file
            req = new IDOL.StoreObjectRequest();
            req.source = IDOL.InputSource.file;
            Attachment att = new Attachment();
            att.Name = name;
            att.Body = bodyBlob;
            req.input = att;
            resp = idolApi.storeObject(req);
            System.assertEquals('1f5b4d7d-cc91-4157-aadf-04f5b236a3e7', resp.reference);
            
            //by reference
            req = new IDOL.StoreObjectRequest();
            req.source = IDOL.InputSource.reference;
            req.input = 'dd4a9c2-74eda24f9-bac59c065-cf979e4';
            resp = idolApi.storeObject(req);
            System.assertEquals('1f5b4d7d-cc91-4157-aadf-04f5b236a3e7', resp.reference);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.storeObject(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.storeObject(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.storeObject(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
        Test.stopTest();
    }
    
    
    // test IDOL Expand Container
    // expect successful Expand Container response
    
    @isTest
    private static void testExpandContainer() {
        testSetup(true);
        
        String reference = '1f5b4d7d-cc91-4157-aadf-04f5b236a3e7';
        
        Test.startTest();
        // use text for text input
        IDOL.ExpandContainerRequest req = new IDOL.ExpandContainerRequest();
        req.source = IDOL.InputSource.reference;
        req.input = reference; 
        IDOL.ExpandContainerResponse resp = idolApi.expandContainer(req);

        // assert
        System.assertEquals(1, resp.files.size(), 'Expand container expected 1 file');
        IDOL.ExpandContainerResponseFile file = resp.files[0];
        System.assertEquals('myfolder/worksheet.xls', file.name);
        System.assertEquals('e04beffc-ec71-4f6f-9d25-2ff988c8ab3c', file.reference);

        Test.stopTest();
    }
    
    
    // test IDOL Text Extraction
    // expect successful Text Extraction response
    
    @isTest
    private static void testTextExtraction() {
        testSetup(true);
        
        Test.startTest();
            // use text for text input
            IDOL.TextExtractionRequest req = new IDOL.TextExtractionRequest();
            req.source = IDOL.InputSource.reference;
            req.input = '1f5b4d7d-cc91-4157-aadf-04f5b236a3e7';
            IDOL.TextExtractionResponse resp = idolApi.extractText(req);
    
            // assert
            System.assertEquals(1, resp.document.size(), 'Text extraction expected 1 document');
            
            IDOL.TextExtractionDocument doc = resp.document[0];
            
            System.assertEquals('root', doc.reference);
            System.assertEquals('dd4a9c274eda24f9bac59c065cf979e4', doc.doc_iod_reference);
            System.assertEquals('Microsoft Office Word', doc.app_name[0]);
            System.assertEquals('janesmith', doc.author[0]);
            System.assertEquals('This is the content of my document...', doc.content);
            
        Test.stopTest();
    }
    
    
    
    // test IDOL API failure
    // expect IDOLException is thrown
    @isTest
    private static void testAPIFailure() {
        testSetup(false);

        String errorMessage = '4004:Invalid job action';
        
        Test.startTest();
        
        // failure test for List Indexes
        try {
            idolApi.listIndexes();
        } catch (Exception e) {
            System.debug(e);
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Create Text Index
        try {
            idolApi.createTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, IDOL.IndexFlavor.standard, 'description1');
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Index Status
        try {
            idolApi.indexStatus(IDOL_TestHelper.TEST_INDEX_NAME);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Delete Text Index
        try {
            idolApi.deleteTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, null);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Add To Text Index
        IDOL.AddToTextIndexDocument document = new IDOL.AddToTextIndexDocument();
        document.title = 'This is my document';
        document.reference = 'CaseId-12345';
        document.content = 'document content';
        //document.accountname = 'account1';
        IDOL.AddToTextIndexDocument[] documents = new IDOL.AddToTextIndexDocument[] {document};
        
        IDOL.AddToTextIndexDocumentInput documentInput = new IDOL.AddToTextIndexDocumentInput();
        documentInput.documents = documents;
        
        try {
            idolApi.addToTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, IDOL.InputSource.json, documentInput, IDOL.DuplicateMode.replace);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Language Identification
        try {
            IDOL.languageIdentificationRequest req = new IDOL.languageIdentificationRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'input text should be at least three words';
            idolApi.identifyLanguage(req);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        // failure test for Sentiment Analysis
        try {
            IDOL.SentimentAnalysisRequest req = new IDOL.SentimentAnalysisRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'this is going to be good year for me';
            idolApi.analyzeSentiment(req);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assertEquals(true, e.getMessage().startsWith(errorMessage));
        }
        
        Test.stopTest();
    }
    
    // test the invalid parameters in IDOL API methods
    // expect IDOLException is thrown
    @isTest
    private static void testInputParameters() {
        testSetup(false);

        Test.startTest();

        // flavor is required for Create Text Index
        try {
            idolApi.createTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, null, 'description1');
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assert(e.getMessage().contains('required'));
        }
        
        // index is required for Index Status
        try {
            idolApi.indexStatus(null);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assert(e.getMessage().contains('required'));
        }
        
        // index is required for Delete Text Index
        try {
            idolApi.deleteTextIndex(null, 'confirm');
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assert(e.getMessage().contains('required'));
        }

        // json is required for Add To Text Index
        try {
            IDOL.AddToTextIndexDocumentInput documentInput = new IDOL.AddToTextIndexDocumentInput();
            idolApi.addToTextIndex(IDOL_TestHelper.TEST_INDEX_NAME, null, documentInput, IDOL.DuplicateMode.replace);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assert(e.getMessage().contains('required'));
        }
        
        // text input is required for Language Identification
        try {
            IDOL.languageIdentificationRequest req = new IDOL.languageIdentificationRequest();
            req.source = IDOL.InputSource.text;
            req.input = null;
            idolApi.identifyLanguage(req);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
            System.assert(e.getMessage().contains('required'));
        }
        
        // text input is required for Sentiment Analysis
        try {
            IDOL.SentimentAnalysisRequest req = new IDOL.SentimentAnalysisRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'this is going to be good year for me';
            idolApi.analyzeSentiment(req);
        } catch (Exception e) {
            System.assert(e instanceof IDOLException);
        }
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testNegativeScenarios(){
        testSetup(false);

        Test.startTest();
        
            IDOL_API_Config__c config = new IDOL_API_Config__c(Name='topcoder', API_URL__c='https://IDOLondemand.com/', API_Key__c='abcf-fda-fdsa-fafa',
                    API_Version__c='1', API_Logging__c=false);
            IDOLApi api2 = new IDOLApi(config);
            api2.getFieldText(IDOL.FieldTextOperator.MATCH, 'abc','value');
            api2.getFieldTextDateRange('fieldname', system.today(), system.today().adddays(1));
        
            try{
                IDOL.QueryTextIndexRequest req = new IDOL.QueryTextIndexRequest();
                req.source = IDOL.InputSource.text;
                req.input = 'text test';
                req.print = IDOL.PRINT.fields.name();
                req.indexes = null;
                req.field_text = 'field_text';
                api2.queryTextIndex(req);
                system.assertEquals( true, false);
            }catch(IDOLException ex){
                system.assertEquals(true, true);
            }
        
            try{
                IDOL.FindSimilarRequest req = new IDOL.FindSimilarRequest();
                req.source = IDOL.InputSource.text;
                req.input = 'text test';
                req.print = IDOL.PRINT.fields.name();
                req.indexes = null;
                req.field_text = 'field_text';
                api2.findSimilar(req);
                system.assertEquals( true, false);
            }catch( IDOLException ex ){
                system.assertEquals(true, true);
            }
            
            try{
                IDOL.FindRelatedConceptsRequest req = new IDOL.FindRelatedConceptsRequest();
                req.source = IDOL.InputSource.text;
                req.input = 'text test';
                req.index = null;
                req.field_text = 'field_text';
                api2.findRelatedConcepts(req);
                system.assertEquals( true, false);
            }catch(IDOLException ex){
                system.assertEquals(true, true);
            }
        
            api2.getLanguageCode('english');
            api2.persistApiLogCache();
        
        Test.stopTest();
    }
    
    @isTest
    private static void testExtractTextFromImage(){
        testSetup(true);
        string Name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
            
            IDOL.ExtractTextFromImageRequest req = new IDOL.ExtractTextFromImageRequest();
            //by file
            req.source = IDOL.InputSource.file;
            Attachment att = new Attachment();
            att.Name = name;
            att.Body = bodyBlob;
            req.input = att;
            IDOL.ExtractTextFromImageResponse resp = idolApi.extractTextFromImage(req);
            System.assertEquals( 'Be aware of the following', resp.text_block[0].text);
            
            //by url
            req = new IDOL.ExtractTextFromImageRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            resp = idolApi.extractTextFromImage(req);
            System.assertEquals( 'Be aware of the following', resp.text_block[0].text);
            
            //by reference
            req = new IDOL.ExtractTextFromImageRequest();
            req.source = IDOL.InputSource.reference;
            req.input = 'dd4a9c2-74eda24f9-bac59c065-cf979e4';
            resp = idolApi.extractTextFromImage(req);
            System.assertEquals( 'Be aware of the following', resp.text_block[0].text);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.extractTextFromImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.extractTextFromImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.extractTextFromImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
        Test.stopTest();
    }
    
    @isTest
    private static void testViewDocument(){
        testSetup(true);
        string Name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
        
            IDOL.ViewDocumentRequest req = new IDOL.ViewDocumentRequest();
            //by file
            req.source = IDOL.InputSource.file;
            Attachment att = new Attachment();
            att.Name = name;
            att.Body = bodyBlob;
            req.input = att;
            IDOL.ViewDocumentResponse resp = idolApi.viewDocument(req);
            system.debug(resp.document);
            System.assertNotEquals(null, resp.document);
            
            //by url
            req = new IDOL.ViewDocumentRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            resp = idolApi.viewDocument(req);
            System.assertNotEquals(null, resp.document);
            
            //by reference
            req = new IDOL.ViewDocumentRequest();
            req.source = IDOL.InputSource.reference;
            req.input = 'dd4a9c2-74eda24f9-bac59c065-cf979e4';
            resp = idolApi.viewDocument(req);
            System.assertNotEquals(null, resp.document);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.viewDocument(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.viewDocument(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.viewDocument(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testRecognizeBarcode(){
        testSetup(true);
        string name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
        
            // by image URL
            IDOL.BarcodeRecognitionRequest req = new IDOL.BarcodeRecognitionRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            IDOL.BarcodeRecognitionResponse resp = idolApi.recognizeBarcodes(req);
            System.assertEquals('2404105001722', resp.barcode[0].text);
            
            // by file
            req = new IDOL.BarcodeRecognitionRequest();
            req.source = IDOL.InputSource.file;
            Attachment att = new Attachment();
            att.Name = name;
            att.Body = bodyBlob;
            req.input = att;
            resp = idolApi.recognizeBarcodes(req);
            System.assertEquals('2404105001722', resp.barcode[0].text);
            
            //by reference
            req = new IDOL.BarcodeRecognitionRequest();
            req.source = IDOL.InputSource.reference;
            req.input = 'dd4a9c2-74eda24f9-bac59c065-cf979e4';
            resp = idolApi.recognizeBarcodes(req);
            System.assertEquals('2404105001722', resp.barcode[0].text);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.recognizeBarcodes(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.recognizeBarcodes(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.recognizeBarcodes(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
        Test.stopTest();
    }
    
    @isTest
    private static void testDetectFaces(){
        testSetup(true);
        string name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
            
            // by image URL
            IDOL.FaceDetectionRequest req = new IDOL.FaceDetectionRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.IDOLondemand.com/sample-content/barcode/bc4.jpg';
            IDOL.FaceDetectionResponse resp = idolApi.detectFaces(req);
            System.assertEquals(266, resp.face[0].left);
            
            // by file
            req = new IDOL.FaceDetectionRequest();
            req.source = IDOL.InputSource.file;
            Attachment att = new Attachment();
            att.Name = name;
            att.Body = bodyBlob;
            req.input = att;
            resp = idolApi.detectFaces(req);
            System.assertEquals(266, resp.face[0].left);
            
            //by reference
            req = new IDOL.FaceDetectionRequest();
            req.source = IDOL.InputSource.reference;
            req.input = 'dd4a9c2-74eda24f9-bac59c065-cf979e4';
            resp = idolApi.detectFaces(req);
            System.assertEquals(266, resp.face[0].left);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.detectFaces(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.detectFaces(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.detectFaces(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
        Test.stopTest();
    }
    
    
    @isTest
    private static void testExpandTerms(){
        testSetup(true);
        string name='abc.jpg';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Test.startTest();
        
            IDOL.ExpandTermsRequest req = new IDOL.ExpandTermsRequest();
            req.source = IDOL.InputSource.text;
            req.input = 'probability';
            req.expansion = IDOL.ExpandTermsExpansionType.fuzzy;
            req.sort_by = IDOL.ExpandTermsSort.none;
            IDOL.ExpandTermsResponse resp = idolApi.expandTerms(req);
            System.assertEquals('PIRABEB', resp.terms[0].term);
        
        Test.stopTest();
    }
    
    @isTest
    private static void testRecognizeImage(){
        testSetup(true);
        Test.startTest();
        
            // by image URL
            IDOL.ImageRecognitionRequest req = new IDOL.ImageRecognitionRequest();
            req.source = IDOL.InputSource.url;
            req.input = 'https://www.idolondemand.com/sample-content/images/aviva.jpg';
            IDOL.ImageRecognitionResponse resp = null;
            // resp = idolApi.recognizeImage(req);
            //System.assertEquals('AV', resp.image_object[0].name);
            
            // negative tests.
            try{
                req.input = null;
                resp = idolApi.recognizeImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.url;
                req.input = null;
                resp = idolApi.recognizeImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
            try{
                req.source = IDOL.InputSource.file;
                req.input = null;
                resp = idolApi.recognizeImage(req);
            }catch(IDOLException ex){
                system.assertEquals(true, true); // exception expected.
            }
            
        Test.stopTest();
    }
    
    // Initialize objects for testing and set up mock for Http callout response.
    // Called at the beginning of each test.
    private static void testSetup(Boolean successful) {
        // create and insert custom config for test
        apiConfig = IDOL_TestHelper.createTestApiConfig('TopCoder');
        
        idolApi = new IDOLApi();
        
        // set mock callout class implementing the HttpCalloutMock Interface
        if (successful) {
            // set successful response mock
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockIDOLSuccessResponseGenerator());
        } else {
            // set failure response mock
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockIDOLFailureResponseGenerator());
        }
    }
    
    
}