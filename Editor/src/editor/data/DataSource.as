package editor.data
{
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	import tile.core.Layer;
	import tile.core.Map;
	import tile.core.TileImage;
	import tile.core.Tileset;

	public class DataSource
	{
		[Bindable]
		public var layers:ArrayCollection;
		
		[Bindable]
		public var images:ArrayCollection;
		
		[Bindable]
		public var tilesets:ArrayCollection;
		
		public function DataSource()
		{
			layers = new ArrayCollection();
			images = new ArrayCollection();
			tilesets = new ArrayCollection();
			
			var layerSort:Sort = new Sort();
			layerSort.fields = [new SortField("z", true, true)];
			layers.sort = layerSort;
		}
		
		public function fromMap(map:Map):void
		{
			layers.removeAll();
			images.removeAll();
			tilesets.removeAll();
			
			for each(var l:Layer in map.layers)
			{
				layers.addItem(l);
			}
			for each(var im:TileImage in map.images)
			{
				images.addItem(im);
			}
			for each(var ts:Tileset in map.tilesets)
			{
				tilesets.addItem(ts);
			}
			
			layers.refresh();
		}
		
		public function removeItem(item:Object, list:ArrayCollection):void
		{
			var index:int = list.getItemIndex(item);
			if(index != -1)list.removeItemAt(index);
		}
		
	}
}