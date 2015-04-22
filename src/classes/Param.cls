//Param class for providing support for multiple params with same name
public with sharing class Param {

	public String name 	{get;set;} //holds name of the param
	public String value {get;set;} //holds value of the param

	//Getting the final parm to be passed in request with encoded under UTF-8 format
	public String getParam(){
		return EncodingUtil.urlEncode(name, 'UTF-8')+'='+EncodingUtil.urlEncode(value, 'UTF-8');
	}

	//Parameterized constructor to ensure that every name will have value associated with it.
	public Param(String name, String value){
		this.name = name;
		this.value = value;
	}

}