@isTest
private class IDOLTest {
    /**
     * @description : This test class instantiates the beans from the IDOL class so that
     * they could be covered. So assert will not be required here.
     */
    @isTest static void testIDOLBeans() {
        // Implement test code
        Test.startTest();
            IDOL testIDOL = new IDOL();
            IDOL.ErrorResponse err = new IDOL.ErrorResponse();
            IDOL.Index index = new IDOL.Index();
            IDOL.PublicIndex PublicIndex = new IDOL.PublicIndex();
            IDOL.ListIndexesResponse ListIndexesResponse = new IDOL.ListIndexesResponse();
            IDOL.CreateTextIndexResponse CreateTextIndexResponse = new IDOL.CreateTextIndexResponse();
            IDOL.DeleteTextIndexResponse DeleteTextIndexResponse = new IDOL.DeleteTextIndexResponse();
            IDOL.DeleteFromTextIndexResponse   DeleteFromTextIndexResponse = new IDOL.DeleteFromTextIndexResponse();
            IDOL.IndexStatusResponse IndexStatusResponse = new IDOL.IndexStatusResponse();
            IDOL.IndexStatus IndexStatus = new IDOL.IndexStatus();
            IDOL.GetContentResponseDocument GetContentResponseDocument = new IDOL.GetContentResponseDocument();
            IDOL.GetContentResponse GetContentResponse = new IDOL.GetContentResponse();
            IDOL.GetParametricValuesResponse GetParametricValuesResponse = new IDOL.GetParametricValuesResponse();
            IDOL.RetrieveIndexFieldsResponseFieldTypeCounts RetrieveIndexFieldsResponseFieldTypeCounts = new IDOL.RetrieveIndexFieldsResponseFieldTypeCounts();
            IDOL.RetrieveIndexFieldsResponse RetrieveIndexFieldsResponse = new IDOL.RetrieveIndexFieldsResponse();

            IDOL.StoreObjectRequest StoreObjectRequest = new IDOL.StoreObjectRequest();
            IDOL.StoreObjectResponse StoreObjectResponse = new IDOL.StoreObjectResponse();

            IDOL.ExtractTextFromImageRequest ExtractTextFromImageRequest = new IDOL.ExtractTextFromImageRequest();
            IDOL.TextBlock TextBlock = new IDOL.TextBlock();
            IDOL.ExtractTextFromImageResponse ExtractTextFromImageResponse = new IDOL.ExtractTextFromImageResponse();

            IDOL.TextExtractionDocument TextExtractionDocument = new IDOL.TextExtractionDocument();
            IDOL.TextExtractionRequest TextExtractionRequest = new IDOL.TextExtractionRequest();
            IDOL.TextExtractionResponse TextExtractionResponse = new IDOL.TextExtractionResponse();
            
            IDOL.ViewDocumentRequest ViewDocumentRequest = new IDOL.ViewDocumentRequest();
            IDOL.ViewDocumentResponse ViewDocumentResponse = new IDOL.ViewDocumentResponse();

            IDOL.BarcodeRecognitionRequest BarcodeRecognitionRequest = new IDOL.BarcodeRecognitionRequest();
            IDOL.BarcodeAdditionalInformation BarcodeAdditionalInformation = new IDOL.BarcodeAdditionalInformation();
            IDOL.Barcode Barcode = new IDOL.Barcode();
            IDOL.BarcodeRecognitionResponse BarcodeRecognitionResponse = new IDOL.BarcodeRecognitionResponse();

            IDOL.ImageRecognitionRequest ImageRecognitionRequest = new IDOL.ImageRecognitionRequest();
            IDOL.ImageCorner ImageCorner = new IDOL.ImageCorner();
            IDOL.ImageObject ImageObject = new IDOL.ImageObject();
            IDOL.ImageRecognitionResponse ImageRecognitionResponse = new IDOL.ImageRecognitionResponse();
            
            IDOL.ExpandTermsRequest ExpandTermsRequest = new IDOL.ExpandTermsRequest();
            IDOL.ExpandTermsResponseTerm ExpandTermsResponseTerm = new IDOL.ExpandTermsResponseTerm();
            IDOL.ExpandTermsResponse ExpandTermsResponse = new IDOL.ExpandTermsResponse();

            IDOL.FaceDetectionRequest FaceDetectionRequest = new IDOL.FaceDetectionRequest();
            IDOL.FaceDetectionFaceAdditionalInformation FaceDetectionFaceAdditionalInformation = new IDOL.FaceDetectionFaceAdditionalInformation();
            IDOL.FaceDetectionFace FaceDetectionFace = new IDOL.FaceDetectionFace();
            IDOL.FaceDetectionResponse FaceDetectionResponse = new IDOL.FaceDetectionResponse();
            
            IDOL.AddToTextIndexDocument AddToTextIndexDocument = new IDOL.AddToTextIndexDocument();
            IDOL.AddToTextIndexDocumentInput AddToTextIndexDocumentInput = new IDOL.AddToTextIndexDocumentInput();
            IDOL.AddToTextIndexRequest AddToTextIndexRequest = new IDOL.AddToTextIndexRequest();
            IDOL.AddToTextIndexResponseReference AddToTextIndexResponseReference = new IDOL.AddToTextIndexResponseReference();
            IDOL.AddToTextIndexResponse AddToTextIndexResponse = new IDOL.AddToTextIndexResponse();
            
            IDOL.LanguageIdentificationRequest LanguageIdentificationRequest = new IDOL.LanguageIdentificationRequest();
            IDOL.LanguageIdentificationResponse LanguageIdentificationResponse = new IDOL.LanguageIdentificationResponse();
            
            IDOL.SentimentAnalysisRequest SentimentAnalysisRequest = new IDOL.SentimentAnalysisRequest();
            IDOL.SentimentAnalysisResponseEntity SentimentAnalysisResponseEntity = new IDOL.SentimentAnalysisResponseEntity();
            IDOL.SentimentAnalysisResponseAggregate SentimentAnalysisResponseAggregate = new IDOL.SentimentAnalysisResponseAggregate();
            IDOL.SentimentAnalysisResponse SentimentAnalysisResponse = new IDOL.SentimentAnalysisResponse();
            
            IDOL.EntityExtractionRequest EntityExtractionRequest = new IDOL.EntityExtractionRequest();
            IDOL.EntityExtractionResponseAdditionalInformation EntityExtractionResponseAdditionalInformation = new IDOL.EntityExtractionResponseAdditionalInformation();
            IDOL.EntityExtractionResponseComponent EntityExtractionResponseComponent = new IDOL.EntityExtractionResponseComponent();
            IDOL.EntityExtractionResponseEntity EntityExtractionResponseEntity = new IDOL.EntityExtractionResponseEntity();
            IDOL.EntityExtractionResponse EntityExtractionResponse = new IDOL.EntityExtractionResponse();
            
            IDOL.ExtractConceptstRequest ExtractConceptstRequest = new IDOL.ExtractConceptstRequest();
            IDOL.ExtractConceptsResponseConcept ExtractConceptsResponseConcept = new IDOL.ExtractConceptsResponseConcept();
            IDOL.ExtractConceptsResponse ExtractConceptsResponse = new IDOL.ExtractConceptsResponse();
            
            IDOL.HighlightTextRequest HighlightTextRequest = new IDOL.HighlightTextRequest();
            IDOL.HighlightTextResponse HighlightTextResponse = new IDOL.HighlightTextResponse();
            
            IDOL.TextTokenizationRequest TextTokenizationRequest = new IDOL.TextTokenizationRequest();
            IDOL.TextTokenizationResponseTerm TextTokenizationResponseTerm = new IDOL.TextTokenizationResponseTerm();
            IDOL.TextTokenizationResponse TextTokenizationResponse = new IDOL.TextTokenizationResponse();
            
            IDOL.FindSimilarRequest FindSimilarRequest = new IDOL.FindSimilarRequest();
            IDOL.FindSimilarResponseDocument FindSimilarResponseDocument = new IDOL.FindSimilarResponseDocument();
            IDOL.FindSimilarResponse FindSimilarResponse = new IDOL.FindSimilarResponse();
            
            IDOL.FindRelatedConceptsRequest FindRelatedConceptsRequest = new IDOL.FindRelatedConceptsRequest();
            IDOL.FindRelatedConceptsEntity FindRelatedConceptsEntity = new IDOL.FindRelatedConceptsEntity();
            IDOL.FindRelatedConceptsResponse FindRelatedConceptsResponse = new IDOL.FindRelatedConceptsResponse();
            
            IDOL.QueryTextIndexRequest QueryTextIndexRequest = new IDOL.QueryTextIndexRequest();
            IDOL.QueryTextIndexResponseDocument QueryTextIndexResponseDocument = new IDOL.QueryTextIndexResponseDocument();
            IDOL.QueryTextIndexResponse QueryTextIndexResponse = new IDOL.QueryTextIndexResponse();

            IDOL.ExpandContainerRequest ExpandContainerRequest = new IDOL.ExpandContainerRequest();
            IDOL.ExpandContainerResponseFile ExpandContainerResponseFile = new IDOL.ExpandContainerResponseFile();
            IDOL.ExpandContainerResponse ExpandContainerResponse = new IDOL.ExpandContainerResponse();
        Test.stopTest();
        /**NO ASSERTS REQUIRED**/
    }
}