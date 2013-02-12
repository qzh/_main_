package tile.render
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import tile.core.GridContent;
	import tile.core.Layer;
	import tile.core.Map;
	import tile.core.MapGrids;
	import tile.core.Tile;
	import tile.core.Tileset;
	import tile.display.LayerDisplay;
	import tile.display.TileDisplay;
	import tile.managers.Director;
	import tile.managers.MapManager;
	import tile.utils.TileUtil;

	public class MapScene extends Scene
	{
		private var gridImage:Image;
		
		public var mapWidth:int;
		public var mapHeight:int;
		
		private var topRight:int;
		private var bottomLeft:int;
		
		private var rootContainer:Sprite;
		private var tileContainer:Sprite;
		
		private var layerList:Array;
		private var gridInfo:MapGrids;
		
		public function MapScene()
		{
			super();
		}
		
		private var _selectedTile:TileDisplay;
		public function get selectedTile():TileDisplay
		{
			return _selectedTile;
		}
		public function set selectedTile(value:TileDisplay):void
		{
			if(_selectedTile != value)
			{
				if(_selectedTile)_selectedTile.onSelected(false);
				_selectedTile = value;
				if(_selectedTile)_selectedTile.onSelected(true);
			}
		}

		override public function onEnter():void
		{
			super.onEnter();
			
			var map:Map = MapManager.getInstance().currentMap;
			layerList = [];
			gridInfo = new MapGrids(map);
			
			var w:int = map.gridSize * map.width;
			var h:int = map.gridSize * map.height;
			
			this.mapWidth = w;
			this.mapHeight = h;
			
			this.topRight = -this.mapWidth + Director.getInstance().screenWidth;
			this.bottomLeft = -this.mapHeight + Director.getInstance().screenHeight;
			
			this.rootContainer = new Sprite();
			this.addChild(rootContainer);
			
			tileContainer = new Sprite();
			rootContainer.addChild(tileContainer);
			
			gridImage = Image.fromBitmap(TileUtil.drawGridImage(map), false, 1);
			rootContainer.addChild(gridImage);
			
			rootContainer.addEventListener(TouchEvent.TOUCH, onTouchStart);
			
			this.buildLayers();
		}
		
		override public function onExit():void
		{
			super.onExit();
			rootContainer.removeEventListener(TouchEvent.TOUCH, onTouchStart);
		}
		
		private function buildLayers():void
		{
			var layers:Array = MapManager.getInstance().getLayers();
			layers.sortOn("z", Array.NUMERIC);
			for each(var p:Layer in layers)
			{
				var ld:LayerDisplay = new LayerDisplay(p);
				tileContainer.addChild(ld.container);
				this.layerList.push(ld);
				
				ld.updateGridInfo(gridInfo);
			}
		}
		
		public function getTileDisplay(layerId:String, tileId:String):TileDisplay
		{
			for each(var ld:LayerDisplay in layerList)
			{
				if(ld.layer.id == layerId)
				{
					return ld.getTileDisplay(tileId);
				}
			}
			return null;
		}
		
		public function getLayerDisplay(layerId:String):LayerDisplay
		{
			for each(var ld:LayerDisplay in layerList)
			{
				if(ld.layer.id == layerId)
				{
					return ld;
				}
			}
			return null;
		}
		
		private function onTouchStart(e:TouchEvent):void
		{
			this.processMoveTouch(e);
			
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if(touches.length > 0)
			{
				var delta:Point = touches[0].getLocation(rootContainer);
				var map:Map = MapManager.getInstance().currentMap;
				var dx:int = delta.x / map.gridSize;
				var dy:int = delta.y / map.gridSize;
				
				var ret:Vector.<GridContent> = gridInfo.getTileID(dx, dy);
				var layer:Layer = MapManager.getInstance().currentLayer;
				var toolsMode:int = Director.getInstance().toolsMode;
				var tileDisplay:TileDisplay;
				if(ret && layer && ret.length > 0)
				{
					for each(var g:GridContent in ret)
					{
						if(g.layerID == layer.id)
						{
							tileDisplay = getTileDisplay(layer.id, g.tileID);
							break;
						}
					}
					
				}
				
				if(toolsMode == Director.kSelectTool)
				{
					this.selectedTile = tileDisplay;
				}
				else if(toolsMode == Director.kAddTileTool)
				{
					this.selectedTile = null;
					this.addTile(dx, dy);
				}
				else if(toolsMode == Director.kDelTileTool)
				{
					this.selectedTile = null;
					this.removeTile(tileDisplay);
				}
				
				trace(dx, dy, ret);
			}
		}
		
		private function removeTile(dp:TileDisplay):void
		{
			var layer:Layer = MapManager.getInstance().currentLayer;
			if(!dp || !layer)return;
			
			var ld:LayerDisplay = this.getLayerDisplay(layer.id);
			if(!ld) return;
			
			ld.removeTile(dp);
			layer.removeTile(dp.tileData);
			gridInfo.removeTile(dp);
		}
		
		private function addTile(dx:int, dy:int):void
		{
			var layer:Layer = MapManager.getInstance().currentLayer;
			var tileset:Tileset = MapManager.getInstance().currentTileset;
			if(tileset && layer)
			{
				var ld:LayerDisplay = this.getLayerDisplay(layer.id);
				if(!ld)return;
				
				var endX:int = dx + tileset.width;
				var endY:int = dy + tileset.height;
				
				var validPosition:Boolean = true;
				for(var i:int = dx; i < endX; i++)
				{
					for(var j:int = dy; j < endY; j++)
					{
						var ret:Vector.<GridContent> = gridInfo.getTileID(i, j);
						if(ret && ret.length > 0)
						{
							for each(var gd:GridContent in ret)
							{
								if(gd.layerID == layer.id)
								{
									validPosition = false;
									break;
								}
							}
						}
					}
				}
				
				if(!validPosition)return;
				
				var date:Date = new Date();
				var t:Tile = new Tile();
				t.id = date.time + "-" + int(Math.random()*10000);
				t.ix = dx;
				t.iy = dy;
				t.tilesetId = tileset.id;
				
				layer.tiles.push(t);
				gridInfo.addTile(ld.addTile(t));
			}
		}
		
		private function processMoveTouch(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 1)
			{
				// one finger touching -> move
				var delta:Point = touches[0].getMovement(parent);
				
				var ex:Number = rootContainer.x + delta.x;
				if(ex >= 0.0000001)ex= 0;
				if(ex <= topRight)ex = topRight;
				rootContainer.x = ex;
				
				var ey:Number = rootContainer.y + delta.y;
				if(ey >= 0.0000001)ey = 0;
				if(ey <= bottomLeft)ey = bottomLeft;
				rootContainer.y = ey;
			}
		}
		
	}
}