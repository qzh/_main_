package tile.core
{
	public class Tileset implements TileCodec
	{
		public var id:String;
		public var width:int;
		public var height:int;
		public var imageId:String;
		public var texture:String;
		
		public function Tileset()
		{
		}
		
		public function fromXML(src:XML):void
		{
			this.id = src.@id;
			this.width = parseInt(src.@width);
			this.height = parseInt(src.@height);
			this.imageId = src.@imageId;
			this.texture = src.@texture;
		}
		
		public function toXML():XML
		{
			var ret:XML = <Tileset id={id} width={width} height={height} imageId={imageId} texture={texture}/>;
			return ret;
		}
		
		public function toTable():String
		{
			var ret:String = '\n  {type="Tileset", id="@id", width=@width, height=@height, imageId="@imageId", texture="@texture"}';
			
			ret = ret.replace("@id", id);
			ret = ret.replace("@width", width);
			ret = ret.replace("@height", height);
			ret = ret.replace("@imageId", imageId);
			ret = ret.replace("@texture", texture);
			
			return ret;
		}
	}
}