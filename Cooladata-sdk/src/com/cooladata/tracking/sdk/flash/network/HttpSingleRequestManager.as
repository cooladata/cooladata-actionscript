package com.cooladata.tracking.sdk.flash.network 
{
	import com.cooladata.tracking.sdk.flash.CoolaDataTracker;
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	import com.cooladata.tracking.sdk.flash.utility.Enums;
	import com.cooladata.tracking.sdk.flash.utility.Utility;
	
	import flash.CoolaDataTracker;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Ofir.
	 */
	public class HttpSingleRequestManager 
	{
		
		private var noNetworkInterval:uint = 0;
		private var sendSingleJsonInterval:uint = 0;
		private var maxSingleRequestRetries:int;
		private var loader:URLLoader;
		private var singleTrackEvent:Object;
		private var resultObject:Object = new Object();
		private var callBackFunction:Function;
		private var deliveryStatusCode:int;
		private var parentHttpMultiRequestManager:HttpMultiRequestManager;
		
		public function HttpSingleRequestManager(singleTrackEvent:Object, publishEventsCallback:Function, httpMultiRequestManager:HttpMultiRequestManager) {
			maxSingleRequestRetries = ConfigManager.getInstance().getMaxSingleRequestRetries();
			
			this.singleTrackEvent = singleTrackEvent;
			this.callBackFunction = publishEventsCallback;
			this.parentHttpMultiRequestManager = httpMultiRequestManager;
			sendSingleJsonInterval = setInterval(sendSingleJson, ConfigManager.getInstance().getEventsPublishBackoffIntervalMillis());
		}
		
		private function sendSingleJson():void {
			var urlRequestMaker:UrlRequestMaker = new UrlRequestMaker(Utility.getTrackEventsAsSingleJson(this.singleTrackEvent), "single");
			var request:URLRequest = urlRequestMaker.getRequest();
			loader = new URLLoader();
			configureListenersSingleRequest(loader);
			loader.load(request);
		}
		
		
		// LISTENERS SINGLE REQUEST
		private function configureListenersSingleRequest(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandlerSingleRequest);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerSingleRequest);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		// HANDLERS SECURITY ERROR
		private function onSecurityError(event:Event):void {
			trace("securityError: " + event);
		}
		
		// HANDLERS SINGLE REQUEST
		private function ioError(event:Event):void {
			trace("ioError: " + event);
		}
		
		private function completeHandlerSingleRequest(event:Event):void {
			var data:Object = JSON.parse(event.target.data);
			sendResultToCallBackFunction(data.status, data.results, "");
		}

		private function httpStatusHandlerSingleRequest(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
			
			if (event.status == 200) {
				clearInterval(sendSingleJsonInterval);
				this.deliveryStatusCode = event.status;
				//adding data to the object in OnComplete listener.
			}
			else if (event.status == 403) {
				ConfigManager.getInstance().setTokenIsValid(false);
				CoolaDataTracker.getInstance().clearEventsInterval();
				this.deliveryStatusCode = event.status;
				sendResultToCallBackFunction(false, null, Enums.ERROR_403);
				clearInterval(sendSingleJsonInterval);
				trace(Enums.ERROR_INVALID_TOKEN);
			}
			else {
				this.deliveryStatusCode = event.status;
				sendResultToCallBackFunction(false, null, Enums.ERROR_GENERAL);
				if (this.parentHttpMultiRequestManager.getMaxTotalRequestRetries() != 0 || this.maxSingleRequestRetries != 0) {
					maxSingleRequestRetries--;
					this.parentHttpMultiRequestManager.reduceMaxTotalRequestRetries();
				}
				else {
					clearInterval(sendSingleJsonInterval);
				}
			}
		}
		
		private function sendResultToCallBackFunction(status:Boolean, result:Object, description:String):void {
			if (this.callBackFunction != null) {
				resultObject.status = status;
				resultObject.result = result;
				resultObject.deliveryStatusDescription = description;
				resultObject.deliveryStatusCode = this.deliveryStatusCode;
				this.callBackFunction(resultObject);
				this.callBackFunction = null;
			}
		}
		
	}

}