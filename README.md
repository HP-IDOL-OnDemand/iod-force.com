**Note:** this repo is outdated. Please see [this repo](https://github.com/HPE-Haven-OnDemand/havenondemand-salesforce).

# Installation

### Build.properties

Contains the credentials for the code deployment.

```
developer.username = your username
developer.password = your password
developer.serverurl = https://login.salesforce.com
```

You may need to add your securitytoken to the password field if not deploying from a trusted network.

```
developer.password = <password><securitytoken>
```

### Requirements

* ant
* Force.com migration tool
* an [IDOLOnDemand.com](http://idolondemand.com) API Key

### Deployment

```
ant deployCode
```

# Configuration

Setup -> Develop -> Custom Settings

Click **Manage** for IDOL API Config, add a New record, leave all fields as-is but add your IDOL OnDemand APIKey to the apikey field.

If you don't have one get an apikey at [IDOLOnDemand.com](http://idolondemand.com)

# Usage

Initialize the api call.
```
IDOLApi api = new IDOLApi();
```

Prepare the request.
```
IDOL.SentimentAnalysisRequest req = new IDOL.SentimentAnalysisRequest();
```

Specify the type of input, in this case , text

```
req.source = IDOL.InputSource.text;
```

Pass further parameters to the request.
```
req.input = 'I am really annoyed with your poor performance recently';
req.language = IDOL.LanguageCode.eng;
```

Start the call and parse

```
IDOL.SentimentAnalysisResponse resp = api.analyzeSentiment(req);
System.debug(logginglevel.INFO, 'resp.aggregate.sentiment -->  ' + resp.aggregate.sentiment);
System.debug(logginglevel.INFO, 'resp.aggregate.score -->  ' + resp.aggregate.score);
System.debug(logginglevel.INFO, 'resp.positive.size() -->  ' + resp.positive.size());
```

### Diferent inputs

**Files**

Existing Attachment example

```
Attachment att = [select id, name, body, contentType from attachment where id = 'id'];
req.source = IDOL.InputSource.file;
req.input = att;
```

Manual File post

```
req.source = IDOL.InputSource.file;
Attachment att = new Attachment();
att.Name = 'dog.txt';
att.Body = Blob.valueOf('filecontent');
req.input = att;
```


**Urls**

```
req.source = IDOL.InputSource.url;
req.input = 'https://www.idolondemand.com/sample-content/images/aviva.jpg';
```

**json**

For example when adding documents

```
IDOLApi api = new IDOLApi();
IDOL.AddToTextIndexRequest req = new IDOL.AddToTextIndexRequest();
req.source = IDOL.InputSource.json;
req.input =
    '{' +
    '   "document" :' +
    '   [' +
    '      {' +
    '         "title" : "This is my document",' +
    '         "reference" : "mydoc11",' +
    '         "myfield" : ["a value"],' +
    '         "content" : "A large block of text, which makes up the main body of the document."' +
    '      }, {' +
    '         "title" : "My Other document",' +
    '         "reference" : "mydoc12",' +
    '         "content" : "This document is about something else"' +
    '      }' +
    '   ]' +
    '}';
req.index = 'explore1';
IDOL.AddToTextIndexResponse resp = api.addToTextIndex(req);
```

### Other Examples

**Adding Documents to an index**

```
req.source = IDOL.InputSource.json;
IDOL.AddToTextIndexDocument document = new IDOL.AddToTextIndexDocument();
document.title = 'This is my document';
document.reference = 'mydoc11';
document.content = 'This document is about something special';
IDOL.AddToTextIndexDocument[] documents = new IDOL.AddToTextIndexDocument[] {document};
IDOL.AddToTextIndexDocumentInput documentInput = new IDOL.AddToTextIndexDocumentInput();
documentInput.documents = documents;
req.input = documentInput;
IDOL.AddToTextIndexResponse resp = api.addToTextIndex(req);

```

### Supported Requests

* AddToTextIndexRequest
* ExtractTextFromImageRequest
* StoreObjectRequest
* TextExtractionRequest
* ViewDocumentRequest
* BarcodeRecognitionRequest
* ImageRecognitionRequest
* ExpandTermsRequest
* FaceDetectionRequest
* LanguageIdentificationRequest
* SentimentAnalysisRequest
* EntityExtractionRequest
* ExtractConceptstRequest
* HighlightTextRequest
* TextTokenizationRequest
* FindSimilarRequest
* FindRelatedConceptsRequest
* QueryTextIndexRequest
* ExpandContainerRequest
