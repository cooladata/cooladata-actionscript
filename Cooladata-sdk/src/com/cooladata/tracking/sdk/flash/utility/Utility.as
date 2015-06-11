package com.cooladata.tracking.sdk.flash.utility
{
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ofir
	 */
	public class Utility 
	{
		//Convert the array of track events to a JSON string. the structure is a newline delimited JSON.
		public static function getArrayOfTrackEventsAsMultiJson(arrayOfTrackEvents:Array):String {
			var trackEvents:String = "";
			if (arrayOfTrackEvents != null && arrayOfTrackEvents.length > 0){
				for (var i:int = 0 ; i < arrayOfTrackEvents.length ; i++ ) {
					trackEvents = trackEvents + JSON.stringify(arrayOfTrackEvents[i]) + "\n\r,";
				}
				trackEvents = trackEvents.slice( 0, -3 );
			}
			
			return trackEvents;
		}
		
		//Convert the array of track events to a JSON string.
		public static function getTrackEventsAsSingleJson(trackEventObject:Object):String {
			var trackEvents:String = "";
			if (trackEventObject != null){
				trackEvents = JSON.stringify(trackEventObject);
			}
			
			return trackEvents;
		}
		
	}

}