package tile.core
{
	public interface TileCodec
	{
		function fromXML(src:XML):void;
		function toXML():XML;
		
		function toTable():String;
	}
}