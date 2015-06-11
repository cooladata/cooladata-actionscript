package com.cooladata.tracking.sdk.flash 
{
	import com.cooladata.tracking.sdk.flash.events.OperationCompleteEvent;
	import com.cooladata.tracking.sdk.flash.network.HttpMultiRequestManager;
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	import com.cooladata.tracking.sdk.flash.utility.Enums;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author ofir 20.2.14
	 */
	public class CoolaDataTracker extends Sprite
	{
		
		private static var _instance:CoolaDataTracker = null;
		private static var allowInstantiation:Boolean;
		private var configManager:ConfigManager;
		
		protected var sendEventsInterval:uint;
		
		public function CoolaDataTracker(){
			if(CoolaDataTracker.allowInstantiation) {
				CoolaDataTracker.allowInstantiation = false;
				configManager = ConfigManager.getInstance();
				configManager.setStartingTime( new Date().getTime() );
			} else {
				throw new Error(Enums.ERROR_INSTANTIATION_FAILED);
			} 
		}

		public static function getInstance():CoolaDataTracker{
			if (_instance == null) {
				CoolaDataTracker.allowInstantiation = true;
				_instance = new CoolaDataTracker();
			} 
			return _instance;
		}
		
		public function getConfigManager():ConfigManager {
			return configManager;
		}
		
		public function setup(apiToken:String, userServiceEndPoint:String, userID:String, sessionID:String):void {
			
			if (apiToken == null || apiToken == "") {
				throw new Error(Enums.ERROR_EMPTY_API_TOKEN);
			}
			else {
				configManager.setApiToken(apiToken);
			}
			
			if (userServiceEndPoint != null && userServiceEndPoint != ""){
				configManager.setUserServiceEndPoint(userServiceEndPoint);
			}
			
			if (userID != null && userID != "") {
				configManager.setUserID(userID);
			}
			
			if (sessionID != null && sessionID != "") {
				configManager.setSessionID(sessionID);
			}
			
			configManager.setTokenIsValid(true);
			
			configManager.initializeConfigeManager();
		}
		
		public function trackEvent(eventName:String, userId:String, sessionId:String , dictionary:Dictionary, eventId:Number, callBackFunction:Function):void {
			if (configManager.getTokenIsValid()){
				if (eventName == null || eventName == "") {
					throw new Error(Enums.ERROR_EMPTY_EVENT_NAME);
				}
				
				if ( ( (userId == null) || (userId == "") ) ) {
					if (configManager.getUserID() == "" || configManager.getUserID() == null) {
						throw new Error(Enums.ERROR_EMPTY_USERID);
					} else {
						userId = configManager.getUserID();
					}
				}
				
				if ((isNaN(eventId) || eventId == 0) && callBackFunction != null) {
					throw new Error(Enums.ERROR_MISSING_EVENT_ID);
				}
				else if ((!isNaN(eventId) && eventId != 0) && callBackFunction == null) {
					throw new Error(Enums.ERROR_MISSING_CALL_BACK_FUNCTION);
				}
				
				var trackEvent:TrackEvent = new TrackEvent(eventName, userId, sessionId, dictionary, eventId, callBackFunction);
				QueueManager.getInstance().storeTrackEvent(trackEvent.getTrackEventObject());
			}
			else {
				throw new Error(Enums.ERROR_INVALID_TOKEN);
			}
	    }
		
		public function startEventsInterval():void {
			if (ConfigManager.getInstance().getStatus()){
				sendEventsInterval = setInterval(publishEvents, configManager.getEventsPublishIntervalMillis());
			}
		}
		//clearEventsInterval function will call only when setup failed or in case of 403 error message from the server.
		public function clearEventsInterval():void {
			clearInterval(sendEventsInterval);
		}
		
		public function publishEvents():void {
			if (ConfigManager.getInstance().getStatus()){
				var arrayOfTrackEventsToSend:Array = QueueManager.getInstance().getArrayOfTrackEventsToSend();
				if (arrayOfTrackEventsToSend != null) {
					//send multi request with arrayOfTrackEventsToSend
					var httpRequest:HttpMultiRequestManager = new HttpMultiRequestManager(arrayOfTrackEventsToSend, publishEventsCallback);
				}
			}
		}
		
		//Sending the events result to the call back function with a CoolaDataDeliveryResult object.
		private function publishEventsCallback(eventObject:Object):void {
			var eventIdDictionary:Dictionary = ConfigManager.eventIdDictionary;
			
			for (var event_id:Object in eventObject.results) {
				var value:Object = eventObject.results[event_id];
				var coolaDataDeliveryResult:CoolaDataDeliveryResult = new CoolaDataDeliveryResult(value.event_id, eventObject.status, 
				eventObject.deliveryStatusDescription, eventObject.deliveryStatusCode, value);
				var arrayOfFunctionsToCallBack:Array = eventIdDictionary[value.event_id];
				for (var i:int = 0 ; arrayOfFunctionsToCallBack.length > i ; i++) {
					arrayOfFunctionsToCallBack[i](coolaDataDeliveryResult);
				}
			}
		}
		
		public function sendOperationCompleteEvent(event:OperationCompleteEvent):void {
			dispatchEvent(event);
		}
				
	}
}