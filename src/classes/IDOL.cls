/**
 * Define IDOL model classes.
 */
 
public class IDOL {
    // API defines two parameters(text,json) for text type input, but it can be one.
    public enum InputSource {text, json, file, reference, index_reference, url}
    public enum DuplicateMode {replace, duplicate}
    
    // define IDOL Error response
    public class ErrorResponse {
        public Integer error;       // error code
        public String reason;       // error reason
        //public Detail[] detail;
        public String jobID;        // job ID
        public String status;       // job status
        //public Action actions;        // failed action list
    }
    
    // index type enumeration
    public enum IndexType {content, connector}
    
    // index flavor enumeration
    public enum IndexFlavor {standard, explorer, categorization, custom_fields, web_cloud}
    
    // define IDOL Index
    public class Index {
        public String index;
        public String type;
        public String flavor;
        public String description;
        public String date_created;
        public Integer num_components;
    }
    
    // define IDOL public index
    public class PublicIndex {
        public String index;
        public String type;
    }
    
    // define list indexes response
    public class ListIndexesResponse {
        public Index[] index;               // custom indexes
        public IDOL.PublicIndex[] public_index; // default indexes
    }
    
    // define create text index response
    public class CreateTextIndexResponse {
        public String message;  // optional
        public String index;    // optional
    }
    
    // define delte text index response 
    public class DeleteTextIndexResponse {
        public Boolean deleted;
        public String index;    // optional
        public String confirm;  // optional
    }

    // define delete from text index response
    public class DeleteFromTextIndexResponse {
        public String index;
        public Integer documents_deleted;
    }
    
    // define index status response
    public class IndexStatusResponse {
        public IDOL.IndexStatus indexstatus;
    }
    
    // define index status
    // 24hr_index_updates starts with number, so it can't be used for deserialization. It would better if it starts with non-digit.
    // instead use Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsonInput);
    public class IndexStatus {
        public Integer total_documents;
        public Integer total_index_size;
        public Integer hr24_index_updates;  // original property name is 24hr_index_updates
    }
    
    // define get content response
    public class GetContentResponseDocument {
         public String reference;  
         public Double section;  
         public String index;  
         public String title;
    }

    public class GetContentResponse {
        public GetContentResponseDocument[] documents;        
    }

    // define get parametric values response
    public class GetParametricValuesResponse {
        public Map<String, Integer> field_name;
    }

    // define retrieve index response
    public class RetrieveIndexFieldsResponseFieldTypeCounts {  
         public Integer index_count;  
         public Integer reference_count;  
         public Integer date_count;  
         public Integer numeric_count;  
         public Integer parametric_count;  
         public Integer stored_count_count;  
         public Integer autnrank_count;  
    }

    public class RetrieveIndexFieldsResponse {
         public String index_name;  
         public String[] all_fields;  
         public IDOL.RetrieveIndexFieldsResponseFieldTypeCounts field_type_counts;  
         public Integer total_fields;  
         public String[] index_type_fields;  
         public String[] parametric_type_fields;  
         public String[] numeric_type_fields;  
         public String[] autnrank_type_fields;  
         public String[] reference_type_fields;  
         public String[] date_type_fields;  
         public String[] stored_type_fields; 
    }

    // define print options that's used in query request
    public enum Print {all, all_sections, fields, none, no_results, reference}  // unfortunately date, parametric are reserved
    // define highlight options that's used in query request
    public enum Highlight {off, sentences, summary_sentences, summary_terms}
    
    // define enum of FieldText operators
    public enum FieldTextOperator {MATCH, EXISTS, EMPTY, EQUAL, GREATER, LESS, NRANGE, NOTEQUAL, GTNOW, LTNOW, RANGE, BIAS, BIASDATE, BIASDISTCARTESIAN, BIASDISTPHERICAL}
    
    
    /************** Request / Response classes *********************/
    // Generic Request class.
    public virtual class Request{
        public InputSource source;
        public Object input;
    }
    
    // ----------------------------------------------------------
    // Add to Text Index classes
    // ----------------------------------------------------------
    public class AddToTextIndexDocument {
        public String title;        
        public String reference;    
        public String content;      
        
    }
    
    public class AddToTextIndexDocumentInput {
        public IDOL.AddToTextIndexDocument[] documents;
    }

    public class AddToTextIndexRequest extends Request {
        public String index;
        public DuplicateMode duplicate_mode;
        public String additional_metadata;
        public String reference_prefix;
    }

    public class AddToTextIndexResponseReference {
        public Integer id;
        public String reference;
    }

    public class AddToTextIndexResponse {
        public String index;
        public IDOL.AddToTextIndexResponseReference[] references;
    }

    // ----------------------------------------------------------
    // Extract Text From Image classes
    // ----------------------------------------------------------
    public enum ExtractTextFromImageMode { document_photo, document_scan, scene_photo, subtitle }
    
    public class ExtractTextFromImageRequest extends Request {
        public ExtractTextFromImageMode mode;
    }

    public class TextBlock{ 
        public String text;
        public Integer left;
        public Integer top;
        public Integer width;
        public Integer height;
    }
    
    public class ExtractTextFromImageResponse{
        public TextBlock[] text_block;
    }

    // ----------------------------------------------------------
    // Store Object classes
    // ----------------------------------------------------------
    public class StoreObjectRequest extends Request {
    }

    public class StoreObjectResponse {
        public String reference;
    }

    // ----------------------------------------------------------
    // Text Extraction classes
    // ----------------------------------------------------------
    public class TextExtractionRequest extends Request{
        public Boolean extract_text;
        public Boolean extract_metadata;
        public Boolean extract_xmlattributes;
        public String additional_metadata;
        public String reference_prefix;
        public String password;
    }
    
    public class TextExtractionDocument {
        public String reference;
        public String doc_iod_reference;
        public String[] app_name;
        public String[] author;
        public String content;
    }
    
    public class TextExtractionResponse {
        public TextExtractionDocument[] document;
    }

    // ----------------------------------------------------------
    // View Document classes
    // ----------------------------------------------------------
    public class ViewDocumentRequest extends Request {
        public String highlight_expression;
        public String start_tag;
        public String end_tag;
        public Boolean raw_html;
    }

    public class ViewDocumentResponse {
        public String document;
    }
    
    // ----------------------------------------------------------
    // Barcode Recognition classes
    // ----------------------------------------------------------
    public enum BarcodeOrientation { upright, anyway }
    
    public class BarcodeRecognitionRequest extends Request {
        public String barcode_type;
        public BarcodeOrientation barcode_orientation;
    }

    public class BarcodeAdditionalInformation {
        public String country;
    }

    public class Barcode {
        public String text;  
        public String barcode_type;  
        public Integer left;  
        public Integer top;  
        public Integer width;  
        public Integer height;
        public BarcodeAdditionalInformation additional_information;
    }

    public class BarcodeRecognitionResponse {
        public IDOL.Barcode[] barcode;
    }

    // ----------------------------------------------------------
    // Image Recognition classes
    // ----------------------------------------------------------
    public enum ImageRecognitionIndex { corporatelogos }
    public enum ImageRecognitionImageType { simple, complex2d, complex3d }
    
    public class ImageRecognitionRequest extends Request {
        public ImageRecognitionIndex index;
        public ImageRecognitionImageType image_type;
        public String match_image;
    }

    public class ImageCorner {
        public Integer x;
        public Integer y;
    }

    public class ImageObject {
        public String unique_name;
        public String name;
        public String db;
        public IDOL.ImageCorner[] corners;
    }

    public class ImageRecognitionResponse {
        public IDOL.ImageObject[] image_object; // json property renamed from "object" to "image_object" in IDOLApi
    }

    // ----------------------------------------------------------
    // Expand Terms classes
    // ----------------------------------------------------------
    public enum ExpandTermsExpansionType {fuzzy, stem, wild}
    public enum ExpandTermsSort {none, alphabetical, documents}
    
    public class ExpandTermsRequest extends Request {
        public ExpandTermsExpansionType expansion;
        public Integer max_terms;
        public Boolean stemming;
        public ExpandTermsSort sort_by;
    }

    public class ExpandTermsResponseTerm {  
         public String term;  
         public Integer documents;  
    } 

    public class ExpandTermsResponse {
        public IDOL.ExpandTermsResponseTerm[] terms;
    }

    // ----------------------------------------------------------
    // Face Detection classes
    // ----------------------------------------------------------
    public class FaceDetectionRequest extends Request {
        public String additional;
    }

    public class FaceDetectionFaceAdditionalInformation {
        public String age;
    }

    public class FaceDetectionFace {
        public Integer left;  
         public Integer top;  
         public Integer width;  
         public Integer height;
         public FaceDetectionFaceAdditionalInformation additional_information;
    }

    public class FaceDetectionResponse {
        public IDOL.FaceDetectionFace[] face;
    }

    // ----------------------------------------------------------
    // Language Identification classes
    // ----------------------------------------------------------
    public class LanguageIdentificationRequest extends Request {
        public Boolean additional_metadata;
    }

    // Language list in LanguageIdentificationResponse
    public enum Language {afrikaans, albanian, amharic, arabic, armenian, azeri, basque, belarussian, bengali, berber, breton, bulgarian, burmese, catalan, cherokee, chinese, croatian, czech, danish, dutch, english, esperanto, estonian, faroese, finnish, french, gaelic, georgian, german, greek, greenlandic, gujarati, hebrew, hindi, hungarian, icelandic, indonesian, italian, japanese, kannada, kazakh, khmer, korean, kurdish, lao, latin, latvian, lithuanian, luxembourgish, macedonian, malayalam, maltese, maori, mongolian, nepali, norwegian, oriya, persian, polish, portuguese, pushto, romanian, russian, serbian, sindhi, singhalese, slovak, slovenian, somali, spanish, swahili, swedish, syriac, tagalog, tajik, tamil, telugu, thai, tibetan, turkish, ukrainian, urdu, uyghur, uzbek, vietnamese, welsh, unknown }
    public enum LanguageIso639_2b {AFR, ALB, AMH, ARA, ARM, AZE, BAQ, BEL, BEN, BER, BRE, BUL, BUR, CAT, CHR, CHI, HRV, CZE, DAN, DUT, ENG, EPO, EST, FAO, FIN, FRE, GLE, GEO, GER, GRE, KAL, GUJ, HEB, HIN, HUN, ICE, IND, ITA, JPN, KAN, KAZ, KHM, KOR, KUR, LAO, LAT, LAV, LIT, LTZ, MAC, MAL, MLT, MAO, MON, NEP, NPI, NOR, ORI, PER, POL, POR, PUS, RUM, RUS, SRP, SND, SIN, SLO, SLV, SOM, SPA, SWA, SWE, SYR, TGL, TGK, TAM, TEL, THA, TIB, TUR, UKR, URD, UIG, UZB, VIE, WEL, UND}
    // Encoding list in LanguageIdentificationResponse
    public enum Encoding {ARABIC, ARABIC_ISO, ASCII, CHINESESIMPLIFIED, CHINESETRADITIONAL, CYRILLIC, CYRILLIC_ISO, CYRILLIC_KOI8, EASTERNEUROPEAN, EASTERNEUROPEAN_ISO, EUC, GREEK, GREEK_ISO, HEBREW, HEBREW_ISO, JIS, KOREAN, NORTHERNEUROPEAN, NORTHERNEUROPEAN_ISO, SHIFTJIS, THAI, TURKISH, UTF8, VIETNAMESE}

    public class LanguageIdentificationResponse {
        // JSON deserialization doesn't work with enum type, so need to use String
        public String language;
        public String language_iso639_2b;
        public String encoding;
        public String[] unicode_scripts;
    }

    // ----------------------------------------------------------
    // Sentiment Analysis classes
    // ----------------------------------------------------------
    public enum LanguageCode {eng, fre, spa, ger, ita, chi}

    public class SentimentAnalysisRequest extends Request{
        public LanguageCode language;
    }

    public class SentimentAnalysisResponseEntity {
        public String sentiment;
        public String topic;
        public Double score;
        public String original_text;
        public String normalized_text;
        public Integer original_length;
        public Integer normalized_length;
    }
    
    // Sentiment in SentimentAnalysisResponse.aggregate
    public enum Sentiment {positive, negative, neutral}

    public class SentimentAnalysisResponseAggregate {
        public String sentiment;
        public Double score;
    }

    public class SentimentAnalysisResponse {
        public IDOL.SentimentAnalysisResponseEntity[] positive;
        public IDOL.SentimentAnalysisResponseEntity[] negative;
        public IDOL.SentimentAnalysisResponseAggregate aggregate;
    }
    
    // ----------------------------------------------------------
    // Entity Extraction classes
    // ----------------------------------------------------------
    public class EntityExtractionRequest extends Request {
        public String entity_type;
        public Boolean show_alternatives;
        public Boolean unique_entities;
    }

    public class EntityExtractionResponseAdditionalInformation {
        public String[] person_profession;
         public String person_date_of_birth;
         public String person_date_of_death;
         public String wikipedia_eng;  
         public Double lon;  
         public Double lat;  
         public Integer place_population;  
         public String place_country_code;  
         public String place_region1;  
         public String place_region2;  
         public Integer place_elevation; 
    }

    public class EntityExtractionResponseComponent {
        public Integer original_length;  
         public String original_text;  
         public String type; 
    }

    public class EntityExtractionResponseEntity {
        public String normalized_text;
         public String original_text;
         public String type;
         public Integer normalized_length;
         public Integer original_length;
         public Double score;
         public String normalized_date;
         public IDOL.EntityExtractionResponseAdditionalInformation additional_information;
         public IDOL.EntityExtractionResponseComponent[] components;
    }

    public class EntityExtractionResponse {
        public IDOL.EntityExtractionResponseEntity[] entities;
    }

    // ----------------------------------------------------------
    // Concept Extraction classes
    // ----------------------------------------------------------
    public class ExtractConceptstRequest extends Request {
    }
    
    public class ExtractConceptsResponseConcept {  
         public String concept;
         public Integer occurrences;  
    }  

    public class ExtractConceptsResponse {
        public IDOL.ExtractConceptsResponseConcept[] concepts;
    }
    
    // ----------------------------------------------------------
    // Highlight Text classes
    // ----------------------------------------------------------
    public class HighlightTextRequest extends Request {
        public String highlight_expression;
           public String start_tag;
           public String end_tag;
    }
    
    public class HighlightTextResponse {
        public String text;
    }
    
    // ----------------------------------------------------------
    // Text Tokenization classes
    // ----------------------------------------------------------
    public class TextTokenizationRequest extends Request {
        public String stemming;
        public Integer max_terms;
    }
    
    public class TextTokenizationResponseTerm {
         public String term;  
         public Integer weight;  
         public Integer documents;  
         public Integer occurrences;  
         public String stop_word;  
         public String caseValue;
         public Integer length;  
         public Integer start_pos;  
    }

    public class TextTokenizationResponse {  
         public IDOL.TextTokenizationResponseTerm[] terms;  
    }

    // ----------------------------------------------------------
    // Find Similar classes
    // ----------------------------------------------------------
    public class FindSimilarRequest extends Request {
        public String field_text;
        public Integer start;
        public Integer max_page_results;
        public Integer absolute_max_results;
        public String indexes;
        public String print;
        public String print_fields;
        public String highlight;
        public String min_date;
        public String max_date;
        public Decimal min_score;
        public String sort_by;
        public Boolean total_results;
        public String start_tag;
        public String end_tag;
        public String summary;
    }
    
    public class FindSimilarResponseDocument {
         public String reference;  
         public Double weight;  
         public String[] links;  
         public String index;
         public String title;
         public String summary; 
    }

    public class FindSimilarResponse {
        public IDOL.FindSimilarResponseDocument[] documents;
    }
    
    // ----------------------------------------------------------
    // Find Related Concepts classes
    // ----------------------------------------------------------
    public class FindRelatedConceptsRequest extends Request {
        public String field_text;
        public Integer sample_size;
        public Integer max_results;
        public String index;
        public String min_date;
        public String max_date;
        public Decimal min_score;
    }
    
    public class FindRelatedConceptsEntity {
        public String text;
        public Integer docs_with_phrase;
        public Integer occurrences;
        public Integer docs_with_all_terms;
        public Integer cluster;
    }
    
    public class FindRelatedConceptsResponse {
        public IDOL.FindRelatedConceptsEntity[] entities;
    }
    
    // ----------------------------------------------------------
    // Query Text Index classes
    // ----------------------------------------------------------
    public class QueryTextIndexRequest extends Request {
        public String field_text;
        public Integer start;
        public Integer max_page_results;
        public Integer absolute_max_results;
        public String indexes;
        public String print;
        public String print_fields;
        public String highlight;
        public String min_date;
        public String max_date;
        public Decimal min_score;
        public String sort_by;
        public Boolean total_results;
        public String start_tag;
        public String end_tag;
        public String summary;
    }
    
    public class QueryTextIndexResponseDocument {
         public String reference;  
         public Double weight;  
         public String[] links;  
         public String index;
         public String title;
         public String summary; 
    }

    public class QueryTextIndexResponse {
        public IDOL.QueryTextIndexResponseDocument[] documents;
    }
    
    // ----------------------------------------------------------
    // Expand Container classes
    // ----------------------------------------------------------
    public class ExpandContainerRequest extends Request {
        public String password;
        public String depth;
    }
    
    public class ExpandContainerResponseFile {
        public String name;
        public String reference;
        public Integer size;
    }
    
    public class ExpandContainerResponse {
        public IDOL.ExpandContainerResponseFile[] files;
    }

}