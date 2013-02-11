package tile.managers
{
	import editor.data.BitmapSet;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public final class BitmapStore
	{
		public var rawBitmap:BitmapData;
		
		public var atlasMap:Dictionary;
		
		public function BitmapStore(bitmap:Bitmap)
		{
			this.rawBitmap = bitmap.bitmapData;
			atlasMap = new Dictionary(); 
		}
		
		public function getAtlas(name:String):BitmapSet
		{
			return atlasMap[name];
		}
		
		public function updateAtlas(atlas:XML):void
		{
			var list:XMLList = atlas.SubTexture;
			for each(var sub:XML in list)
			{
				var name:String = sub.@name;
				var x:int = parseInt(sub.@x);
				var y:int = parseInt(sub.@y);
				var width:int = parseInt(sub.@width);
				var height:int = parseInt(sub.@height);
				
				var bmd:BitmapData = new BitmapData(width, height);
				bmd.copyPixels(rawBitmap, new Rectangle(x, y, width, height), new Point());
				atlasMap[name] = new BitmapSet(name, bmd);
			}
		}
	}
}