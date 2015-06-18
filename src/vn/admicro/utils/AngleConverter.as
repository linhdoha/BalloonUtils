package vn.admicro.utils
{
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class AngleConverter
	{
		
		public static function angle360(rot:Number):Number
		{
			var returnVal:Number;
			if (rot >= 0)
			{
				returnVal = rot % 360;
			}
			else
			{
				returnVal = 360 - Math.abs(rot) % 360;
			}
			
			return returnVal;
		}
		
		public static function angle180(rot:Number):Number
		{
			var returnVal:Number;
			var rot360:Number = angle360(rot);
			if (rot360 > 180)
			{
				returnVal = (rot360 - 360);
			}
			else
			{
				returnVal = rot360;
			}
			return returnVal;
		}
	}

}