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
	import tile.display.LayerDisplay;
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
				
				ld.updateGrid(gridInfo);
			}
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
				trace(dx, dy, ret);
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