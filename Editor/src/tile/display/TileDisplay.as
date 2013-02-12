package tile.display
{
	import flash.events.EventDispatcher;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import tile.core.Map;
	import tile.core.Tile;
	import tile.core.Tileset;
	import tile.managers.MapManager;
	import tile.managers.ResourceManager;
	
	public class TileDisplay extends EventDispatcher
	{
		public var tileset:Tileset;
		public var tileData:Tile;
		public var sprite:Image;
		
		public var layerID:String;
		
		public function TileDisplay(t:Tile, layerID:String)
		{
			this.layerID = layerID;
			this.tileData = t;
			this.tileset = MapManager.getInstance().getTileSet(t.tilesetId);
			
			var texture:Texture = ResourceManager.getInstance().assetManager.getTexture(tileset.texture);
			sprite = new Image(texture);
		}
		
		public function update():void
		{
			var map:Map = MapManager.getInstance().currentMap;
			sprite.x = map.gridSize * tileData.ix;
			sprite.y = map.gridSize * tileData.iy;
		}
	}
}