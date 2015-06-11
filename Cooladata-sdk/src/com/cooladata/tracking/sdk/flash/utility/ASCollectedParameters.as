package com.cooladata.tracking.sdk.flash.utility 
{
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ofir
	 * ASCollectedParameters returns key-value object with all the collected parameters related to the user's environment.
	 */
	public class ASCollectedParameters 
	{	
		public static function asCollectedParams():Dictionary
		{
			var session_os:String = "";
			var session_os_version:String = "";
			var session_browser:String = "";
			var session_browser_version:String = "";
			var session_dua:String = "";
			var session_screen_scale:String = "";
			var time_in_app:Number = 0;
			
			session_os = Capabilities.os;
			session_os_version = Capabilities.version;
			try{
				session_browser = ExternalInterface.call("window.navigator.appName.toString");
				session_browser_version = ExternalInterface.call("window.navigator.appVersion.toString");
				session_dua = ExternalInterface.call("window.navigator.userAgent.toString");
			}
			catch (error:Error) {
				//not in a browser
				session_browser = "";
				session_browser_version = "";
				session_dua = "";
			}
			session_screen_scale = "{" + Capabilities.screenResolutionX + "," + Capabilities.screenResolutionY + "}";
			time_in_app = Math.floor((new Date().getTime() - ConfigManager.getInstance().getStartingTime()) / 1000);
			
			//preper object of params to send:
			var objectOfASParams:Dictionary = new Dictionary();
			
			if (session_os != "")
				objectOfASParams["session_os"] = session_os;
			
			if (session_os_version != "")
				objectOfASParams["session_os_version"] = session_os_version;
			
			if (session_browser != "")
				objectOfASParams["session_browser"] = session_browser;
			
			if (session_browser_version != "")
				objectOfASParams["session_browser_version"] = session_browser_version;
			
			if (session_dua != "")
				objectOfASParams.session_dua = session_dua;
			
			if (session_screen_scale != "")
				objectOfASParams["session_screen_scale"] = session_screen_scale;
			
			objectOfASParams["time_in_app"] = time_in_app;
			
			objectOfASParams.event_timestamp_epoch = new Date().getTime();
			objectOfASParams["tracker_type"] = "Flash";
			objectOfASParams["tracker_version"] = ConfigManager.getInstance().getVersion();
			
			return objectOfASParams;
		}
		
	}

}