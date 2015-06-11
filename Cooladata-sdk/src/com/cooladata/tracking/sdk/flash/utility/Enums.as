package com.cooladata.tracking.sdk.flash.utility 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public final class Enums  
	{
		 public static const ERROR_INVALID_TOKEN:String = "Error: The provided token was invalid or unknown. Call setup() again.";
		 public static const ERROR_EMPTY_USERID:String =  "Error: empty userID.";
		 public static const ERROR_EMPTY_EVENT_NAME:String =  "Error: empty eventName.";
		 public static const ERROR_INSTANTIATION_FAILED:String =  "Error: Instantiation failed: Use CoolaDataTracke.getInstance() instead of new."
		 public static const ERROR_EMPTY_API_TOKEN:String =  "Error: empty apiToken."
		 
		 public static const ERROR_INVALID_URL:String = "Error: Invalid url base or cannot reach the server."
		 public static const ERROR_MISSING_EVENT_ID:String = "Error: Event id must be provided.";
		 public static const ERROR_MISSING_CALL_BACK_FUNCTION:String = "Error: Call back funtion must be provided.";
		 
		 public static const ERROR_QMANAGER_INSTANTIATION_FAILED:String = "Error: Instantiation failed: Use QueueManager.getInstance() instead of new."
		 public static const ERROR_403:String = "Error: The provided token was invalid or unknown.";
		 public static const ERROR_GENERAL:String = "Error: failed to send event due to network issues."; 
		 
	}
	
}