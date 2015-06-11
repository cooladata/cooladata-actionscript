package com.cooladata.tracking.sdk.flash 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ofir
	 */
	public class CoolaDataDeliveryResult 
	{
		public var eventId:Number;
		public var status:Boolean;
		public var deliveryStatusDescription:String;
		public var deliveryStatusCode:int;
		public var responseProperties:Dictionary = new Dictionary();
		
		public function CoolaDataDeliveryResult(event_id:Number, status:Boolean, deliveryStatusDescription:String, 
		deliveryStatusCode:Number, keyValuePairs:Object) 
		{
			this.eventId = event_id;
			this.status = status;
			this.deliveryStatusDescription = deliveryStatusDescription;
			this.deliveryStatusCode = deliveryStatusCode;
			
			for (var key:String in keyValuePairs) {
				var value:String = keyValuePairs[key];
				this.responseProperties["" + key] = value;
			}
		}
		
	}

}