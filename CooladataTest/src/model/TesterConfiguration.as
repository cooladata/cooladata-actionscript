package model
{
	import flash.net.SharedObject;

	public class TesterConfiguration
	{
		private var _sharedObj:SharedObject;
		
		public var hostAddress:String = "https://api.cooladata.com";
		public var apiKey:String = "";
		public var sessionId:String = "Session #1";
		public var userId:String = "User #1";
		public var maxQSize:int = 10000;
		public var maxEventsPerRequest:int = 50;
				
		public function TesterConfiguration()
		{
		}
		
		public function loadConfiguration():void {
			// Get the shared object
			if (_sharedObj == null) {
				if (!createSharedObject()) {
					return;
				}
			}
			
			if (_sharedObj.data.hasOwnProperty("hostAddress")) {
				hostAddress = _sharedObj.data.hostAddress;
			}
			
			if (_sharedObj.data.hasOwnProperty("apiKey")) {
				apiKey = _sharedObj.data.apiKey;
			}
			
			if (_sharedObj.data.hasOwnProperty("sessionId")) {
				sessionId = _sharedObj.data.sessionId;
			}
			
			if (_sharedObj.data.hasOwnProperty("userId")) {
				userId = _sharedObj.data.userId;
			}
			
			if (_sharedObj.data.hasOwnProperty("maxQSize")) {
				maxQSize = _sharedObj.data.maxQSize;
			}
			
			if (_sharedObj.data.hasOwnProperty("maxEventsPerRequest")) {
				maxEventsPerRequest = _sharedObj.data.maxEventsPerRequest;
			}
				
		}
		
		public function saveConfiguration():void {
			// Get the shared object
			if (_sharedObj == null) {
				if (!createSharedObject()) {
					return;
				}
			}
			
			//store the values
			_sharedObj.data.hostAddress = hostAddress;
			_sharedObj.data.apiKey = apiKey;
			_sharedObj.data.sessionId = sessionId;
			_sharedObj.data.userId = userId;
			_sharedObj.data.maxQSize = maxQSize;
			_sharedObj.data.maxEventsPerRequest = maxEventsPerRequest;
			
			//saving the values
			_sharedObj.flush();
		}
		
		private function createSharedObject():Boolean {
			try
			{
				_sharedObj = SharedObject.getLocal("cooladataTesterApp");
				return true;
			}
			catch (error:Error)
			{
				trace("Error creating shared object" + error.toString());
				return false;
			}
		}
	}
}