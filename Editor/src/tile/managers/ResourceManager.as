package tile.managers
{
	import editor.data.TilesetX;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
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
			
			var isComplete:Boolean = false;
			function onLoadAssets(r:Number):void
			{
				if(r >= 1 && !isComplete)
				{
					isComplete = true;
					onComplete();
					
					var tilesets:Array = MapManager.getInstance().source.tilesets.source;
					for each(var p:TilesetX in tilesets)
					{
						var imageName:String = MapManager.getInstance().getImageName(p.imageId);
						var bmd:BitmapSet = getBitmapData(imageName, p.texture);
						p.bitmap = bmd.bitmap;
					}
				}
			}
			assetManager.loadQueue(onLoadAssets);
		}
		
		public function getBitmapData(textureName:String, subName:String):BitmapSet
		{
			var store:BitmapStore = assetManager.bitmapStore[textureName];
			if(store)
			{
				return store.getAtlas(subName);
			}
			return null;
		}
		
		public function getAllBitmapList(textureName:String):ArrayCollection
		{
			var ret:ArrayCollection = new ArrayCollection();
			var store:BitmapStore = assetManager.bitmapStore[textureName];
			if(store)
			{
				for each(var sets:BitmapSet in store.atlasMap)
				{
					ret.addItem(sets);
				}
			}
			return ret;
		}
		
		private static var _instance:ResourceManager;
		public static function getInstance():ResourceManager
		{
			if(!_instance)_instance = new ResourceManager();
			return _instance;
		}
	}
}