package com.cooladata.tracking.sdk.flash 
{
	import flash.utils.Dictionary;
	import com.cooladata.tracking.sdk.flash.utility.Utility;
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	import com.cooladata.tracking.sdk.flash.utility.ASCollectedParameters;
	
	/**
	 * ...
	 * @author ofir
	 */
	public class TrackEvent 
	{
		private var trackEventObject:Object;
		
		public function TrackEvent(eventName:String, userId:String, sessionId:String , dictionary:Dictionary, eventId:Number, callBackFunction:Function) {
			var trackEventObject:Object = new Object();
			
			trackEventObject.event_name = eventName;
			
			trackEventObject.user_id = userId;
			
			if (sessionId != null && sessionId != "")
				trackEventObject.session_id = sessionId;
			
			//adding dictionary parameters to trackEventObject in a non-nested structure. 
			if (dictionary != null){
				var arrResultKey: Array = new Array();
				for ( var theKey: Object in dictionary ){
					arrResultKey.push( theKey );
				}
			
				for (var i:int = 0; arrResultKey.length > i; i++ ) {
					var key:Object = arrResultKey[i];
					var value:Object = dictionary[key];
					trackEventObject["" + key] = value;
				}
			}
			
			//adding AS# collected parameters to trackEventObject in a non-nested structure.
			var collectedParams:Dictionary = ASCollectedParameters.asCollectedParams();
			if (collectedParams != null){
				var arrResultKey: Array = new Array();
				for ( var theKey: Object in collectedParams ){
					arrResultKey.push( theKey );
				}
			
				for (var i:int = 0; arrResultKey.length > i; i++ ) {
					var key:Object = arrResultKey[i];
					var value:Object = collectedParams[key];
					trackEventObject["" + key] = value;
				}
			}
			
			//adding callBackFunction to ConfigManager.eventIdDictionary.
			if (callBackFunction != null) {
				trackEventObject.hasCallBackFunction = true;
				trackEventObject.event_id = eventId;
				//if there is no eventId, create new array of functions for the specific eventId.
				if (ConfigManager.eventIdDictionary[eventId] == undefined) {
					var arrayOfCallBackFunctions:Array = new Array();
					arrayOfCallBackFunctions.push(callBackFunction);
					ConfigManager.eventIdDictionary[eventId] = arrayOfCallBackFunctions;
					var t:int = 0;
				}
				else {
					ConfigManager.eventIdDictionary[eventId].push(callBackFunction);
				}
			}
			
			this.trackEventObject = trackEventObject;
		}
		
		public function getTrackEventObject():Object {
			return this.trackEventObject;
		}
	}
}
