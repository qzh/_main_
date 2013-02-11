package tile.managers
{
	import editor.data.DataSource;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import tile.core.Map;

	public final class MapManager
	{
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
			var file:File = new File("/Users/Qizhi/Documents/flex/_main_/Editor/src/maps/Home.xml");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var string:String = stream.readUTFBytes(stream.bytesAvailable);
			var mapXML:XML = new XML(string);
			
			var map:Map = new Map();
			map.fromXML(mapXML);
			
			this.currentMap = map;
		}
		
		public function refreshSource():void
		{
			source.fromMap(this.currentMap);
		}
		
		public static function getInstance():MapManager
		{
			if(!_instance)_instance = new MapManager();
			return _instance;
		}
	}
}