
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GANTracker.h"

// HelloWorld Layer
@interface HelloWorld : CCColorLayer <GANTrackerDelegate>
{
	NSMutableArray *_targets;
	NSMutableArray *_projectiles;
	CCSprite *player;
	int _projectilesDestroyed;
}

- (void)pauseGame;
    
@end

@interface HelloWorldScene : CCScene
{
    HelloWorld *_layer;
}
@property (nonatomic, retain) HelloWorld *layer;
@end

