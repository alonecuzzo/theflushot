package
{
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Bullet extends Entity
	{
		public function Bullet( x : Number, y : Number )
		{
			this.x = x;
			this.y = y;
			this.setHitbox( 2, 2 );
			graphic = new Image( new BitmapData( 2, 2, false, 0xffffff ) );
		}
		
		
		override public function update() :void
		{
			x += 7;
			
			super.update();
		}
	}
}