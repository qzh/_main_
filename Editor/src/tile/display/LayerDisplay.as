package tile.display
{
	import flash.events.EventDispatcher;
	
	import starling.display.Sprite;
	
	import tile.core.MapGrids;
	import tile.core.Layer;
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
				var dp:TileDisplay = new TileDisplay(p, layer.id);
				this.tiles.push(dp);
				this.container.addChild(dp.sprite);
				dp.update();
			}
		}
		
		public function updateGrid(info:MapGrids):void
		{
			for each(var dp:TileDisplay in tiles)
			{
				info.addTile(dp);
			}
		}
	}
}