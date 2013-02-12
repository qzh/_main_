package
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import tile.math.Nurbs;
	
	public class HelloTest extends Sprite
	{
		public function HelloTest()
		{
			var cp:Vector.<Vector3D> = new Vector.<Vector3D>();
			cp.push(new Vector3D(100, 100));
			cp.push(new Vector3D(200, 100));
			cp.push(new Vector3D(300, 100));
			cp.push(new Vector3D(400, 100));
			cp.push(new Vector3D(450, 100));
			cp.push(new Vector3D(500, 100));
			cp.push(new Vector3D(550, 100));
			var out:Vector3D = Nurbs.nurbs(0.3, cp);
		}
	}
}