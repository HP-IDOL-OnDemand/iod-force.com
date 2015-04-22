/**
 * The IDOL API interface with synchronous invocation.
 */
public class IDOLApi {

    public static final String IDOL_APIKEY = 'apikey';
    public static final String SYNC = '/sync';
    public static final String ASYNC = '/async';
    
    // Format Conversion APIs
    public static final String STORE_OBJECT_PATH = '/storeobject';
    public static final String EXPAND_CONTAINER_PATH = '/expandcontainer';
    public static final String TEXT_EXTRACTION_PATH = '/extracttext';
    public static final String OCR_PATH = '/ocrdocument';
    public static final String VIEW_DOCUMENT_PATH = '/viewdocument';
    // Image Analysis APIs
    public static final String BARCODE_RECOGNITION_PATH = '/recognizebarcodes';
    public static final String FACE_DETECTION_PATH = '/detectfaces';
    public static final String IMAGE_RECOGNITION_PATH = '/recognizeimages';
    // Indexing APIs
    public static final String LIST_INDEXES_PATH = '/listindexes';
    public static final String CREATE_TEXT_INDEX_PATH = '/createtextindex';
    public static final String DELETE_TEXT_INDEX_PATH = '/deletetextindex';
    public static final String DELETE_FROM_TEXT_INDEX_PATH = '/deletefromtextindex';
    public static final String ADD_TO_TEXT_INDEX_PATH = '/addtotextindex';
    public static final String INDEX_STATUS_PATH = '/indexstatus';
    // Text Analysis APIs
    public static final String LANGUAGE_IDENTIFICATION_PATH = '/identifylanguage';
    public static final String SENTIMENT_ANALYSIS_PATH = '/analyzesentiment';
    public static final String ENTITY_EXTRACTION_PATH = '/extractentities';
    public static final String EXPAND_TERMS_PATH = '/expandterms';
    public static final String EXTRACT_CONCEPTS_PATH = '/extractconcepts';
    public static final String HIGHLIGHT_TEXT_PATH = '/highlighttext';
    public static final String TEXT_TOKENIZATION_PATH = '/tokenizetext';

    // Search APIs
    public static final String FIND_SIMILAR_PATH = '/findsimilar';
    public static final String FIND_RELATED_CONCEPTS_PATH = '/findrelatedconcepts';
    public static final String GET_CONTENT_PATH = '/getcontent';
    public static final String GET_PARAMETRIC_VALUES_PATH = '/getparametricvalues';
    public static final String QUERY_TEXT_INDEX_PATH = '/querytextindex';
    public static final String RETRIEVE_INDEX_FIELDS_PATH = '/retrieveindexfields';
    

    private IDOL_API_Config__c apiConfig;
    private HttpClient client;
    
    // language enum map used to convert Language to LanguageCode
    private static Map<String, IDOL.LanguageCode> languageToCodeMap = null;
    private static IDOL_API_Log__c[] apiLogCache = new List<IDOL_API_Log__c>();
    
    
    // constructor
    public IDOLApi() {
        apiConfig = IDOL_API_Config__c.getOrgDefaults();
        client = new HttpClient(apiConfig.API_URL__c);
    }
    
    // constructor with custom setting
    public IDOLApi(IDOL_API_Config__c apiConfig) {
        this.apiConfig = apiConfig;
        client = new HttpClient(apiConfig.API_URL__c);
    }

    /**
     * Build field_text parameter for IDOL search
     *
     * @param op IDOL.FieldTextOperator
     * @param field the field name in the IDOL document
     * @param value the value that operator applies to
     @ return field_text parameter that can be passed to IDOL search request field_text parameter
     */
    public String getFieldText(IDOL.FieldTextOperator op, String field, String value) {
        if(!String.isBlank(value)) {
            return op.name()+'{'+value+'}:'+field;
        } else {
            return op.name()+'{}:'+field;
        }
    }

    /**
     * Build date range field_text parameter for IDOL search
     *
     * @param field the field name in the IDOL document
     * @param startDate the start date
     * @param endDate the end date
     @ return date range field_text parameter that can be passed to IDOL search request field_text parameter
     */
    public String getFieldTextDateRange(String field, Date startDate, Date endDate) {
        return IDOL.FieldTextOperator.RANGE.name()+'{'+startDate.format()+','+endDate.format()+'}:'+field;
    }
    
    /** 
     * List indexes
     *
     * @return IDOL.ListIndexesResponse
     * @throws IDOLException
     */
    public IDOL.ListIndexesResponse listIndexes() {
        String path = SYNC + LIST_INDEXES_PATH;
        IDOL.ListIndexesResponse listIndexResp = (IDOL.ListIndexesResponse) invokeIDOLApi(path, 'GET', null, IDOL.ListIndexesResponse.class);
        return listIndexResp;
    }
    
    /**
     * Create text index
     *
     * @param index the index name to create
     * @param flavor the flavor of index
     * @param description the description of index
     * @return IDOL.CreateTextIndexResponse
     * @throws IDOLException
     */
    public IDOL.CreateTextIndexResponse createTextIndex(String index, IDOL.IndexFlavor flavor, String description) {
        String path = SYNC + CREATE_TEXT_INDEX_PATH;
        Map<String, String> params = new Map<String, String>();
        if(index == null || flavor == null) {
            throw new IDOLException('createTextIndex: index and flavor are required');
        }
        params.put('index', index);
        params.put('flavor', flavor.name());
        //Setting up params with same name and different values

        if(description != null) {
            params.put('description', description);
        }
        IDOL.CreateTextIndexResponse createIndexResp = (IDOL.CreateTextIndexResponse) invokeIDOLApi(path, 'GET', params, IDOL.CreateTextIndexResponse.class);
        return createIndexResp;
    }
    
    /**
     * Add to text index
     *
     * @param index the index name to add text
     * @param source input source type
     * @param  input input text to add to the index
     * @param  duplicate duplicate mode option
     * @return IDOL.AddToTextIndexResponse
     * @throws IDOLException
     */
   public IDOL.AddToTextIndexResponse addToTextIndex(String index, IDOL.InputSource source, IDOL.AddToTextIndexDocumentInput documentInput, IDOL.DuplicateMode duplicate) {
        String path = SYNC + ADD_TO_TEXT_INDEX_PATH;
        Map<String, String> params = new Map<String, String>();
        if(index == null || source == null || documentInput == null) {
            throw new IDOLException('addToTextIndex: index, source and documentInput are required');
        }
        params.put('index', index);
        // JSON.serialize() produces 'null' string for null value, so use JSONGenerator to customize serialzation
        String jsonStr = serializeDocumentInput(documentInput);
        System.debug('input doc json: '+jsonStr);
        params.put(source.name(), jsonStr); // it should be json for text input
        if(duplicate != null) {
            params.put('duplicate_mode', duplicate.name());
        }

        IDOL.AddToTextIndexResponse addToIndexResp = (IDOL.AddToTextIndexResponse) invokeIDOLApi(path, 'GET', params, IDOL.AddToTextIndexResponse.class);
        return addToIndexResp;
    }
    
    /**
     * Perform Add to text index query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.AddToTextIndexResponse addToTextIndex(IDOL.AddToTextIndexRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        if(String.isBlank(request.index)) {
            throw new IDOLException('request.index is required');
        }
        
        String path = SYNC + ADD_TO_TEXT_INDEX_PATH;
        
        if(request.input instanceof IDOL.AddToTextIndexDocumentInput) {
            String jsonStringInput = serializeDocumentInput((IDOL.AddToTextIndexDocumentInput) request.input);
            request.input = jsonStringInput;
        }
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('index', request.index);

        if(request.duplicate_mode != null) {
            params.put('duplicate_mode', request.duplicate_mode.name());
        }
        if(!String.isBlank(request.additional_metadata)) {
            params.put('additional_metadata', request.additional_metadata);
        }
        if(!String.isBlank(request.reference_prefix)) {
            params.put('reference_prefix', request.reference_prefix);
        }
        
        IDOL.AddToTextIndexResponse response = (IDOL.AddToTextIndexResponse) processRequest(path, request, params, IDOL.AddToTextIndexResponse.class);
        return response;
    }
    
    /**
     * Delete text index
     *
     * @param index index name to delete
     * @param confirm the confirm hash returned in the first delete index request
     * @return IDOL.DeleteTextIndexResponse
     * @throws IDOLException
     */
    public IDOL.DeleteTextIndexResponse deleteTextIndex(String index, String confirm) {
        String path = SYNC + DELETE_TEXT_INDEX_PATH;
        Map<String, String> params = new Map<String, String>();
        if(index == null) {
            throw new IDOLException('deleteTextIndex: index is required');
        }
        params.put('index', index);
        if(confirm != null) {
            params.put('confirm', confirm);
        }

        IDOL.DeleteTextIndexResponse deleteIndexResp = (IDOL.DeleteTextIndexResponse) invokeIDOLApi(path, 'GET', params, IDOL.DeleteTextIndexResponse.class);
        return deleteIndexResp;
    }
    
    /**
     * Index status
     *
     * @param index the index name to get status from
     * @return IDOL.IndexStatusResponse
     * @throws IDOLException
     */
    public IDOL.IndexStatusResponse indexStatus(String index) {
        String path = SYNC + INDEX_STATUS_PATH;
        Map<String, String> params = new Map<String, String>();
        if(index == null) {
            throw new IDOLException('indexStatus: index is required');
        }
        params.put('index', index);

        // 24hr_index_updates starts with number, so it can't be used for deserialization. It would better if it starts with non-digit.
        // instead use Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonInput);
        // map returns null if property does not exist.
        String responseBody = (String) invokeIDOLApi(path, 'GET', params, null);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        
        IDOL.IndexStatus indexStatus = new IDOL.IndexStatus();
        Integer total_documents = (Integer) m.get('total_documents');
        indexStatus.total_documents = total_documents != null ? total_documents : 0;
        Integer total_index_size = (Integer) m.get('total_index_size');
        indexStatus.total_index_size = total_index_size != null ? total_index_size : 0;
        Integer hr24_index_updates = (Integer) m.get('24hr_index_updates');
        indexStatus.hr24_index_updates = hr24_index_updates != null ? hr24_index_updates : 0;

        IDOL.IndexStatusResponse indexStatusResp = new IDOL.IndexStatusResponse();
        indexStatusResp.indexstatus = indexStatus;
        return indexStatusResp;
    }
    
    /**
     * The language enum in the SentimentAnalysis request is different than the one returned in the LanguageIdentification response.
     * The method converts the language enum in LanguageIdentification response to three-char language code, so that can be used in 
     *    SentimentAnalysis request. The two APIs should use the same language code!
     *
     * @param language the language enum returned from Language Identification
     * return the corresponding three-char language code
     */
    public IDOL.LanguageCode getLanguageCode(String language) {
        if(languageToCodeMap == null) {    // create conversion map if it hasn't been created yet
            languageToCodeMap = new Map<String, IDOL.LanguageCode>();
            // For now, just handle 6 languages{eng, fre, spa, ger, ita, chi} in the API doc
            languageToCodeMap.put(IDOL.Language.english.name(), IDOL.LanguageCode.eng);
            languageToCodeMap.put(IDOL.Language.french.name(), IDOL.LanguageCode.fre);
            languageToCodeMap.put(IDOL.Language.spanish.name(), IDOL.LanguageCode.spa);
            languageToCodeMap.put(IDOL.Language.german.name(), IDOL.LanguageCode.ger);
            languageToCodeMap.put(IDOL.Language.italian.name(), IDOL.LanguageCode.ita);
            languageToCodeMap.put(IDOL.Language.chinese.name(), IDOL.LanguageCode.chi);
        }
        
        IDOL.LanguageCode code = languageToCodeMap.get(language);
        return code;
    }

    /**
     * Perform Store Object query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.StoreObjectResponse storeObject(IDOL.StoreObjectRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + STORE_OBJECT_PATH;
        
        Map<String,String> params = new Map<String,String>();
        
        IDOL.StoreObjectResponse response = (IDOL.StoreObjectResponse) processRequest(path, request, params, IDOL.StoreObjectResponse.class);
        return response;
    }

    /**
     * Perform Extract Text From Image (OCR Document) query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ExtractTextFromImageResponse extractTextFromImage(IDOL.ExtractTextFromImageRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + OCR_PATH;
        
        Map<String,String> params = new Map<String,String>();
        if(request.mode != null) {
            params.put('mode', request.mode.name());
        }
        
        IDOL.ExtractTextFromImageResponse response = (IDOL.ExtractTextFromImageResponse) processRequest(path, request, params, IDOL.ExtractTextFromImageResponse.class);
        return response;
    }

    /**
     * Perform Text Extraction query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.TextExtractionResponse extractText(IDOL.TextExtractionRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + TEXT_EXTRACTION_PATH;
        
        Map<String,String> params = new Map<String,String>();
        if(request.extract_text != null) {
            params.put('extract_text', String.valueOf(request.extract_text));
        }
        if(request.extract_metadata != null) {
            params.put('extract_metadata', String.valueOf(request.extract_metadata));
        }
        if(request.extract_xmlattributes != null) {
            params.put('extract_xmlattributes', String.valueOf(request.extract_xmlattributes));
        }
        if(!String.isBlank(request.additional_metadata)) {
            params.put('additional_metadata', request.additional_metadata);
        }
        if(!String.isBlank(request.reference_prefix)) {
            params.put('reference_prefix', request.reference_prefix);
        }
        if(!String.isBlank(request.password)) {
            params.put('password', request.password);
        }
        
        IDOL.TextExtractionResponse response = (IDOL.TextExtractionResponse) processRequest(path, request, params, IDOL.TextExtractionResponse.class);
        return response;
    }

    /**
     * Perform View Document query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ViewDocumentResponse viewDocument(IDOL.ViewDocumentRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + VIEW_DOCUMENT_PATH;
        
        Map<String,String> params = new Map<String,String>();
        
        if(!String.isBlank(request.highlight_expression)) {
            params.put('highlight_expression', request.highlight_expression);
        }
        if(!String.isBlank(request.start_tag)) {
            params.put('start_tag', request.start_tag);
        }
        if(!String.isBlank(request.end_tag)) {
            params.put('end_tag', request.end_tag);
        }
        if(request.raw_html != null) {
            params.put('raw_html', String.valueOf(request.raw_html));
        }
        
        IDOL.ViewDocumentResponse response = (IDOL.ViewDocumentResponse) processRequest(path, request, params, IDOL.ViewDocumentResponse.class);
        return response;
    }

    /**
     * Perform Barcode Recognition query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.BarcodeRecognitionResponse recognizeBarcodes(IDOL.BarcodeRecognitionRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + BARCODE_RECOGNITION_PATH;
        
        Map<String,String> params = new Map<String,String>();
        
        if(!String.isBlank(request.barcode_type)) {
            params.put('barcode_type', request.barcode_type);
        }
        if(request.barcode_orientation != null) {
            params.put('barcode_orientation', request.barcode_orientation.name());
        }
        
        IDOL.BarcodeRecognitionResponse response = (IDOL.BarcodeRecognitionResponse) processRequest(path, request, params, IDOL.BarcodeRecognitionResponse.class);
        return response;
    }
    
    /**
     * Perform Image Recognition query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ImageRecognitionResponse recognizeImage(IDOL.ImageRecognitionRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + IMAGE_RECOGNITION_PATH;

        Map<String,String> params = new Map<String,String>();
        
        if(request.index != null) {
            params.put('index', request.index.name());
        }
        if(request.image_type != null) {
            params.put('image_type', request.image_type.name());
        }
        if(!String.isBlank(request.match_image)) {
            params.put('match_image', request.match_image);
        }
        
        IDOL.ImageRecognitionResponse response = (IDOL.ImageRecognitionResponse) processRequest(path, request, params, IDOL.ImageRecognitionResponse.class);
        return response;
    }
    
    /**
     * Perform Expand Terms query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ExpandTermsResponse expandTerms(IDOL.ExpandTermsRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        if(request.expansion == null) {
            throw new IDOLException('request.expansion is required');
        }
        
        String path = SYNC + EXPAND_TERMS_PATH;

        Map<String,String> params = new Map<String,String>();
        
        params.put('expansion', request.expansion.name());
        
        if(request.max_terms != null) {
            params.put('max_terms', String.valueOf(request.max_terms));
        }
        if(request.stemming != null) {
            params.put('stemming', String.valueOf(request.stemming));
        }
        if(request.sort_by != null) {
            params.put('sort', request.sort_by.name());
        }
        
        IDOL.ExpandTermsResponse response = (IDOL.ExpandTermsResponse) processRequest(path, request, params, IDOL.ExpandTermsResponse.class);
        return response;
    }
    
    /**
     * Perform Face Detection query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.FaceDetectionResponse detectFaces(IDOL.FaceDetectionRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + FACE_DETECTION_PATH;

        Map<String, String> params = new Map<String, String>();
        if(request.additional != null) {
            params.put('additional', String.valueOf(request.additional));
        }
        
        IDOL.FaceDetectionResponse response = (IDOL.FaceDetectionResponse) processRequest(path, request, params, IDOL.FaceDetectionResponse.class);
        return response;
    }

    /**
     * Perform Language identification query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.LanguageIdentificationResponse identifyLanguage(IDOL.LanguageIdentificationRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + LANGUAGE_IDENTIFICATION_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(request.additional_metadata != null) {
            params.put('additional_metadata', String.valueOf(request.additional_metadata));
        }
        
        IDOL.LanguageIdentificationResponse response = (IDOL.LanguageIdentificationResponse) processRequest(path, request, params, IDOL.LanguageIdentificationResponse.class);
        return response;
    }
    
    /**
     * Perform Sentiment analysis query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.SentimentAnalysisResponse analyzeSentiment(IDOL.SentimentAnalysisRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + SENTIMENT_ANALYSIS_PATH;
        
        Map<String, String> params = new Map<String, String>();
        
        if(request.language != null) {
            params.put('language', request.language.name());
        }
        
        IDOL.SentimentAnalysisResponse response = (IDOL.SentimentAnalysisResponse) processRequest(path, request, params, IDOL.SentimentAnalysisResponse.class);
        return response;
    }

    /**
     * Perform Entity Extraction query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.EntityExtractionResponse extractEntities(IDOL.EntityExtractionRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }

        if(String.isBlank(request.entity_type)) {
            throw new IDOLException('request.entity_type is required');
        }

        String path = SYNC + ENTITY_EXTRACTION_PATH;
        
        Map<String, String> params = new Map<String, String>();
        params.put('entity_type', request.entity_type);
        
        if(request.show_alternatives != null) {
            params.put('show_alternatives', String.valueOf(request.show_alternatives));
        }
        if(request.unique_entities != null) {
            params.put('unique_entities', String.valueOf(request.unique_entities));
        }
        

        IDOL.EntityExtractionResponse response = (IDOL.EntityExtractionResponse) processRequest(path, request, params, IDOL.EntityExtractionResponse.class);
        return response;
    }
    
    /**
     * Perform Extract Concepts query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ExtractConceptsResponse extractConcepts(IDOL.ExtractConceptstRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }

        String path = SYNC + EXTRACT_CONCEPTS_PATH;
        
        Map<String, String> params = new Map<String, String>();

        IDOL.ExtractConceptsResponse response = (IDOL.ExtractConceptsResponse) processRequest(path, request, params, IDOL.ExtractConceptsResponse.class);
        return response;
    }
    
    /**
     * Perform Highlight Text query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.HighlightTextResponse highlightText(IDOL.HighlightTextRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        if(String.isBlank(request.highlight_expression)) {
            throw new IDOLException('request.highlight_expression is required');
        }

        String path = SYNC + HIGHLIGHT_TEXT_PATH;
        
        Map<String, String> params = new Map<String, String>();

        params.put('highlight_expression', request.highlight_expression);
        
        if(!String.isBlank(request.start_tag)) {
            params.put('start_tag', request.start_tag);
        }
        if(!String.isBlank(request.end_tag)) {
            params.put('end_tag', request.end_tag);
        }
        
        IDOL.HighlightTextResponse response = (IDOL.HighlightTextResponse) processRequest(path, request, params, IDOL.HighlightTextResponse.class);
        return response;
    }
    
    
    /**
     * Perform Text Tokenization query
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.TextTokenizationResponse tokenizeText(IDOL.TextTokenizationRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }

        String path = SYNC + TEXT_TOKENIZATION_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(!String.isBlank(request.stemming)) {
            params.put('stemming', request.stemming);
        }
        if(request.max_terms != null) {
            params.put('max_terms', String.valueOf(request.max_terms));
        }
        
        IDOL.TextTokenizationResponse response = (IDOL.TextTokenizationResponse) processRequest(path, request, params, IDOL.TextTokenizationResponse.class);
        return response;
    }
    
    /**
     * Find similar documents in the index database
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.FindSimilarResponse findSimilar(IDOL.FindSimilarRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }

        String path = SYNC + FIND_SIMILAR_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(!String.isBlank(request.field_text)) {
            params.put('field_text', request.field_text);
        }
        if(request.start != null) {
            params.put('start', String.valueOf(request.start));
        }
        if(request.max_page_results != null) {
            params.put('max_page_results', String.valueOf(request.max_page_results));
        }
        if(request.absolute_max_results != null) {
            params.put('absolute_max_results', String.valueOf(request.absolute_max_results));
        }
        if(!String.isBlank(request.indexes)) {
            params.put('indexes', request.indexes);
        }
        if(!String.isBlank(request.print)) {
            params.put('print', request.print);
        }
        if(!String.isBlank(request.print_fields)) {
            params.put('print_fields', request.print_fields);
        }
        if(!String.isBlank(request.highlight)) {
            params.put('highlight', request.highlight);
        }
        if(!String.isBlank(request.min_date)) {
            params.put('min_date', request.min_date);
        }
        if(!String.isBlank(request.max_date)) {
            params.put('max_date', request.max_date);
        }
        if(request.min_score != null) {
            params.put('min_score', String.valueOf(request.min_score));
        }
        if(!String.isBlank(request.sort_by)) {
            params.put('sort', request.sort_by);
        }
        if(request.total_results != null) {
            params.put('total_results', String.valueOf(request.total_results));
        }
        if(!String.isBlank(request.start_tag)) {
            params.put('start_tag', request.start_tag);
        }
        if(!String.isBlank(request.end_tag)) {
            params.put('end_tag', request.end_tag);
        }
        if(!String.isBlank(request.summary)) {
            params.put('summary', request.summary);
        }
        
        IDOL.FindSimilarResponse response = (IDOL.FindSimilarResponse) processRequest(path, request, params, IDOL.FindSimilarResponse.class);
           return response;
    }

    /**
     * Find related concepts in index database
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.FindRelatedConceptsResponse findRelatedConcepts(IDOL.FindRelatedConceptsRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }

        String path = SYNC + FIND_RELATED_CONCEPTS_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(!String.isBlank(request.field_text)) {
            params.put('field_text', request.field_text);
        }
        if(request.sample_size != null) {
            params.put('sample_size', String.valueOf(request.sample_size));
        }
        if(request.max_results != null) {
            params.put('max_results', String.valueOf(request.max_results));
        }
        if(!String.isBlank(request.index)) {
            params.put('index', request.index);
        }
        if(!String.isBlank(request.min_date)) {
            params.put('min_date', request.min_date);
        }
        if(!String.isBlank(request.max_date)) {
            params.put('max_date', request.max_date);
        }
        if(request.min_score != null) {
            params.put('min_score', String.valueOf(request.min_score));
        }
        
        IDOL.FindRelatedConceptsResponse response = (IDOL.FindRelatedConceptsResponse) processRequest(path, request, params, IDOL.FindRelatedConceptsResponse.class);
        
        IDOL.FindRelatedConceptsEntity[] filteredEntities = IDOLUtil.getFilteredEntities(response.entities); //filter the entities based on exlusive terms
        IDOL.FindRelatedConceptsResponse filteredResponse = new IDOL.FindRelatedConceptsResponse();
        filteredResponse.entities = filteredEntities;
        
        return filteredResponse;
    }
    
    /**
     * Query text index database
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.QueryTextIndexResponse queryTextIndex(IDOL.QueryTextIndexRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + QUERY_TEXT_INDEX_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(!String.isBlank(request.field_text)) {
            params.put('field_text', request.field_text);
        }
        if(request.start != null) {
            params.put('start', String.valueOf(request.start));
        }
        if(request.max_page_results != null) {
            params.put('max_page_results', String.valueOf(request.max_page_results));
        }
        if(request.absolute_max_results != null) {
            params.put('absolute_max_results', String.valueOf(request.absolute_max_results));
        }
        if(!String.isBlank(request.indexes)) {
            params.put('indexes', request.indexes);
        }
        if(!String.isBlank(request.print)) {
            params.put('print', request.print);
        }
        if(!String.isBlank(request.print_fields)) {
            params.put('print_fields', request.print_fields);
        }
        if(!String.isBlank(request.highlight)) {
            params.put('highlight', request.highlight);
        }
        if(!String.isBlank(request.min_date)) {
            params.put('min_date', request.min_date);
        }
        if(!String.isBlank(request.max_date)) {
            params.put('max_date', request.max_date);
        }
        if(request.min_score != null) {
            params.put('min_score', String.valueOf(request.min_score));
        }
        if(!String.isBlank(request.sort_by)) {
            params.put('sort', request.sort_by);
        }
        if(request.total_results != null) {
            params.put('total_results', String.valueOf(request.total_results));
        }
        if(!String.isBlank(request.start_tag)) {
            params.put('start_tag', request.start_tag);
        }
        if(!String.isBlank(request.end_tag)) {
            params.put('end_tag', request.end_tag);
        }
        if(!String.isBlank(request.summary)) {
            params.put('summary', request.summary);
        }
        
        IDOL.QueryTextIndexResponse response = (IDOL.QueryTextIndexResponse) processRequest(path, request, params, IDOL.QueryTextIndexResponse.class);
           return response;
    }

    /**
     * Expand container 
     *
     * @param request the request
     * @return the response
     * @throws IDOLException if request is null, or if some properties are not set
     */
    public IDOL.ExpandContainerResponse expandContainer(IDOL.ExpandContainerRequest request) {
        if(request == null) {
            throw new IDOLException('request is required');
        }
        
        String path = SYNC + EXPAND_CONTAINER_PATH;
        
        Map<String, String> params = new Map<String, String>();
        if(!String.isBlank(request.password)) {
            params.put('password', request.password);
        }
        if(request.depth != null) {
            params.put('depth', String.valueOf(request.depth));
        }
        
        IDOL.ExpandContainerResponse response = (IDOL.ExpandContainerResponse) processRequest(path, request, params, IDOL.ExpandContainerResponse.class);
           return response;
    }
    
    /**
     *  Process the generic request. 
     *
     * @param path the IDOL OnDemand path
     * @param request the request
     * @param params the list of parameters
     * @param returnType the return type
     * @return the response object of returnType type
     * @throws IDOLException if source and input are null, or if the input is not proper for the source
     */
    private Object processRequest(String path, IDOL.Request request, Map<String,String> params, Type returnType){
        if(request.source == null || request.input == null) {
            throw new IDOLException('source and input are required');
        }
        if(request.source == IDOL.InputSource.file) {
            if(!(request.input instanceof Attachment)) {
                throw new IDOLException('for file source, the input should be an Attachment');
            }
        } else {
            if(!(request.input instanceof String)) {
                throw new IDOLException('for file source, the input should be a String');
            }
        }
        
        Object response = null;
        
        if(request.source == IDOL.InputSource.file || request.source == IDOL.InputSource.text || request.source == IDOL.InputSource.json) {
            // build multipart list object
            List<HttpClient.Multipart> parts = new List<HttpClient.Multipart>();
            parts.add(new HttpClient.Multipart(IDOL_APIKEY, this.apiConfig.API_Key__c));
            if(request.source == IDOL.InputSource.file) {
                Attachment att = (Attachment) request.input;
                parts.add(new HttpClient.Multipart(att.Name, att.Body, att.ContentType));            
            } else {
                parts.add(new HttpClient.Multipart(request.source.name(), String.valueOf(request.input)));
            }
            
            for (String fieldName : params.keySet()){
                parts.add(new HttpClient.Multipart(fieldName, params.get(fieldName)));
            }
            
            response = (Object) invokeIDOLApi(path, 'POST', null, returnType, parts);
        } else {
            params.put(IDOL_APIKEY, this.apiConfig.API_Key__c);
            params.put(request.source.name(), String.valueOf(request.input));
            response = (Object) invokeIDOLApi(path, 'GET', params, returnType);
        }
        
        return response;
    }
    
    /**
     * Send IDOL request to IDOL API server
     *
     * @return the deserialized IDOL response or Object if deserialization is not possible.
     * @throws IDOLException
     */
    private Object invokeIDOLApi(String path, String method, Map<String, String> params, Type returnType) {
        return invokeIDOLApi(path, method, params, returnType, null);
    }

    /**
     * Send IDOL request to IDOL API server (with body)
     *
     * @return the deserialized IDOL response or Object if deserialization is not possible.
     * @throws IDOLException
     */
    private Object invokeIDOLApi(String path, String method, Map<String, String> params, Type returnType, List<HttpClient.Multipart> parts) {

        // add api version, the path is sync/async+action
        path = path + '/' + apiConfig.API_Version__c;
        if(params == null) {
            params = new Map<String, String>();
        }
        // send request to IDOL API server
        HttpResponse response = null;
        if(parts != null) {
            response = client.sendRequest(path, method, params, parts);
        } else {
            // add apikey
            params.put(IDOL_APIKEY, this.apiConfig.API_Key__c);
            
            response = client.sendRequest(path, method, params);
        }
        
        // 300 is arbitary number to prevent cache growing
        if(!Test.isRunningTest() && apiConfig.API_Logging__c && apiLogCache.size() < 300) {
            String name = method+' '+path;
            String reqLog = JSON.serializePretty(params);
            String respLog = response.getStatusCode()+': '+response.getBody();
            // trim log text to 30k chars
            reqLog = reqLog.left(30000);
            respLog = respLog.left(30000);
            // instantiate
            IDOL_API_Log__c log = new IDOL_API_Log__c(Name=name, Request__c=reqLog, Response__c=respLog);
            apiLogCache.add(log);
        }

        // handle error and rate limit
        if(response.getStatusCode() == 200) {  // no error
            if(returnType != null) {
                String body = response.getBody();
                if(path.contains(IMAGE_RECOGNITION_PATH)) {
                    // replace property name (avoid reserved keyword error) 
                    body = body.replace('"object":', '"image_object":');
                }
                if(path.contains(GET_PARAMETRIC_VALUES_PATH)) {
                    // replace property name as salesforce cannot have dynamic field names
                    for (HTTPClient.Multipart part : parts) {
                        if(part.getName().equals('field_name')) {
                            body = body.replace('"' + part.getContents() + '":', '"field_name":');
                        }
                    }
                }
                if(path.contains(VIEW_DOCUMENT_PATH)) {
                    IDOL.ViewDocumentResponse viewDocumentResponse = new IDOL.ViewDocumentResponse();
                    viewDocumentResponse.document = body;
                    return viewDocumentResponse;
                } else {
                    System.debug('deserializing...');
                    System.debug(body);
                    Object returnObject = JSON.deserialize(body, returnType);
                    return returnObject;
                }
            }
            // if response can't be deserialized, just return body string
            return response.getBody();
        } else {
            System.debug('IDOL API Error: '+response.getBody());
            // Unfortunately IDOL error responses have many different variations, can't use deerailize method. Use JSON.deserializeUntyped() instead.
            // It would be better API returns an uniform error response with well-defined schema.
            // IDOL.ErrorResponse errorResponse = (IDOL.ErrorResponse)JSON.deserialize(response.getBody(), IDOL.ErrorResponse.class);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            IDOL.ErrorResponse errorResponse = new IDOL.ErrorResponse();
            if(m.containsKey('error')) {       // it should contain this
                errorResponse.error = (Integer) m.get('error');
            }
            if(m.containsKey('reason')) {      // it should contain this
                errorResponse.reason = (String) m.get('reason');
            }
            if(errorResponse.error == 503) {   // rate limit, wait 360 sec
                // no good way to sleep or retry in APEX.
                // business logic layer needs to call again with future or scheduler
            }
            //persistApiLogCache();
            throw new IDOLException(errorResponse.error+':'+errorResponse.reason + '\n' + response.getBody());
        }
        return null;
    }
    
    /**
     * Persist API Logs in the cache to the Dataase.
     */
    public void persistApiLogCache() {
        if(apiConfig.API_Logging__c && apiLogCache.size() > 0) {
            try {
                insert apiLogCache;
            } catch(DmlException e) {
                System.debug('Inserting IDOL API log failsed with '+e.getMessage());
                // ignore this exception
            }
            apiLogCache.clear();
        }
    }
    
    /**
     * Serialize IDOL.DocumentInput object to JSON string. To prevent null value becoming 'null' string in the JSON
     *   string, needs to use custom serialization with JSONGenerator.
     *
     * @param documentInput DocumentInput to be added to the index.
     * @return JSON string of DocumentInput object.
     */
    private String serializeDocumentInput(IDOL.AddToTextIndexDocumentInput documentInput) {
        // always there in only one Document
        IDOL.AddToTextIndexDocument doc = documentInput.documents.get(0);

        // So use JSONGenerator to create JSON string for custom fields in DocumentInput
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeFieldName('documents');
        gen.writeStartArray();
            gen.writeStartObject();         // document object
            // write title, reference, content
            gen.writeStringField('title', doc.title);
            gen.writeStringField('reference', doc.reference);
            gen.writeStringField('content', doc.content);
            gen.writeEndObject();   // document object  
        gen.writeEndArray();    // documents array
        gen.writeEndObject();
        
        String jsonStr = gen.getAsString();
        
        return jsonStr;
    }
}