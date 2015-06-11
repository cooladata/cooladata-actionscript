package com.cooladata.tracking.sdk.flash.network 
{
	import com.cooladata.tracking.sdk.flash.CoolaDataTracker;
	import com.cooladata.tracking.sdk.flash.QueueManager;
	import com.cooladata.tracking.sdk.flash.events.OperationCompleteEvent;
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	import com.cooladata.tracking.sdk.flash.utility.Enums;
	import com.cooladata.tracking.sdk.flash.utility.Utility;
	
	import flash.CoolaDataTracker;
	import flash.QueueManager;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ofir
	 */
	public class HttpMultiRequestManager 
	{
		private var loader:URLLoader;
		
		private var arrayOfTrackEventsToSend:Array;
		private var resultObject:Object = new Object();
		private var callBackFunction:Function = null;
		private var deliveryStatusCode:int;
		private var status:int;
		private var statusDescription:String;
		private var maxTotalRequestRetries:int;
		
		public function HttpMultiRequestManager(arrayOfTrackEventsToSend:Array, publishEventsCallback:Function) {
			maxTotalRequestRetries = ConfigManager.getInstance().getMaxTotalRequestRetries();
			
			this.callBackFunction = publishEventsCallback;
			this.arrayOfTrackEventsToSend = arrayOfTrackEventsToSend;
			sendMultiJson();
		}
		
		private function sendMultiJson():void {
			var urlRequestMaker:UrlRequestMaker = new UrlRequestMaker(Utility.getArrayOfTrackEventsAsMultiJson(this.arrayOfTrackEventsToSend), "multi");
			var request:URLRequest = urlRequestMaker.getRequest();
			
			CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__TRYING_TO_SEND_EVENTS, arrayOfTrackEventsToSend.length));
			
			loader = new URLLoader();
			configureListenersMultiRequest(loader);
			loader.load(request);
		}
		
		// LISTENERS MULTI REQUEST
		private function configureListenersMultiRequest(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandlerMultiRequest);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandlerMultiRequest);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
		}
		
		// HANDLERS SECURITY ERROR
		private function securityError(event:SecurityErrorEvent):void {
			trace("securityError: " + event);
			
			CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__SECUTIRY_ERROR, 0));
		}
		
		// HANDLERS MULTI REQUEST
		private function ioError(event:Event):void {
			trace("ioError: " + event);
			
			CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__EVENTS_SENT_ERROR, QueueManager.getInstance().getQueuesSize()));
		}
		
		private function completeHandlerMultiRequest(event:Event):void {
			var data:Object = JSON.parse(event.target.data);
			sendResultToCallBackFunction(data.status, data.results, "");
			
			CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__EVENTS_SENT_SUCCESS, QueueManager.getInstance().getQueuesSize()));
		}
		
		private function httpStatusHandlerMultiRequest(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
			
			if (event.status == 200) {
				trace("multi complete");
				this.deliveryStatusCode = event.status;
				//the completeHandlerMultiRequest will send to callback function.
			}
			else if (event.status == 403) {
				ConfigManager.getInstance().setTokenIsValid(false);
				CoolaDataTracker.getInstance().clearEventsInterval();
				this.deliveryStatusCode = event.status;
				sendResultToCallBackFunction(false, null, Enums.ERROR_403);
				trace(Enums.ERROR_INVALID_TOKEN);
			}
			else {
				for (var i:int = 0 ; this.arrayOfTrackEventsToSend.length > i ; i++) {
					var singleTrackEvent:Object = this.arrayOfTrackEventsToSend[i];
					var httpSingleRequestManager:HttpSingleRequestManager = new HttpSingleRequestManager(singleTrackEvent, this.callBackFunction, this);
				}
			}
		}
			
		public function getMaxTotalRequestRetries():int {
			return this.maxTotalRequestRetries;
		}
		
		public function reduceMaxTotalRequestRetries():void {
			this.maxTotalRequestRetries--;
		}
		
		private function sendResultToCallBackFunction(status:Boolean, result:Object, description:String):void {
			resultObject.status = status
			resultObject.results = result;
			resultObject.deliveryStatusDescription = description;
			resultObject.deliveryStatusCode = this.deliveryStatusCode;
			this.callBackFunction(resultObject);
		}
		
	}

}