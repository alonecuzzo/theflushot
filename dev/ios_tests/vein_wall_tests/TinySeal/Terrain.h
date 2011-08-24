//
//  Terrain.h
//  TinySeal
//
//  Created by cuzzo on 8/22/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h> 

@class HelloWorldLayer;

#define kMaxHillPoints 1000
#define kHillSegmentWidth 10
#define kMaxHillVertices 4000
#define kMaxBorderVertices 800 


@interface Terrain : CCNode {
	
	int _offsetX;
	CGPoint _hillKeyPoints[kMaxHillPoints];
	CGPoint _hillKeyPoints1[kMaxHillPoints];
	CCSprite *_stripes;
	int _fromKeyPointI;
	int _toKeyPointI;
	
	int _nHillVertices;
	CGPoint _hillVertices[kMaxHillVertices];
	CGPoint _hillTexCoords[kMaxHillVertices];
	int _nBorderVertices;
	CGPoint _borderVertices[kMaxBorderVertices];
	
	CGPoint _hillVertices1[kMaxHillVertices];
	CGPoint _hillTexCoords1[kMaxHillVertices];
	CGPoint _borderVertices1[kMaxBorderVertices];
}

@property (retain) CCSprite *stripes;

-(void) setOffsetX:(float) newOffsetX;

@end
