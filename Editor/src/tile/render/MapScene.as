package tile.render
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import tile.core.Map;
	import tile.managers.Director;
	import tile.managers.MapManager;
	import tile.utils.TileUtil;

	public class MapScene extends Scene
	{
		private var gridImage:Image;
		private var map:Map;
		
		public var mapWidth:int;
		public var mapHeight:int;
		
		private var topRight:int;
		private var bottomLeft:int;
		
		private var container:Sprite;
		
		public function MapScene()
		{
			super();
		}
		
		override public function onEnter():void
		{
			super.onEnter();
			
			this.map = MapManager.getInstance().currentMap;
			
			var w:int = map.gridSize * map.width;
			var h:int = map.gridSize * map.height;
			
			this.mapWidth = w;
			this.mapHeight = h;
			
			this.topRight = -this.mapWidth + Director.getInstance().screenWidth;
			this.bottomLeft = -this.mapHeight + Director.getInstance().screenHeight;
			
			this.container = new Sprite();
			this.addChild(container);
			
			gridImage = Image.fromBitmap(TileUtil.drawGridImage(this.map), false, 1);
			container.addChild(gridImage);
			
			container.addEventListener(TouchEvent.TOUCH, onTouchStart);
		}
		
		override public function onExit():void
		{
			super.onExit();
			container.removeEventListener(TouchEvent.TOUCH, onTouchStart);
		}
		
		private function onTouchStart(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 1)
			{
				// one finger touching -> move
				var delta:Point = touches[0].getMovement(parent);
				
				var ex:Number = container.x + delta.x;
				if(ex >= 0.0000001)ex= 0;
				if(ex <= topRight)ex = topRight;
				container.x = ex;
				
				var ey:Number = container.y + delta.y;
				if(ey >= 0.0000001)ey = 0;
				if(ey <= bottomLeft)ey = bottomLeft;
				container.y = ey;
			} 
		}
		
	}
}