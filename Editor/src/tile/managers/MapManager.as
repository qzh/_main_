package tile.managers
{
	import editor.data.DataSource;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import tile.core.Layer;
	import tile.core.Map;
	import tile.core.Tile;
	import tile.core.TileImage;
	import tile.core.Tileset;

	public final class MapManager
	{
		private static const kDebugMap:String = "/Users/Qizhi/Documents/flex/_main_/Editor/src/maps/Home.xml";
		
		private static var _instance:MapManager;
		
		public var currentMap:Map;
		
		[Bindable]
		public var source:DataSource;
		
		public function MapManager()
		{
			source = new DataSource();
		}
		
		public function load():void
		{
			var file:File = new File(kDebugMap);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var string:String = stream.readUTFBytes(stream.bytesAvailable);
			var mapXML:XML = new XML(string);
			
			var map:Map = new Map();
			map.fromXML(mapXML);
			stream.close();
			this.currentMap = map;
		}
		
		public function save():void
		{
			var file:File = new File(kDebugMap);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			
			currentMap.layers = source.layers.source;
			currentMap.images = source.images.source;
			currentMap.tilesets = source.tilesets.source;
			
			var mapXML:XML = currentMap.toXML();
			var str:String = '<?xml version="1.0" encoding="UTF-8"?>\n' + mapXML.toXMLString();
			
			stream.writeUTFBytes(str);
			stream.close();
		}
		
		public function refreshSource():void
		{
			source.fromMap(this.currentMap);
		}
		
		public function getImageName(imageId:int):String
		{
			var arr:Array = source.images.source;
			for each(var p:TileImage in arr)
			{
				if(p.id == imageId)return p.path;
			}
			return null;
		}
		
		public function getLayers():Array
		{
			var ret:Array = [];
			var src:Array = source.layers.source;
			for each(var p:Layer in src)
			{
				ret.push(p);
			}
			return ret;
		}
		
		public function getTileSet(id:String):Tileset
		{
			var src:Array = source.tilesets.source;
			for each(var p:Tileset in src)
			{
				if(p.id == id)return p;
			}
			return null;
		}
		
		public function getLayerByID(layerId:String):Layer
		{
			var src:Array = source.layers.source;
			for each(var p:Layer in src)
			{
				if(p.id == layerId)
				{
					return p;
				}
			}
			return null;
		}
		
		public function getTileByLayer(layerId:String, tileId:String):Tile
		{
			var layer:Layer = getLayerByID(layerId);
			if(layer)
			{
				var src:Array = layer.tiles;
				for each(var p:Tile in src)
				{
					if(p.id == tileId)return p;
				}
			}
			return null;
		}
		
		public static function getInstance():MapManager
		{
			if(!_instance)_instance = new MapManager();
			return _instance;
		}
	}
}