package com.cooladata.tracking.sdk.flash.utility 
{
	import flash.system.Capabilities;
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
		
			session_screen_scale = "{" + Capabilities.screenResolutionX + "," + Capabilities.screenResolutionY + "}";
			time_in_app = Math.floor((new Date().getTime() - ConfigManager.getInstance().getStartingTime()) / 1000);
			
			//preper object of params to send:
			var objectOfASParams:Dictionary = new Dictionary();
			
			if (session_os != "")
				objectOfASParams["session_os"] = session_os;
			
			if (session_os_version != "")
				objectOfASParams["session_os_version"] = session_os_version;
			
			if (session_screen_scale != "")
				objectOfASParams["session_screen_scale"] = session_screen_scale;
			
			objectOfASParams["time_in_app"] = time_in_app;
			
			objectOfASParams["event_timestamp_epoch"] = (new Date()).time;
			objectOfASParams["event_timezone_offset"] = -(new Date()).timezoneOffset / 60; // Timezone diff in hours
			objectOfASParams["tracker_type"] = "Flash";
			objectOfASParams["tracker_version"] = ConfigManager.getInstance().getVersion();
			
			// Add the event counter
			objectOfASParams["events_counter"] = ConfigManager.getInstance().getEventsCounter();
			
			// Increase the event counting
			ConfigManager.getInstance().increaseEventsCounter();
			
			return objectOfASParams;
		}
		
	}

}