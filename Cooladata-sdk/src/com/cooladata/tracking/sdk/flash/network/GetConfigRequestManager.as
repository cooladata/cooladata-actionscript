package com.cooladata.tracking.sdk.flash.network 
{
	import com.cooladata.tracking.sdk.flash.CoolaDataTracker;
	import com.cooladata.tracking.sdk.flash.events.OperationCompleteEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GetConfigRequestManager 
	{
		private var endpointURL:String;
		private var loader:URLLoader;
		
		public function GetConfigRequestManager(host:String, appKey:String) {
			endpointURL = host + "/egw/2/" + appKey + "/config";
		}
		
		public function sendRequest():void {
			var request:URLRequest = new URLRequest(endpointURL);
			loader = new URLLoader();
			configureListenersSingleRequest(loader);
			loader.load(request);
		}
		
		
		// LISTENERS SINGLE REQUEST
		private function configureListenersSingleRequest(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandlerSingleRequest);
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
			var clibrationTime:Number = data.configuration.calibrationTimestampMillis;
			
			CoolaDataTracker.getInstance().getConfigManager().setCalibrationTimeMS(clibrationTime);
			
			CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__GOT_CALIBRATION_TIME, clibrationTime));
		}
	}
}