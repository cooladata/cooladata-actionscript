package com.cooladata.tracking.sdk.flash.events
{
	import flash.events.Event;
	
	public class OperationCompleteEvent extends Event
	{
		public static const EVENT__ITEM_IN_QUEUE:String = "eventItemInQueue";
		public static const EVENT__TRYING_TO_SEND_EVENTS:String = "eventTryingToSendEvents";
		public static const EVENT__EVENTS_SENT_ERROR:String = "eventSendError";
		public static const EVENT__EVENTS_SENT_SUCCESS:String = "eventSendSuccess";
		public static const EVENT__SECUTIRY_ERROR:String = "eventSecurityError";
		public static const EVENT__GOT_CALIBRATION_TIME:String = "eventGotCalibrationTime";

		public var value:Number = 0;
		
		public function OperationCompleteEvent(type:String, pValue:Number)
		{
			value = pValue;
			
			super(type, bubbles, cancelable);
		}
	}
}