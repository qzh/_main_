package tile.core
{
	public class Layer implements TileCodec
	{
		public var id:String;
		public var z:int;
		public var visible:int;
		
		public var tiles:Array;
		
		public function Layer()
		{
			this.tiles = [];
		}
		
		public function removeTile(t:Tile):void
		{
			var index:int = -1;
			for(var i:int = 0; i < tiles.length; i++)
			{
				var p:Tile = tiles[i] as Tile;
				if(p.id == t.id)
				{
					index = i;
					break;
				}
			}
			if(index != -1)
			{
				tiles.splice(index, 1);
			}
		}
		
		public function fromXML(src:XML):void
		{
			this.tiles = [];
			
			this.id = src.@id;
			this.z = parseInt(src.@z);
			this.visible = parseInt(src.@visible);
			
			var tileList:XMLList = src.Tile;
			for each(var tileXML:XML in tileList)
			{
				var p:Tile = new Tile();
				p.fromXML(tileXML);
				this.tiles.push(p);
			}
		}
		
		public function toXML():XML
		{
			var ret:XML = <Layer id={id} z={z} visible={visible}/>;
			for each(var t:Tile in this.tiles)
			{
				ret.appendChild(t.toXML());
			}
			return ret;
		}
		
		public function toTable():String
		{
			var ret:String = '\n    {type="Layer", id="@id", z=@z, v=@v tiles={@tiles \n      }\n    }';
			
			ret = ret.replace("@id", id);
			ret = ret.replace("@z", z);
			ret = ret.replace("@v", visible);
			
			var tileTable:Array = [];
			for each(var t:Tile in this.tiles)
			{
				tileTable.push(t.toTable());
			}
			ret = ret.replace("@tiles", tileTable.join(","));
			
			return ret;
		}
	}
}