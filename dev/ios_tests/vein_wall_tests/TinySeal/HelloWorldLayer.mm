//
//  HelloWorldLayer.mm
//  TinySeal
//
//  Created by Ray Wenderlich on 6/15/11.
//  Copyright Ray Wenderlich 2011. All rights reserved.
//


#import "HelloWorldLayer.h"


@implementation HelloWorldLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    // 3: Draw into the texture
    //glDisable(GL_TEXTURE_2D);
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//    float gradientAlpha = .9;    
//    CGPoint vertices[4];
//    ccColor4F colors[4];
//    int nVertices = 0;
//    
//    vertices[nVertices] = CGPointMake(0, 0);
//    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
//    vertices[nVertices] = CGPointMake(textureSize, 0);
//    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
//    vertices[nVertices] = CGPointMake(0, textureSize);
//    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
//    vertices[nVertices] = CGPointMake(textureSize, textureSize);
//    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
//    
//    glVertexPointer(2, GL_FLOAT, 0, vertices);
//    glColorPointer(4, GL_FLOAT, 0, colors);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
//    
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    glEnable(GL_TEXTURE_2D);
    
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 color2:(ccColor4F)c2 textureSize:(float)textureSize  stripes:(int)nStripes {
    
	// 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
	
	//ccColor4F bgColor = ccc4(
	
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
	
    // 3: Draw into the texture
    // We'll add this later
	
    // 4: Call CCRenderTexture:end
    [rt end];
	
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

- (ccColor4F)randomBrightColor {
    
   // while (true) {
//        float requiredBrightness = 192;
//        ccColor4B randomColor = 
//        ccc4(arc4random() % 255,
//             arc4random() % 255, 
//             arc4random() % 255, 
//             255);
//        if (randomColor.r > requiredBrightness || 
//            randomColor.g > requiredBrightness ||
//            randomColor.b > requiredBrightness) {
//            return ccc4FFromccc4B(randomColor);
//        }        
//    }
	
	//background color from game
	return ccc4FFromccc4B(ccc4(198,48,60,255));
    
}

- (void)genBackground {
    
    [_background removeFromParentAndCleanup:YES];
	
    ccColor4F bgColor = [self randomBrightColor];
    _background = [self spriteWithColor:bgColor textureSize:512];
	
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);        
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [_background.texture setTexParameters:&tp];
	
    [self addChild:_background];
	
	//ccColor4F color3 = [self randomBrightColor];
	//ccColor4F color4 = [self randomBrightColor];
	ccColor4F color3 = ccc4FFromccc4B(ccc4(32,5,7,200));
    ccColor4F color4 = ccc4FFromccc4B(ccc4(32,5,8,178));
    CCSprite *stripes = [self stripedSpriteWithColor1:color3 color2:color4 textureSize:512 stripes:4];
    ccTexParams tp2 = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
    [stripes.texture setTexParameters:&tp2];
    _terrain.stripes = stripes;
    
}

-(id) init {
    if((self=[super init])) {	
		_terrain = [Terrain node];
		[self addChild:_terrain z:1];
		
        [self genBackground];
        self.isTouchEnabled = YES;  
        [self scheduleUpdate];
		//self.scale = 0.25;
    }
    return self;
}

- (void)update:(ccTime)dt {
    
    float PIXELS_PER_SECOND = 100;
    static float offset = 0;
    offset += PIXELS_PER_SECOND * dt;
    
    CGSize textureSize = _background.textureRect.size;
    [_background setTextureRect:CGRectMake(offset, 0, textureSize.width, textureSize.height)];
	
	[_terrain setOffsetX:offset];
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //[self genBackground];
    
}

@end
