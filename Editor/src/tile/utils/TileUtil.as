package tile.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import tile.core.Map;

	public final class TileUtil
	{
		public function TileUtil()
		{
		}
		
		public static function drawGridImage(map:Map):Bitmap
		{
			var shape:flash.display.Sprite = new flash.display.Sprite();
			
			TileUtil.drawGrid(shape.graphics, map.gridSize, map.width, map.height);
			
			for(var i:int = 0; i < map.width; i++)
			{
				for(var j:int = 0; j < map.height; j++)
				{
					var label:TextField = new TextField();
					label.textColor = 0;
					label.selectable = false;
					label.text = i + "," + j;
					label.y = j * map.gridSize + (map.gridSize - label.textWidth)/2;
					label.x = i * map.gridSize + (map.gridSize - label.textHeight)/2;
					shape.addChild(label);
				}
			}
			
			
			var w:int = map.gridSize * map.width;
			var h:int = map.gridSize * map.height;
			
			var bmd:BitmapData = new BitmapData(w+1, h+1);
			bmd.draw(shape);
			
			return new Bitmap(bmd);
		}
		
		public static function drawGrid(g:Graphics, gridSize:int, width:int, height:int):void
		{
			var w:int = gridSize * width;
			var h:int = gridSize * height;
			
			g.lineStyle(1, 0x0, 0.3);
			for(var i:int = 0; i <= width; i++)
			{
				var px:int = gridSize*i;
				g.moveTo(px, 0);
				g.lineTo(px, h);
			}
			for(var j:int = 0; j <= height; j++)
			{
				var py:int = gridSize*j;
				g.moveTo(0, py);
				g.lineTo(w, py);
			}
		}
	}
}