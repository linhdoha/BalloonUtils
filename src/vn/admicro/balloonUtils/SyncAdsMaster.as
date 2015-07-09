package vn.admicro.balloonUtils
{
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SyncAdsMaster extends EventDispatcher
	{
		public static const SLAVES_ARE_READY:String = "allSlaveAreReady";
		
		private var _slaveCodes:Array = [];
		private var lCCheckers:Dictionary = new Dictionary();
		private var timer:Timer;
		private var _client:MovieClip;
		private var _autoSyncTimeline:Boolean;
		private var _startFrame:Object;
		
		public function SyncAdsMaster(slaveCodes:Array, client:MovieClip, autoSyncTimeline:Boolean = false, startFrame:Object = 2)
		{
			_slaveCodes = slaveCodes;
			_client = client;
			_autoSyncTimeline = autoSyncTimeline;
			_startFrame = startFrame;
			
			if (_autoSyncTimeline)
			{
				_client.stop();
			}
			
			for each (var slaveCode:String in _slaveCodes)
			{
				var lCChecker:LocalConnectionChecker = new LocalConnectionChecker(slaveCode);
				lCChecker.addEventListener(LocalConnectionChecker.SLAVE_READY, onSlaveReady);
				
				lCCheckers[slaveCode] = lCChecker;
			}
		
		}
		
		private function onSlaveReady(e:DataEvent):void
		{
			
			if (isReady)
			{
				dispatchEvent(new Event(SLAVES_ARE_READY));
				
				if (_autoSyncTimeline)
				{
					_go();
				}
			}
		}
		
		private function get isReady():Boolean
		{
			var returnVal:Boolean = true;
			
			for each (var slaveCode:String in _slaveCodes)
			{
				returnVal = returnVal && LocalConnectionChecker(lCCheckers[slaveCode]).isReady;
			}
			
			return returnVal;
		}
		
		private function _go():void
		{
			_client.gotoAndPlay(_startFrame);
			
			for each (var slaveCode:String in _slaveCodes)
			{
				LocalConnectionChecker(lCCheckers[slaveCode]).go();
			}
		}
		
		public function stop():void
		{
			_client.stop();
			
			for each (var slaveCode:String in _slaveCodes)
			{
				LocalConnectionChecker(lCCheckers[slaveCode]).stop();
			}
		}
		
		public function replay():void {
			_go();
		}
		
		public function callSlaveFunction(functionName:String, ... args):void {
			for each (var slaveCode:String in _slaveCodes)
			{
				LocalConnectionChecker(lCCheckers[slaveCode]).callFunction(functionName, args);
			}
		}
	}

}