package vn.admicro.balloonUtils 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class LocalConnectionChecker extends EventDispatcher 
	{
		public static const SLAVE_READY:String = "slaveReady";
		
		private var connection:LocalConnection;
		private var timer:Timer;
		private var _connnectionName:String;
		private var _isReady:Boolean = false;
		
		public function LocalConnectionChecker(connectionName:String) 
		{
			_connnectionName = connectionName;
			
			connection = new LocalConnection();
			connection.addEventListener(StatusEvent.STATUS, onStatus);
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onStatus(e:StatusEvent):void 
		{
			switch (e.level) {
				case "status":
					
					if (timer) {
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER, onTimer);
						timer = null;
						
						_isReady = true;
						dispatchEvent(new DataEvent(SLAVE_READY,false,false,_connnectionName));
					}
					
					break;
				
				case "error":
					//fail
					break;
			}
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			connection.send(_connnectionName, "_slaveStatus");
		}
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
		public function go():void {
			connection.send(_connnectionName, "_go");
		}
		
		public function stop():void {
			connection.send(_connnectionName, "_stop");
		}
		
		public function callFunction(functionName:String):void {
			connection.send(_connnectionName, "_customFunction", functionName);
		}
	}

}