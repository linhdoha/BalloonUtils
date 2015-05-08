package vn.admicro.balloonUtils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class MouseWheelPreventer
	{
		static private var _mouseWheelTrapped:Boolean;
		
		public function MouseWheelPreventer()
		{
		
		}
		
		public static function setup(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function():void
				{
					allowBrowserScroll(false);
				});
			stage.addEventListener(Event.MOUSE_LEAVE, function():void
				{
					allowBrowserScroll(true);
				});
		}
		
		private static function allowBrowserScroll(allow:Boolean):void
		{
			createMouseWheelTrap();
			if (ExternalInterface.available)
			{
				ExternalInterface.call("allowBrowserScroll", allow);
			}
		}
		
		private static function createMouseWheelTrap():void
		{
			if (_mouseWheelTrapped)
			{
				return;
			}
			_mouseWheelTrapped = true;
			if (ExternalInterface.available)
			{
				ExternalInterface.call("eval", "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;}}if(window.addEventListener){window.addEventListener('DOMMouseScroll',wheel,false);}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);");
			}
		}
	
	}

}