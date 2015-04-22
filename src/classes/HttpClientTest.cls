/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class HttpClientTest {
    private static String endpoint = 'https://www.endpint.com/1.1';
    
    @isTest
    private static void testSendRequestGetMethod() {

        HttpClient client = new HttpClient(endpoint);
        String body = null;
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequestWithToken('/urlpath', 'GET', body, 'token');

            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());
            
        Test.stopTest();
    }
    
    @isTest
    private static void testSendRequestPostWithStringBody() {

        HttpClient client = new HttpClient(endpoint);
        String body = 'this is body string';
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequestWithToken('/urlpath', 'POST', body, 'token');

            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());
            
        Test.stopTest();
    }

    @isTest
    private static void testSendRequestPostWithParameterMap() {

        HttpClient client = new HttpClient(endpoint);
        Map<String, String> params = new Map<String, String>();
        params.put('key1', 'value1');
        param p = new param('name',  'value1');
        client.paramList.add(p);
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequestWithToken('/urlpath', 'POST', params, 'token');

            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());
            
        Test.stopTest();
    }
    
    @isTest
    private static void testSendRequestPutWithStringBody() {

        HttpClient client = new HttpClient(endpoint);
        String body = 'this is body string';
        
        Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequestWithToken('/urlpath', 'PUT', body, 'token');

            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());
            
        Test.stopTest();
    }
    
    @isTest
    private static void testSendRequestDeleteMethod() {

        HttpClient client = new HttpClient(endpoint);
        String body = null;
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequestWithToken('/urlpath', 'DELETE', body, 'token');

            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());
            
        Test.stopTest();
    }

    @isTest
    private static void testSendRequest() {

        HttpClient client = new HttpClient(endpoint);
        String body = null;
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequest('/urlpath', 'DELETE', new Map<String,String>{'test'=>'test'}, 'token');
            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());

        Test.stopTest();
    }

    @isTest
    private static void testSendRequestWithoutToken() {

        HttpClient client = new HttpClient(endpoint);
        String body = null;
        
        // test starts here
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IDOL_TestHelper.MockHttpResponseGenerator());
            
            HttpResponse response = client.sendRequest('/urlpath', 'DELETE', new Map<String,String>{'test'=>'test'});
            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('Accepted', response.getStatus());

        Test.stopTest();
    }
}