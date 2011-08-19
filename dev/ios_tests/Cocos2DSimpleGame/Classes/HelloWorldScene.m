//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"

@implementation HelloWorldScene
@synthesize layer = _layer;

- (id)init {

    if ((self = [super init])) {
        self.layer = [HelloWorld node];
        [self addChild:_layer];
    }
	
	return self;
}

- (void)dealloc {
    self.layer = nil;
    [super dealloc];
}

@end


// HelloWorld implementation
@implementation HelloWorld

-(void)spriteMoveFinished:(id)sender {

	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
		
		//GameOverScene *gameOverScene = [GameOverScene node];
//		[gameOverScene.layer.label setString:@"You Lose :["];
//		[[CCDirector sharedDirector] replaceScene:gameOverScene];
		
	} else if (sprite.tag == 2) { // projectile
		[_projectiles removeObject:sprite];
	}
	
}

-(void)addTarget {

	CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[_targets addObject:target];
	
}

-(void)gameLogic:(ccTime)dt {
	
	[self addTarget];
	
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {

		// Enable touch events
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
		
		// Get the dimensions of the window for calculation purposes
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		// Add the player to the middle of the screen along the y-axis, 
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
		player = [CCSprite spriteWithFile:@"Player.png" rect:CGRectMake(0, 0, 27, 40)];
		player.position = ccp(player.contentSize.width/2, winSize.height/2);
		[self addChild:player];
		
		// Call game logic about every second
		[self schedule:@selector(gameLogic:) interval:1.0];
		[self schedule:@selector(update:)];
		
		// Start up the background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
		
	}
	return self;
}

#define kHeroMovementAction 1
#define kPlayerSpeed 100
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // use the running scene to grab the appropriate game layer by it's tag
    //GameLayer *layer = (GameLayer *)[[[CCDirector sharedDirector] runningScene] getChildByTag:kTagGameLayer];
    // grab the player sprite from that layer using it's tag
    //CCSprite *playerSprite = (CCSprite *)[layer getChildByTag:kTagSpritePlayer];
	CCSprite *playerSprite = player;

	
    float destX, destY;
    BOOL shouldMove = NO;
	
    float currentX = playerSprite.position.x;
    float currentY = playerSprite.position.y;
	
//	printf("acceleration-x: %g", acceleration.x );
//	printf("\n");
	printf("acceleration-y: %g", acceleration.y );
	printf("\n");
//	printf("acceleration-z: %g", acceleration.z );
//	printf("\n");
//	printf("\n");
	
    if(acceleration.y > 0.0) {  // tilting the device upwards
		destX = currentX - (acceleration.y * kPlayerSpeed);
		//destX = playerSprite.position.x;
        destY = currentY - (acceleration.y * kPlayerSpeed);
		printf("should be moving down!");
		printf("destY: %f", destY);
        shouldMove = YES;
    } else if (acceleration.y < 0.0) {  // tilting the device downwards
		destX = currentX - (acceleration.y * kPlayerSpeed);
		//destX = playerSprite.position.x;
        destY = currentY - (acceleration.y * kPlayerSpeed);
		printf("should be moving up!");
		printf("destY: %f", destY);
        shouldMove = YES;
    } else {
		destX = currentX;
		destY = currentY;
	}
	
//	if(acceleration.y < -0.25) {  // tilting the device to the right
//		destX = currentX - (acceleration.y * kPlayerSpeed);
//        destY = currentY + (acceleration.x * kPlayerSpeed);
//        shouldMove = YES;
//    } else if (acceleration.y > 0.25) {  // tilting the device to the left
//		destX = currentX - (acceleration.y * kPlayerSpeed);
//        destY = currentY + (acceleration.x * kPlayerSpeed);
//        shouldMove = YES;
//    } else {
//        destX = currentX;
//        destY = currentY;
//    }
	
    if(shouldMove) {
        CGSize wins = [[CCDirector sharedDirector] winSize];
       // // ensure we aren't moving out of bounds     
//       if(destY < 30 || destY > wins.height - 100) {
//            // do nothing
//		   printf("doing nothing!!");
//        } else {
			 printf("move command caught!!");
            CCAction *action = [CCMoveTo actionWithDuration:1 position: CGPointMake(currentX, destY)];
            [action setTag:kHeroMovementAction];
            [playerSprite runAction:action];
		//}
    } else {
        // should stop
        [playerSprite stopActionByTag:kHeroMovementAction];
    }
	
}

- (void)update:(ccTime)dt {

	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (CCSprite *projectile in _projectiles) {
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);

		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		for (CCSprite *target in _targets) {
			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
	
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
				[targetsToDelete addObject:target];				
			}						
		}
		
		for (CCSprite *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];									
			_projectilesDestroyed++;
			if (_projectilesDestroyed > 30) {
				GameOverScene *gameOverScene = [GameOverScene node];
				[gameOverScene.layer.label setString:@"You Win!"];
				[[CCDirector sharedDirector] replaceScene:gameOverScene];
			}
		}
		
		if (targetsToDelete.count > 0) {
			[projectilesToDelete addObject:projectile];
		}
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
}

- (void)pauseGame {
    NSLog(@"Paused!");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	// Choose one of the touches to work with
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	// Set up initial location of projectile
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png" rect:CGRectMake(0, 0, 20, 20)];
	projectile.position = ccp(20, winSize.height/2);
	
	// Determine offset of location to projectile
	int offX = location.x - projectile.position.x;
	int offY = location.y - projectile.position.y;
	
	// Bail out if we are shooting down or backwards
	if (offX <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];

	// Play a sound!
	[[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
	
	// Determine where we wish to shoot the projectile to
	int realX = winSize.width + (projectile.contentSize.width/2);
	float ratio = (float) offY / (float) offX;
	int realY = (realX * ratio) + projectile.position.y;
	CGPoint realDest = ccp(realX, realY);
	
	// Determine the length of how far we're shooting
	int offRealX = realX - projectile.position.x;
	int offRealY = realY - projectile.position.y;
	float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
	float velocity = 480/1; // 480pixels/1sec
	float realMoveDuration = length/velocity;
	
	// Move projectile to actual endpoint
	[projectile runAction:[CCSequence actions:
						   [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
						   [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
						   nil]];
	
	// Add to projectiles array
	projectile.tag = 2;
	[_projectiles addObject:projectile];
	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_targets release];
	_targets = nil;
	[_projectiles release];
	_projectiles = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
