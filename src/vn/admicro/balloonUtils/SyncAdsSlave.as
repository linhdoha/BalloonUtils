package vn.admicro.balloonUtils 
{
	import flash.display.MovieClip;
	import flash.net.LocalConnection;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SyncAdsSlave 
	{
		private var _code:String;
		private var connection:LocalConnection;
		private var _client:MovieClip;
		private var _autoSyncTimeline:Boolean;
		private var _startFrame:Object;
		
		public function SyncAdsSlave(slaveCode:String, client:MovieClip, autoSyncTimeline:Boolean = false, startFrame:Object = 2) 
		{
			_code = slaveCode;
			_client = client;
			_autoSyncTimeline = autoSyncTimeline;
			_startFrame = startFrame;
			
			if (_autoSyncTimeline) {
				_client.stop();
			}
			
			connection = new LocalConnection();
			connection.client = this;
			connection.connect(_code);
		}
		
		public function _slaveStatus():void {
			//
		}
		
		public function _go():void {
			_client.gotoAndPlay(_startFrame);
		}
		
		public function _stop():void {
			_client.stop();
		}
		
		public function _customFunction(functionName:String, ... args):void {
			_client[functionName](args);
		}
	}

}