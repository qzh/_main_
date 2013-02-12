package tile.display
{
	import flash.events.EventDispatcher;
	
	import starling.display.Sprite;
	
	import tile.core.Layer;
	import tile.core.MapGrids;
	import tile.core.Tile;

	public class LayerDisplay extends EventDispatcher
	{
		public var layer:Layer;
		public var container:Sprite;
		
		private var tiles:Array;
		
		public function LayerDisplay(layer:Layer)
		{
			this.tiles = [];
			this.layer = layer;
			this.container = new Sprite();
			
			this.buildLayer();
		}
		
		private function buildLayer():void
		{
			var list:Array = layer.tiles;
			for each(var p:Tile in list)
			{
				addTile(p);
			}
		}
		
		public function updateGridInfo(info:MapGrids):void
		{
			for each(var dp:TileDisplay in tiles)
			{
				info.addTile(dp);
			}
		}
		
		public function getTileDisplay(tileId:String):TileDisplay
		{
			for each(var dp:TileDisplay in tiles)
			{
				if(dp.tileData.id == tileId)
					return dp;
			}
			return null;
		}
		
		public function addTile(p:Tile):TileDisplay
		{
			var dp:TileDisplay = new TileDisplay(p, layer.id);
			this.tiles.push(dp);
			this.container.addChild(dp.sprite);
			dp.update();
			return dp;
		}
		
		public function removeTile(td:TileDisplay):void
		{
			var t:Tile = td.tileData;
			var index:int = -1;
			for(var i:int = 0; i < tiles.length; i++)
			{
				var p:TileDisplay = tiles[i] as TileDisplay;
				if(p.tileData.id == t.id)
				{
					index = i;
					break;
				}
			}
			if(index != -1)
			{
				tiles.splice(index, 1);
			}
			
			if(td.sprite && td.sprite.parent)td.sprite.parent.removeChild(td.sprite);
		}
	}
}