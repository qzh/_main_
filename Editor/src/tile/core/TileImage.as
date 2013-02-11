package tile.core
{
	public final class TileImage implements TileCodec
	{
		public var id:int;
		public var path:String;
		
		public function TileImage()
		{
		}
		
		public function fromXML(src:XML):void
		{
			this.id = parseInt(src.@id);
			this.path = src.@path;
		}
		
		public function toXML():XML
		{
			var ret:XML = <Image id={id} path={path}/>;
			return ret;
		}
		
		public function toTable():String
		{
			var ret:String = '\n  {type="Image", id=@id, path="@path"}';
			
			ret = ret.replace("@id", id);
			ret = ret.replace("@path", path);
			
			return ret;
		}
	}
}