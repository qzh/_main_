package tile.core
{
	import flash.utils.Dictionary;
	
	import tile.display.TileDisplay;
	import tile.managers.MapManager;

	public final class MapGrids
	{
		private var infoMap:Dictionary;
		
		private var width:int;
		private var height:int;
		
		public function MapGrids(map:Map)
		{
			this.width = map.width;
			this.height = map.height;
			
			infoMap = new Dictionary();
		}
		
		public function addTile(t:TileDisplay):void
		{
			var startX:int = t.tileData.ix;
			var startY:int = t.tileData.iy;
			var endX:int = startX + t.tileset.width;
			var endY:int = startY + t.tileset.height;
			
			for(var i:int = startX; i < endX; i++)
			{
				for(var j:int = startY; j < endY; j++)
				{
					var key:String = this.getKey(i, j);
					var info:Vector.<GridContent> = infoMap[key] as Vector.<GridContent>;
					if(!info)
					{
						info = new Vector.<GridContent>();
						infoMap[key] = info;
					}
					if(getGridContentIndex(t.tileset.id, info) == -1)
					{
						info.push(new GridContent(t.layerID, t.tileset.id));
					}
				}
			}
		}
		
		public function removeTile(t:TileDisplay):void
		{
			var startX:int = t.tileData.ix;
			var startY:int = t.tileData.iy;
			var endX:int = startX + t.tileset.width;
			var endY:int = startY + t.tileset.height;
			
			for(var i:int = startX; i < endX; i++)
			{
				for(var j:int = startY; j < endY; j++)
				{
					var key:String = this.getKey(i, j);
					var info:Vector.<GridContent> = infoMap[key] as Vector.<GridContent>;
					if(info)
					{
						var index:int = getGridContentIndex(t.tileset.id, info);
						if(index != -1)info.splice(index, 1);
					}
				}
			}
		}
		
		private static function getGridContentIndex(tileID:String, list:Vector.<GridContent>):int
		{
			for(var i:int = 0; i < list.length; i++)
			{
				if(list[i].tileID == tileID)return i;
			}
			return -1;
		}
		
		public function getTileID(x:int, y:int):Vector.<GridContent>
		{
			var key:String = this.getKey(x, y);
			return infoMap[key] as Vector.<GridContent>;
		}
		
		public function getTileList(x:int, y:int, layerId:String = null):Vector.<Tile>
		{
			var ret:Vector.<Tile> = new Vector.<Tile>();
			
			var key:String = this.getKey(x, y);
			var idList:Vector.<GridContent> = infoMap[key] as Vector.<GridContent>;
			for each(var tid:GridContent in idList)
			{
				if(layerId)
				{
					if(layerId == tid.layerID)
					{
						var t1:Tile = MapManager.getInstance().getTileByLayer(layerId, tid.tileID);
						if(t1)ret.push(t1);
					}
				}
				else
				{
					var t2:Tile = MapManager.getInstance().getTileByLayer(layerId, tid.tileID);
					if(t2)ret.push(t2);
				}
			}
			
			return ret;
		}
		
		public function getKey(x:int, y:int):String
		{
			return x + "-" + y;
		}
	}
}