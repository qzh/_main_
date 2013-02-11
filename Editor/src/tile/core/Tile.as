package tile.core
{
	public class Tile implements TileCodec
	{
		public var id:String;
		public var type:int;
		
		public var ix:int;
		public var iy:int;
		
		public var event:String;
		public var tilesetId:String;
		
		public function Tile()
		{
		}
		
		public function fromXML(src:XML):void
		{
			this.id = src.@id;
			this.type = parseInt(src.@type);
			
			this.ix = parseInt(src.@ix);
			this.iy = parseInt(src.@iy);
			
			this.event = src.@event;
			this.tilesetId = src.@imageId;
		}
		
		public function toXML():XML
		{
			var ret:XML = <Tile id={id} type={type} ix={ix} iy={iy} event={event} tilesetId={tilesetId}/>;
			return ret;
		}
		
		public function toTable():String
		{
			var ret:String = '\n        {type="Tile", id="@id", type=@type, ix=@ix, iy=@iy, event="@event", tilesetId="@tilesetId"}';
			
			ret = ret.replace("@id", id);
			ret = ret.replace("@type", type);
			
			ret = ret.replace("@ix", ix);
			ret = ret.replace("@iy", iy);
			
			ret = ret.replace("@event", event);
			ret = ret.replace("@tilesetId", tilesetId);
			
			return ret;
		}
	}
}