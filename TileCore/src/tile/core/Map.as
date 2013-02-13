package tile.core
{
	public class Map implements TileCodec
	{
		public var gridSize:int;
		public var width:int;
		public var height:int;
		
		public var images:Array;
		public var tilesets:Array;
		public var layers:Array;
		
		public function Map()
		{
			this.images = [];
			this.tilesets = [];
			this.layers = [];
		}
		
		public function sortForRenderer():void
		{
			layers.sortOn("z", Array.NUMERIC);
		}
		
		public function fromXML(src:XML):void
		{
			this.images = [];
			this.layers = [];
			this.tilesets = [];
			
			this.gridSize = parseInt(src.@gridSize);
			this.width = parseInt(src.@width);
			this.height = parseInt(src.@height);
			
			var imgList:XMLList = src.Image;
			for each(var imgXml:XML in imgList)
			{
				var img:TileImage = new TileImage();
				img.fromXML(imgXml);
				this.images.push(img);
			}
			
			var setList:XMLList = src.Tileset;
			for each(var setXML:XML in setList)
			{
				var tileset:Tileset = new Tileset();
				tileset.fromXML(setXML);
				this.tilesets.push(tileset);
			}
			
			var layerList:XMLList = src.Layer;
			for each(var layerXML:XML in layerList)
			{
				var layer:Layer = new Layer();
				layer.fromXML(layerXML);
				this.layers.push(layer);
			}
		}
		
		public function toXML():XML
		{
			var ret:XML = <Map gridSize={gridSize} width={width} height={height}/>;
			for each(var img:TileImage in this.images)
			{
				ret.appendChild(img.toXML());
			}
			
			for each(var st:Tileset in this.tilesets)
			{
				ret.appendChild(st.toXML());
			}
			
			for each(var layer:Layer in this.layers)
			{
				ret.appendChild(layer.toXML());
			}
			
			return ret;
		}
		
		public function toTable():String
		{
			var ret:String = '{type="Map", gridSize=@gridSize, width=@width, height=@height, \n images={@images \n }, \n tilesets={@tilesets \n } \n layers={@layers \n } \n}';
			
			var imagesTable:Array = [];
			for each(var img:TileImage in this.images)
			{
				imagesTable.push(img.toTable());
			}
			
			var tilesetTable:Array = [];
			for each(var st:Tileset in this.tilesets)
			{
				tilesetTable.push(st.toTable());
			}
			
			var layersTable:Array = [];
			for each(var layer:Layer in this.layers)
			{
				layersTable.push(layer.toTable());
			}
			
			ret = ret.replace("@gridSize", gridSize);
			ret = ret.replace("@width", width);
			ret = ret.replace("@height", height);
			
			ret = ret.replace("@images", imagesTable.join(","));
			ret = ret.replace("@tilesets", tilesetTable.join(","));
			ret = ret.replace("@layers", layersTable.join(","));
			
			return ret;
		}
	}
}