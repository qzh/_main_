package tile.managers
{
	import flash.display.BitmapData;

	[Bindable]
	public final class BitmapSet
	{
		public var label:String;
		public var bitmap:BitmapData;
		
		public function BitmapSet(label:String, bmd:BitmapData)
		{
			this.label = label;
			this.bitmap = bmd;
		}
	}
}