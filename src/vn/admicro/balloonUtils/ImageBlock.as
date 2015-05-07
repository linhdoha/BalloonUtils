package vn.admicro.balloonUtils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class ImageBlock extends Sprite
	{
		private var _source:DisplayObject;
		private var _clipRect:Rectangle;
		private var _bitmap:Bitmap = new Bitmap();
		private var _originW:Number;
		private var _originH:Number;
		
		public function ImageBlock()
		{
			super();
			addChild(_bitmap);
			
			_originW = this.width;
			_originH = this.height;
		}
		
		public function set source(src:DisplayObject):void
		{
			_source = src;
			_clipRect = new Rectangle(this.x - _source.x, this.y - _source.y, _originW, _originH);
		}
		
		public function draw():void
		{
			var bitmapDataTemp:BitmapData = new BitmapData(_clipRect.width, _clipRect.height, true, 0x00000000);
			var matrixTemp:Matrix = new Matrix(1, 0, 0, 1, -_clipRect.x, -_clipRect.y);
			bitmapDataTemp.drawWithQuality(_source, matrixTemp, null, null, null, false, StageQuality.BEST);
			_bitmap.bitmapData = bitmapDataTemp;
		}
	}

}