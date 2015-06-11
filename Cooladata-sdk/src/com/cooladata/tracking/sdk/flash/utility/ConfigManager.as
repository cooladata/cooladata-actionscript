package com.cooladata.tracking.sdk.flash.utility 
{
	import com.cooladata.tracking.sdk.flash.CoolaDataTracker;
	import com.cooladata.tracking.sdk.flash.QueueManager;
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ofir
	 * 
	 */
	public class ConfigManager 
	{
		private var version:String = "v1.0.2";
		private var status:Boolean;
		private var internalServiceEndPoint:String = "https://api.cooladata.com";
		private var serviceEndPoint:String;
		private var userServiceEndPoint:String;
		private var queueMaxSize:int = 10000;
		private var maxEventsPerRequest:int = 50;	
		private var maxSingleRequestRetries:int = 3;
		private var maxTotalRequestRetries:int = 24;
		private var eventsPublishBackoffIntervalMillis:int = 5000;
		private var eventsOutageBackoffIntervalMillis:int = 15000;
		private var eventsPublishIntervalMillis:int = 5000;
		private var maxQueueSizeTriggerPercent:int = 85;

				
		//eventIdDictionary store for every eventId an array of callbackfunction to send back the result from the server.
		public static var eventIdDictionary:Dictionary = new Dictionary();
		
		//If we get 403 error the tokenIsValid turns to false. else is true.
		private var tokenIsValid:Boolean;

		private var startingTime:Number;
		
		private var apiToken:String = "";
		private var userID:String = "";
		private var sessionID:String = "";
		
		private static var _instance:ConfigManager = null;
		private static var allowInstantiation:Boolean;
		
		public function ConfigManager(){
			if(ConfigManager.allowInstantiation){
				ConfigManager.allowInstantiation = false;
			}
		}

		public static function getInstance():ConfigManager{
			if (_instance == null) {
				ConfigManager.allowInstantiation = true;
				_instance = new ConfigManager();
			} 
			return _instance;
		}
		
		public function getVersion():String {
			return this.version;
		}
		
		public function getStatus():Boolean {
			return this.status;
		}
		
		public function getInternalServiceEndPoint():String {
			return this.internalServiceEndPoint;
		}
		
		public function getQueueMaxSize():int {
			return this.queueMaxSize;
		}
		
		public function getMaxEventsPerRequest():int {
			return this.maxEventsPerRequest;
		}
		
		public function getMaxSingleRequestRetries():int {
			return this.maxSingleRequestRetries;
		}
		
		public function getMaxTotalRequestRetries():int {
			return this.maxTotalRequestRetries;
		}
		
		public function getEventsPublishBackoffIntervalMillis():int {
			return this.eventsPublishBackoffIntervalMillis;
		}
		
		public function getEventsOutageBackoffIntervalMillis():int {
			return this.eventsOutageBackoffIntervalMillis;
		}
		
		public function getEventsPublishIntervalMillis():int {
			return this.eventsPublishIntervalMillis;
		}
		
		public function getMaxQueueSizeTriggerPercent():int {
			return this.maxQueueSizeTriggerPercent;
		}
		
		public function getStartingTime():Number {
			return this.startingTime;
		}
		
		public function setStartingTime(startingTime:Number):void {
			this.startingTime = startingTime;
		}
		
		public function getApiToken():String {
			return this.apiToken;
		}
		
		public function setApiToken(apiToken:String):void {
			this.apiToken = apiToken;
		}
		
		public function setUserServiceEndPoint(userServiceEndPoint:String):void {
			this.userServiceEndPoint = userServiceEndPoint;
		}
		
		public function getUserServiceEndPoint():String {
			return this.userServiceEndPoint;
		}
		
		public function getUserID():String {
			return this.userID;
		}
		
		public function setUserID(userID:String):void {
			this.userID = userID;
		}
		
		public function getSessionID():String {
			return this.sessionID;
		}
		
		public function setSessionID(sessionID:String):void {
			this.sessionID = sessionID;
		}
		
		public function getTokenIsValid():Boolean {
			return this.tokenIsValid;
		}
		
		public function setTokenIsValid(tokenIsValid:Boolean):void {
			this.tokenIsValid = tokenIsValid;
		}
		
		public function setQueueMaxSize(value:int):void {
			this.queueMaxSize = value;
		}
		
		public function setMaxEventsPerRequest(value:int):void {
			this.maxEventsPerRequest = value;
		}
		
		public function setMaxSingleRequestRetries(value:int):void {
			this.maxSingleRequestRetries = value;
		}
		
		public function setMaxTotalRequestRetries(value:int):void {
			this.maxTotalRequestRetries = value;
		}
		
		public function setEventsPublishBackoffIntervalMillis(value:int):void {
			this.eventsPublishBackoffIntervalMillis = value;
		}
		
		public function setEventsOutageBackoffIntervalMillis(value:int):void {
			this.eventsOutageBackoffIntervalMillis = value;
		}
		
		public function setEventsPublishIntervalMillis(value:int):void {
			this.eventsPublishIntervalMillis = value;
		}
		
		public function setMaxQueueSizeTriggerPercent(value:int):void {
			this.maxQueueSizeTriggerPercent = value;
		}
		
		public function getServiceEndPoint():String {
			if (serviceEndPoint != "" && serviceEndPoint != null) {
					return this.serviceEndPoint;
				}
				else {
					if (userServiceEndPoint != "" && userServiceEndPoint != null) {
						return this.userServiceEndPoint;
					}
					else {
						return this.internalServiceEndPoint;
					}
				}
		}

		public function initializeConfigeManager():void {
			this.status = true;
			QueueManager.getInstance().initializeQueuesAfterSetupSucceed();
			CoolaDataTracker.getInstance().startEventsInterval();
		}

	}

}