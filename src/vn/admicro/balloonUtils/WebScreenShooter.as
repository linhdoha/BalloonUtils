package vn.admicro.balloonUtils
{
	import com.sociodox.utils.Base64;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class WebScreenShooter extends EventDispatcher
	{
		public static const RECEIVED:String = "received";
		public static const LOADER_COMPLETE:String = "loadComplete";
		public static const RENDER:String = "render";
		
		private var _bytes:ByteArray;
		private var _loader:Loader;
		private var _holder:MovieClip;
		
		public function WebScreenShooter(holder:MovieClip)
		{
			_holder = holder;
			
			_loader = new Loader();
			_loader.visible = false;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			_holder.addChild(_loader);
			
			_holder.stage.addEventListener(Event.RESIZE, onStageResize);
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("flushScreenshot", flushScreenshot);
				ExternalInterface.addCallback("render", render);
			}
			else
			{
				trace("Init Javascript call back failed!");
			}
		}
		
		function onStageResize(e:Event):void
		{
			render();
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			_loader.visible = true;
			render();
			dispatchEvent(new Event(LOADER_COMPLETE));
		}
		
		private function flushScreenshot(base64:String):void
		{
			if (base64)
			{
				base64 = base64.substring("data:image/png;base64,".length, base64.length);
				_bytes = Base64.decode(base64);
				
				_loader.loadBytes(_bytes);
				
				dispatchEvent(new Event(RECEIVED));
			}
		}
		
		private function render():void {
			if (ExternalInterface.available)
			{
				//full
				//var xOffset:Number = ExternalInterface.call("getXOffset");
				//var yOffset:Number = ExternalInterface.call("getYOffset");
				//_loader.scrollRect = new Rectangle(xOffset,yOffset,_holder.stage.stageWidth,_holder.stage.stageHeight);
				
				//width 1000px
				var yOffset:Number = ExternalInterface.call("getYOffset");
				_loader.scrollRect = new Rectangle((_holder.stage.stageWidth - 1000) / 2, yOffset, 1000, _holder.stage.stageHeight);
				_loader.x = (_holder.stage.stageWidth-1000)/2-10;
			}
		}
		
		public function get bytes():ByteArray 
		{
			return _bytes;
		}
		
		public function expandBanner():void {
			if (ExternalInterface.available)
			{
				ExternalInterface.call("expandBanner");
				new MouseEvent(MouseEvent.MOUSE_MOVE).updateAfterEvent();
			}
		}
		
		public function collapseBanner():void {
			if (ExternalInterface.available)
			{
				ExternalInterface.call("collapseBanner");
			}
		}
	}

}