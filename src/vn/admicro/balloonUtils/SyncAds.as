package vn.admicro.balloonUtils
{
	import flash.display.MovieClip;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SyncAds
	{
		private var _isMaster:Boolean;
		private var _code:String;
		private var _frameToStart:Object;
		private var _client:MovieClip;
		
		private var timer:Timer;
		private var connection:LocalConnection;
		
		public function SyncAds(bannerCode:String, isMaster:Boolean, client:MovieClip, frameToStart:Object = 2)
		{
			_code = bannerCode;
			_isMaster = isMaster;
			_client = client;
			_frameToStart = frameToStart;
			
			initialize();
		}
		
		private function initialize():void
		{
			_client.stop();
			
			connection = new LocalConnection();
			if (_isMaster)
			{
				connection.addEventListener(StatusEvent.STATUS, onConnectionStatus);
				timer = new Timer(10);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			} else {
				connection.client = this;
				connection.connect(_code);
			}
		}
		
		private function onConnectionStatus(e:StatusEvent):void 
		{
			switch (e.level) {
				case "status":
					if (timer) {
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER, onTimer);
						timer = null;
						connection.send(_code, "go");
						go();
					}
					
					
					break;
				case "error":
					trace("LocalConnection.send() failed");
					break;
			}
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			connection.send(_code,"slaveStatus");
		}
		
		public function go():void {
			_client.gotoAndPlay(_frameToStart);
		}
		
		public function replay():void {
			_client.gotoAndPlay(_frameToStart);
			connection.send(_code, "go");
		}
		
		public function slaveStatus():void {
			trace("slaveStatus called!");
		}
		
	}

}