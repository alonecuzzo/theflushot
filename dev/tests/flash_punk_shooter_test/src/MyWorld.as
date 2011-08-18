package
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class MyWorld extends World
	{
		
		
		public function MyWorld()
		{
			add( new MyEntity() );
		}
		
		
		override public function update() :void
		{
			if( FP.random > ( 1 - 1/90 ) )
			{
				add( new Bacterium() );
			}
			
			super.update();
		}
	}
}