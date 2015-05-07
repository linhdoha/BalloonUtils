package vn.admicro.balloonUtils
{
	import com.sociodox.utils.Base64;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class WebScreenShot extends Loader
	{
		private var isLoadCompleted:Boolean;
		
		public function WebScreenShot()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			//
			
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("flushScreenshot", flushScreenshot);
				ExternalInterface.addCallback("render", render);
				
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.addEventListener(Event.RESIZE, onStageResize);
				
				isLoadCompleted = false;
				
				this.visible = false;
				this.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			}
			else
			{
				trace("WebScreenShot init Javascript call back failed!");
			}
		
		}
		
		private function onLoaderComplete(e:Event):void
		{
			isLoadCompleted = true;
			render();
		}
		
		private function onStageResize(e:Event):void
		{
			render();
		}
		
		private function render():void
		{
			if (ExternalInterface.available)
			{
				var xOffset:Number = ExternalInterface.call("getXOffset");
				var yOffset:Number = ExternalInterface.call("getYOffset");
				this.scrollRect = new Rectangle(xOffset, yOffset, stage.stageWidth, stage.stageHeight);
			}
			this.visible = true;
		}
		
		private function flushScreenshot(base64:String):void
		{
			if (base64)
			{
				base64 = base64.substring("data:image/png;base64,".length, base64.length);
				var bytes:ByteArray = Base64.decode(base64);
				this.loadBytes(bytes);
			}
		}
	}

}