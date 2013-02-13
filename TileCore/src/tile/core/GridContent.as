package tile.core
{
	public final class GridContent
	{
		public var layerID:String;
		public var tileID:String;
		
		public function GridContent(layerID:String, tileID:String)
		{
			this.layerID = layerID;
			this.tileID = tileID;
		}
		
		public function toString():String
		{
			return tileID + "/" + layerID;
		}
	}
}