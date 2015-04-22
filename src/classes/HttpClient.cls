/**
 * generic HTTP client to send HTTP request to the endpoint
 *  and receive HTTP response from the endpoint
 *
 */
public class HttpClient {
    
    private String endpoint;
    
    public String multipartBoundary {
        get {
            return 'WebKitFormBoundaryrwhfLBSlAAJ9BKQU';
        }
    }
    public List<Param> paramList  = new List<Param>(); //This will support multiple parameters where name is same

    // constructor
    public HttpClient(String endpoint) {
        this.endpoint = endpoint;
    }

    /**
     * Sends a HTTP Request with querystring parameters to the endpoint.
     * 
     * @param path the endpoint URL
     * @param method the HTTP method to use, defaults to GET
     * @param vars for POST or PUT, a map of data to send, for GET will be
     *            appended to the URL as querystring params
     * @return the HTTP response
     */
    public HttpResponse sendRequest(String path, String method, Map<String, String> vars) {
            HttpRequest request = setupRequest(path, method, null, vars);

            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(1000*60); //60 seconds ~using half of the maximum timout
            return send(request);
    }
        
    /**
     * Sends a HTTP Request with body content to the endpoint.
     * 
     * @param path the endpoint URL
     * @param method the HTTP method to use, defaults to GET
     * @param vars for POST or PUT, a map of data to send, for GET will be
     *            appended to the URL as querystring params
     * @param body the request body content for POST or PUT method.
     * @return the HTTP rest response
     */
    public HttpResponse sendRequest(String path, String method, Map<String, String> vars, List<Multipart> parts) {

        // build multipart body
        String body = buildMultipartBody(parts);
        System.debug('sendRequest body: '  + body);

        // build request
        HttpRequest request = setupRequest(path, method, body, vars);
        request.setTimeout(1000*60); //60 seconds ~using half of the maximum timout
        return send(request);
    }

    /**
     * Sends a HTTP Request with body content to the endpoint.
     * 
     * @param path the endpoint URL
     * @param method the HTTP method to use, defaults to GET
     * @param vars for POST or PUT, a map of data to send, for GET will be
     *            appended to the URL as querystring params
     * @param body the request body content for POST or PUT method.
     * @return the HTTP rest response
     */
    public HttpResponse sendRequest(String path, String method, Map<String, String> vars, String body) {
            HttpRequest request = setupRequest(path, method, body, vars);
            request.setTimeout(1000*60); //60 seconds ~using half of the maximum timout
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            return send(request);
    }
        
    /**
     * sendRequst Sends a HTTP Request with body content to the endpoint.
     * 
     * @param path the endpoint URL
     * @param method the HTTP method to use, defaults to GET
     * @param body the request body content for POST or PUT method.
     * @param token the access token to access API service
     * @return the HTTP rest response
     */
    public HttpResponse sendRequestWithToken(String path, String method, String body, String token) {
            HttpRequest request = setupRequest(path, method, body, null);
            if (token != null) {
                request.setHeader('Authorization','Bearer ' + token);
                request.setHeader('Accept', 'application/json');
                request.setHeader('Content-Type', 'application/json');
            }
            return send(request);
    }
    
    /**
     * sendRequst Sends a HTTP Request with querystring parameters to the endpoint.
     * 
     * @param path the endpoint URL
     * @param method the HTTP method to use, defaults to GET
     * @param vars for POST or PUT, a map of data to send, for GET will be
     *            appended to the URL as querystring params
     * @param token the access token to access API service
     * @return the HTTP response
     */
    public HttpResponse sendRequestWithToken(String path, String method, Map<String, String> vars, String token) {
            HttpRequest request = setupRequest(path, method, null, vars);
            if (token != null) {
                request.setHeader('Authorization','Bearer ' + token);
                request.setHeader('Accept', 'application/json');
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            }
            return send(request);
    }

    /**
     * Sends a HTTP Request to the endpoint.
     * 
     * @param request the HttpRequest to send
     * @return the HTTP response
     */
    private HttpResponse send(HttpRequest request) {

        // execute HTTP request
        HttpResponse response = (new Http()).send(request);
        String responseBody = (response.getBody()==null) ? '' : response.getBody();
        //System.debug(responseBody+'------------------'+response);
        return response;
    }
    
    /**
     * Builds the method.
     * 
     * @param method the method
     * @param path the path
     * @param body the request body content
     * @param params the params
     * @return the http uri request
     */
    private HttpRequest buildMethod(String method, String path, String body,
            Map<String,String> params) {
        if (method.equalsIgnoreCase('GET')) {
            return generateGetRequest(path, params);
        } else if (method.equalsIgnoreCase('POST')) {
            return generatePostRequest(path, body, params);
        } else if (method.equalsIgnoreCase('PUT')) {
            return generatePutRequest(path, body, params);
        } else if (method.equalsIgnoreCase('DELETE')) {
            return generateDeleteRequest(path, params);
        } else {
            throw new HttpClientException('Unknown Method: ' + method);
        }
    }

    /**
     * Generate get request.
     * 
     * @param path the path
     * @param params the params
     * @return the http get
     */
    private HttpRequest generateGetRequest(String path, Map<String,String> params) {
        URL uri = buildUri(path, params);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('GET');
        return req;
    }

    /**
     * Generate post request.
     * 
     * @param path the path
     * @param body the body content
     * @param params the params
     * @return the http post
     */
    private HttpRequest generatePostRequest(String path, String body, Map<String,String> params) {
        URL uri = buildUri(path);
        
        // if body exists, then use body
        String entity = null;
        if (body != null) {
            entity = body;
        } else {
            entity = buildEntityBody(params);
        }
        HttpRequest req = new HttpRequest();
        System.debug('IN GENERATE POST REQUEST');
        req.setHeader('Content-Type','multipart/form-data; boundary='+this.multipartBoundary);
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('POST');
        req.setBody(entity);
        req.setHeader('Content-Length',String.valueof(entity.length()));
        System.debug('IN GENERATE POST REQUEST-->'+req);        
        System.debug('   Content-Type       : -->'+req.getHeader('Content-Type'));
        System.debug('   Content-Length     : -->'+req.getHeader('Content-Length'));
        return req;
    }

    /**
     * Generate put request.
     * 
     * @param path the path
     * @param params the params
     * @return the http put
     */
    private HttpRequest generatePutRequest(String path, String body, Map<String,String> params) {
        URL uri = buildUri(path);

        // if body exists, then use body
        String entity = null;
        if (body != null) {
            entity = body;
        } else {
            entity = buildEntityBody(params);
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('PUT');
        req.setBody(entity);
        return req;
    }

    /**
     * Generate delete request.
     * 
     * @param path the path
     * @param params the params
     * @return the http delete
     */
    private HttpRequest generateDeleteRequest(String path, Map<String,String> params) {
        URL uri = buildUri(path);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('DELETE');
        return req;
    }

    /*
     * Helper functions for building methods
     */
    /**
     * Builds the entity body.
     * 
     * @param params the params
     * @return the url encoded form entity
     */
    private String buildEntityBody(Map<String,String> params) {
        String entityBody='';
        if (params != null) {
            for (String key : params.keySet()) {
                try {
                    entityBody += (entityBody=='' ? '' : '&')
                                + key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
                } catch (Exception e) {
                    System.debug('ERROR: ' + e);
                }
            }
        }
        if(paramList.size()>0){//Same name parameters are configured
            List<String> sameNameParams = new List<String>();
            for(Param par : paramList){
                sameNameParams.add(par.getParam());
            }
            if(params.keySet().size()>0){
                entityBody+='&'+String.join(sameNameParams,'&');
            }else{
                entityBody=String.join(sameNameParams,'&');
            }
        }
        return entityBody;
    }

    /**
     * Builds the uri.
     * 
     * @param path the path
     * @return the uRI
     */
    private URL buildUri(String path) {
        return buildUri(path, null);
    }

    /**
     * Builds the uri.
     * 
     * @param path the path
     * @param queryStringParams the query string params
     * @return the uRI
     */
    private URL buildUri(String path, Map<String,String> queryStringParams) {
        String sb = path;

        if (queryStringParams != null && queryStringParams.size() > 0) {
            sb += '?';
            sb += buildEntityBody(queryStringParams);
        }

        URL uri;
        try {
            uri = new URL(sb);
        } catch (Exception e) {
            throw new HttpClientException('Invalid uri: '+sb);
        }
        return uri;
    }

    /**
     * Builds multipart body
     * 
     * @param List<Multipart> parts to include
     * @return body in multipart format (i.e. delimited with boundaries)
     */
    public String buildMultipartBody(List<Multipart> parts) {

        String body = '';

        // add each part
        for (Multipart part : parts) {
            body+= '--' + this.multipartBoundary + '\r\n';
            if (!part.isFile()) {
                body+='Content-Disposition: form-data; name="' + part.getName() + '"\r\n\r\n';
                body+=part.getContents();
            } else {
                body+='Content-Disposition: form-data; name="file"; filename="' + part.getName() + '"\r\n';
                body+='Content-Transfer-Encoding: base64\r\n';
                body+='Content-Type: ' + part.getContentType() + '\r\n\r\n';
                body+=EncodingUtil.base64Encode(part.getBlobContents());
            }
            body+='\r\n';
        }
        body+='--' + this.multipartBoundary + '--';
        body+='\r\n';

        return body;
    }
    
    /**
     * Setup request.
     * 
     * @param path the path
     * @param method the method
     * @param body the request body content. The body has preference over params.
     * @param params the params
     * @return the http uri request
     */
    private HttpRequest setupRequest(String path, String method, String body,
            Map<String, String> params) {
        
        String normalizedPath = path.toLowerCase();
        String sb = '';

        // If we've given a fully qualified uri then skip building the endpoint
        if (normalizedPath.startsWith('http://')
                || normalizedPath.startsWith('https://')) {
            sb += path;
        } else {
            sb += this.endpoint;

            if (!normalizedPath.startsWith('/')) {
                sb += '/';
            }
            sb += path;
        }
        path = sb;
        HttpRequest request = buildMethod(method, path, body, params);
        return request;
    }

    /**
     * Class for holding multipart objects
     */
    public class Multipart {
        private String name;
        private String contents;
        private String contentType;
        private Blob blobContents;

        public Multipart(String name, String contents) {
            this.name = name;
            this.contents = contents;
        }

        public Multipart(String name, Blob blobContents, String contentType) {
            this.name = name;
            this.blobContents = blobContents;
            this.contentType = contentType;
        }

        public String getName() {
            return this.name;
        }

        public String getContents() {
            return this.contents;
        }

        public Blob getBlobContents() {
            return this.blobContents;
        }

        public String getContentType() {
            return this.contentType;
        }

        public Boolean isFile() {
            return this.blobContents != null;
        }
    }
}