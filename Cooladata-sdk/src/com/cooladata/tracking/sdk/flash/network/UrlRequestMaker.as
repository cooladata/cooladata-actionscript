package com.cooladata.tracking.sdk.flash.network 
{
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	/**
	 * ...
	 * @author ofir
	 */
	public class UrlRequestMaker 
	{
		private var request:URLRequest;
		
		public function UrlRequestMaker(Json:String, type:String) {
			request = new URLRequest();
			request.url = ConfigManager.getInstance().getServiceEndPoint() + "/v1/" + ConfigManager.getInstance().getApiToken() + "/track?r=" + Math.random();
			
			var dataNotEnc:String = '{"events":[' + Json + ']}';
			var dataEnc:String = "data=" + encodeURIComponent(dataNotEnc);
		
			request.data = dataEnc;
			request.requestHeaders = [new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded")];
			request.method = "POST";
		}
		
		public function getRequest():URLRequest {
			return request;
		}
	}

}