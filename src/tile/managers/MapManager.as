package tile.managers
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import tile.core.Map;

	public final class MapManager
	{
		private static var _instance:MapManager;
		
		public var currentMap:Map;
		
		public function MapManager()
		{
		}
		
		public function load():void
		{
			var file:File = new File("/Users/Qizhi/Documents/flex/_main_/src/maps/Home.xml");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var string:String = stream.readUTFBytes(stream.bytesAvailable);
			var mapXML:XML = new XML(string);
			
			var map:Map = new Map();
			map.fromXML(mapXML);
			
			this.currentMap = map;
			
			trace(map.toXML());
			trace(map.toTable());
		}
		
		public static function getInstance():MapManager
		{
			if(!_instance)_instance = new MapManager();
			return _instance;
		}
	}
}