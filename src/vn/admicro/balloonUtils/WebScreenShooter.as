package vn.admicro.balloonUtils
{
	import com.sociodox.utils.Base64;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class WebScreenShooter extends EventDispatcher
	{
		public static const RECEIVED:String = "received";
		private var _bytes:ByteArray;
		
		public function WebScreenShooter()
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("flushScreenshot", flushScreenshot);
			}
			else
			{
				trace("Init Javascript call back failed!");
			}
		}
		
		private function flushScreenshot(base64:String):void
		{
			if (base64)
			{
				base64 = base64.substring("data:image/png;base64,".length, base64.length);
				_bytes = Base64.decode(base64);
				dispatchEvent(new Event(RECEIVED));
			}
		}
		
		public function get bytes():ByteArray 
		{
			return _bytes;
		}
	}

}