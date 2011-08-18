package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class MyEntity extends Entity
	{
		
		[Embed(source = 'assets/player.png')]
		private const PLAYER : Class;
		
		public function MyEntity()
		{
			graphic = new Image( PLAYER );
			x = 5;	
		}
		
		override public function update() :void 
		{
			if ( Input.check( Key.LEFT ) )
			{
				//x -= 5;
			}
			
			if ( Input.check( Key.RIGHT ) )
			{
				//x += 5;
			}
			
			if ( Input.check( Key.UP ) )
			{
				y -= 5;
			}
			
			if ( Input.check( Key.DOWN ) )
			{
				y += 5;
			}
			
			
			if( Input.check( Key.SPACE ) )
			{
			 	this.world.add( new Bullet( x + 30, y + 15 ) );
			}
			
			super.update();
		}
	}
}