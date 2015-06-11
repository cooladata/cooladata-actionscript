package com.cooladata.tracking.sdk.flash 
{
	import com.cooladata.tracking.sdk.flash.events.OperationCompleteEvent;
	import com.cooladata.tracking.sdk.flash.utility.ConfigManager;
	import com.cooladata.tracking.sdk.flash.utility.Enums;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author ofir 
	 */
	public class QueueManager
	{
		private static var _instance:QueueManager = null;
		private static var allowInstantiation:Boolean;
		
		private var queueMaxSize:int = ConfigManager.getInstance().getQueueMaxSize();
		
		//In order to achieve a FIFO structure with a priority to track events with a call back functions, there is two queues.
		//one for trackevents with call back function and one witout. The two queues function as one, with max size etc.
		private var queue:Array;
		private var qWriteHead:int;
		private var qReadHead:int;
		private var callbackQueue:Array;
		private var callbackQueueWriteHead:int;
		private var callbackQueueReadHead:int;
		
		//array Of Track Events to send
		private var arrayOfTrackEvents:Array = null;
		
		public function QueueManager() {
			if(QueueManager.allowInstantiation){
				QueueManager.allowInstantiation = false;
				initializeQueues();
			} else {
				throw new Error(Enums.ERROR_QMANAGER_INSTANTIATION_FAILED);
			} 
		}
		// The QueueManager is a singleton
		public static function getInstance():QueueManager{
			if (_instance == null) {
				QueueManager.allowInstantiation = true;
				_instance = new QueueManager();
			} 
			return _instance;
		}
		//Since the user can call trackEvent method before setup method, initializeQueues method initialize the Queues in a temporary arrays,
		//until the setup will call with real parameters from the server.
		private function initializeQueues():void {
			setNewQueue();
			setNewCallBackQueue();
		}
		
		private function setNewQueue():void {
			this.queue = new Array(ConfigManager.getInstance().getQueueMaxSize());
			this.qWriteHead = 0;
			this.qReadHead = 0;
		}
		
		private function setNewCallBackQueue():void {
			this.callbackQueue = new Array(ConfigManager.getInstance().getQueueMaxSize());
			this.callbackQueueWriteHead = 0;
			this.callbackQueueReadHead = 0;
		}
		
		//Initialize the Queues After Setup was called successfully. the method is initialize new arrays with the QueueMaxSize definition from the server and push 
		//inside the old objects that stored.
		public function initializeQueuesAfterSetupSucceed():void {
			var configManager:ConfigManager = ConfigManager.getInstance();
			if (this.queue.length == configManager.getQueueMaxSize()) {
				//decrease the writeHead and readHead for both queues: (so they wont get bigger and bigger)
				while ((this.qWriteHead - this.queue.length) > this.queue.length ) {
					this.qWriteHead = this.qWriteHead - this.queue.length;
				}
				while ((this.qReadHead - this.queue.length) > this.queue.length ) {
					this.qReadHead = this.qReadHead - this.queue.length;
				}
				while ((this.callbackQueueWriteHead - this.callbackQueue.length) > this.callbackQueue.length ) {
					this.callbackQueueWriteHead = this.callbackQueueWriteHead - this.callbackQueue.length;
				}
				while ((this.callbackQueueReadHead - this.queue.length) > this.queue.length ) {
					this.callbackQueueReadHead = this.callbackQueueReadHead - this.queue.length;
				}
			}
			else {
				if (this.queue.length != configManager.getQueueMaxSize()) {
					if ((this.qWriteHead > this.qReadHead) && (this.qWriteHead - this.qReadHead < this.queue.length)) {
						var tempArray:Array = new Array(this.qWriteHead - this.qReadHead);
						for (var i:int = 0 ; this.qWriteHead > this.qReadHead; i++) {
							tempArray[i] = pullNextElementFromQueue();
						}
						setNewQueue();
						for (var j:int = 0 ; tempArray.length > j ; j++) {
							storeTrackEvent(tempArray[j]);
						}
					}
					else {
						setNewQueue();
					}
				}
				if (this.callbackQueue.length != configManager.getQueueMaxSize()) {
					if ((this.callbackQueueWriteHead > this.callbackQueueReadHead) && (this.callbackQueueWriteHead - this.callbackQueueReadHead < this.callbackQueue.length)) {
						var tempArray:Array = new Array(this.callbackQueueWriteHead - this.callbackQueueReadHead);
						for (var i:int = 0 ; this.callbackQueueWriteHead > this.callbackQueueReadHead; i++) {
							tempArray[i] = pullNextElementFromQueueWithCallback();
						}
						setNewCallBackQueue();
						for (var j:int = 0 ; tempArray.length > j ; j++) {
							storeTrackEvent(tempArray[j]);
						}
					}
					else {
						setNewCallBackQueue();
					}
				}
			}
		}
		
		//Storing the track events in the queues.
		/**
		 * 
		 * @param eventToStore
		 * 
		 */
		public function storeTrackEvent(eventToStore:Object):void {
				if (eventToStore.hasCallBackFunction)
					putNewElementToQueueWithCallback(eventToStore);
				else
					putNewElementToQueue(eventToStore);
				
				CoolaDataTracker.getInstance().sendOperationCompleteEvent(new OperationCompleteEvent(OperationCompleteEvent.EVENT__ITEM_IN_QUEUE, QueueManager.getInstance().getQueuesSize()));
				
				//sending the events regardless of the interval of sending events.
				if (checkQueuePercent()) {
					CoolaDataTracker.getInstance().publishEvents();
				}
		}
		
		//Checking if the queues reach the max percent as defined from the server.
		private function checkQueuePercent():Boolean {
			var isReachPercent:Boolean = false;
			var queueSize:Number = qWriteHead - qReadHead;
			var callbackQueueSize:Number = callbackQueueWriteHead - callbackQueueReadHead;

			if ((((queueSize + callbackQueueSize) / queueMaxSize) * 100) > ConfigManager.getInstance().getMaxQueueSizeTriggerPercent()) 
				isReachPercent = true;
				
			return isReachPercent;
		}
		
		public function getQueuesSize():int {
			var queueLength:int = qWriteHead - qReadHead;
			var callbackQueueLength:int = callbackQueueWriteHead - callbackQueueReadHead;
			
			return queueLength + callbackQueueLength;
		}
		
		// pull out of the queues array of track events to send in a multi request. There is a priority to track events with a callback functions.
		public function getArrayOfTrackEventsToSend():Array {
			var queueLength:int = qWriteHead - qReadHead;
			var callbackQueueLength:int = callbackQueueWriteHead - callbackQueueReadHead;
			
			arrayOfTrackEvents = null;
			
			var maxEventsPerRequest:int = ConfigManager.getInstance().getMaxEventsPerRequest();
			
			if ((queueLength + callbackQueueLength) > 0) {
				if (callbackQueueLength >= maxEventsPerRequest) {
					arrayOfTrackEvents = new Array(maxEventsPerRequest);
					for (var j:int = 0 ; j < maxEventsPerRequest ; j++ ) {
							arrayOfTrackEvents[j] = pullNextElementFromQueueWithCallback();
						}
				}
				else {//callbackQueueLength < maxEventsPerRequest
					if (callbackQueueLength > 0) {
						if (queueLength > 0) {
							var totalLength:int = callbackQueueLength + queueLength;
							if (totalLength >= maxEventsPerRequest) {
								arrayOfTrackEvents = new Array(maxEventsPerRequest);
								for (var j:int = 0 ; j < callbackQueueLength ; j++ ) {
									arrayOfTrackEvents[j] = pullNextElementFromQueueWithCallback();
								}
								for (var i:int = 0 ; i < maxEventsPerRequest; i++) {
									arrayOfTrackEvents[i] = pullNextElementFromQueue();
								}
							}
							else {//totalLength < maxEventsPerRequest
								arrayOfTrackEvents = new Array(totalLength);
								for (var j:int = 0 ; j < callbackQueueLength ; j++ ) {
									arrayOfTrackEvents[j] = pullNextElementFromQueueWithCallback();
								}
								for (var i:int = 0 ; i < totalLength; i++) {
									arrayOfTrackEvents[i] = pullNextElementFromQueue();
								}
							}
						}
						else {//callbackQueueLength > 0 && queueLength == 0
							arrayOfTrackEvents = new Array(callbackQueueLength);
							for (var j:int = 0 ; j < callbackQueueLength ; j++ ) {
								arrayOfTrackEvents[j] = pullNextElementFromQueueWithCallback();
							}
						}
					}
					else {//callbackQueueLength == 0 
						if (queueLength >= maxEventsPerRequest) {
							arrayOfTrackEvents = new Array(maxEventsPerRequest);
							for (var i:int = 0 ; i < maxEventsPerRequest; i++) {
								arrayOfTrackEvents[i] = pullNextElementFromQueue();
							}
						}
						else {
							arrayOfTrackEvents = new Array(queueLength);
							for (var i:int = 0 ; i < queueLength; i++) {
								arrayOfTrackEvents[i] = pullNextElementFromQueue();
							}
						}
					}
				}
			}
				
			return arrayOfTrackEvents;
		}
		
		//push new track event to the queue witout call back function. increase the qWriteHead in 1.
		private function putNewElementToQueue(newElement:Object):void {
			queue[qWriteHead % queueMaxSize] = newElement;
			qWriteHead++;
			checkIfWriteHeadBypassReadHeadInQueue();
		}
		
		//pull out track event from the queue witout call back function. increase the qReadHead in 1.
		//qReadHead reach qWriteHead means that there is no more available trackevents to send => pullNextElementFromQueue returns null.
		private function pullNextElementFromQueue():Object {
			var val:Object;
			if (qWriteHead > qReadHead) {
				val = queue[qReadHead % queueMaxSize];
				qReadHead++;
			}
			else
				val = null;
			
			return val;
		}
		
		//push new track event to the queue with call back function. increase the callbackQueueWriteHead in 1.
		private function putNewElementToQueueWithCallback(newElement:Object):void {
			callbackQueue[callbackQueueWriteHead % queueMaxSize] = newElement;
			callbackQueueWriteHead++;
			checkIfWriteHeadBypassReadHeadInCallbackQueue();
		}
		
		//pull out track event from the queue with call back function. increase the callbackQueueReadHead in 1.
		//callbackQueueReadHead reach callbackQueueWriteHead means that there is no more available trackevents to send => pullNextElementFromQueueWithCallback returns null.
		private function pullNextElementFromQueueWithCallback():Object {
			var val:Object;
			if (callbackQueueWriteHead > callbackQueueReadHead) {
				val = callbackQueue[callbackQueueReadHead % queueMaxSize];
				callbackQueueReadHead++;
			}
			else
				val = null;
			
			return val;
		}
		
		//If qWriteHead keep growing while qReadHead stays fixed (no events sent) and the qWriteHead loops over the qReadHead
		//(means: qWriteHead - qReadHead = queueMaxSize), the functions checkIfWriteHeadBypassReadHeadInQueue and
		//checkIfWriteHeadBypassReadHeadInCallbackQueue incresing qReadHead and callbackQueueReadHead according to FIFO structure.
		private function checkIfWriteHeadBypassReadHeadInQueue():void {
			if ((qWriteHead - qReadHead) > queueMaxSize) {
				qReadHead = qWriteHead + 1 - queueMaxSize;
				var droppedEvents:int = qWriteHead - qReadHead - 1;
				trace(droppedEvents + "events were dropped due to overlapping.");
			}
		}
		
		private function checkIfWriteHeadBypassReadHeadInCallbackQueue():void {
			if ((callbackQueueWriteHead - callbackQueueReadHead) > queueMaxSize){
				callbackQueueReadHead = callbackQueueWriteHead + 1 - queueMaxSize;
				var droppedEvents:int = callbackQueueWriteHead - callbackQueueReadHead - 1;
				trace(droppedEvents + "events were dropped due to overlapping.");
			}
		}
	
	}

}