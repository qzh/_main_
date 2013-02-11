package tile.managers
{
	import starling.utils.AssetManager;
	
	import tile.core.Map;
	import tile.core.TileImage;

	public final class ResourceManager
	{
		public var assetManager:AssetManager;
		
		public function ResourceManager()
		{
			assetManager = new AssetManager();
		}
		
		public function load(map:Map, onComplete:Function):void
		{
			var images:Array = map.images;
			var array:Array = [];
			for each(var img:TileImage in images)
			{
				var path:String = img.path;
				array.push("maps/"+path+".png");
				array.push("maps/"+path+".xml");
			}
			assetManager.enqueue(array);
			
			function onLoadAssets(r:Number):void
			{
				if(r >= 1)onComplete();
			}
			assetManager.loadQueue(onLoadAssets);
		}
		
		private static var _instance:ResourceManager;
		public static function getInstance():ResourceManager
		{
			if(!_instance)_instance = new ResourceManager();
			return _instance;
		}
	}
}