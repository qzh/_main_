package editor.data
{
	import flash.display.BitmapData;
	
	import tile.core.Tileset;
	
	[Bindable]
	public class TilesetX extends Tileset
	{
		public var bitmap:BitmapData;
		
		public function TilesetX(src:Tileset = null)
		{
			super();
			
			if(src)
			{
				this.id = src.id;
				this.width = src.width;
				this.height = src.height;
				this.imageId = src.imageId;
				this.texture = src.texture;
			}
		}
	}
}