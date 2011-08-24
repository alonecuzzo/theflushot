//
//  Terrain.m
//  TinySeal
//
//  Created by cuzzo on 8/22/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "Terrain.h"
#import "HelloWorldLayer.h"
#import <Foundation/Foundation.h> 


@implementation Terrain
@synthesize stripes = _stripes;

-(void) generateHills {
	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	
    float minDX = 100;
    float minDY = 20;
    int rangeDX = 80;
    int rangeDY = 40;
	
    float x = -minDX;
    float y = winSize.height/2-minDY;
	float x1 = -minDX;
	float y1 = winSize.height - 70;
	
    float dy, ny, ny1;
    float sign = 1; // +1 - going up, -1 - going  down
    float paddingTop = 20;
    float paddingBottom = 20;
	
    for (int i=0; i<kMaxHillPoints; i++) {
        _hillKeyPoints[i] = CGPointMake(x, y);
		_hillKeyPoints1[i] = CGPointMake(x1, y1);
        if (i == 0) {
            x = 0;
			x1 = 0;
           // y = winSize.height/2;
			y = 70;
			y1 = winSize.height;
        } else {
            x += rand()%rangeDX+minDX;
            while(true) {
                dy = rand()%rangeDY+minDY;
                ny = y + dy*sign;
                //if(ny < winSize.height-paddingTop && ny > paddingBottom) {
				if(ny < 70 && ny > paddingBottom) {
                    break;   
                }
            }
            y = ny;
			
			x1 += rand()%rangeDX+minDX;
			while (true) {
				dy = rand()%rangeDY+minDY;
                ny1 = y1 + dy*sign;
                //if(ny < winSize.height-paddingTop && ny > paddingBottom) {
				if(ny1 < winSize.height && ny1 > winSize.height - 70) {
                    break;   
                }
			}
			y1 = ny1;
        }
        sign *= -1;
		
		//printf("_hillpoints[%i]: (%f, %f)", i, _hillKeyPoints[i].x, _hillKeyPoints[i].y);
//		printf("\n\n_hillpoints1[%i]: (%f, %f)", i, _hillKeyPoints1[i].x, _hillKeyPoints1[i].y);
    }
	
 
	
}


-(void) resetHillVerticies {
	CGSize winSize = [CCDirector sharedDirector].winSize;
	
	static int prevFromKeyPointI = -1;
    static int prevToKeyPointI = -1;
	
    // key points interval for drawing
    while (_hillKeyPoints[_fromKeyPointI+1].x < _offsetX-winSize.width/8/self.scale) {
        _fromKeyPointI++;
    }
    while (_hillKeyPoints[_toKeyPointI].x < _offsetX+winSize.width*9/8/self.scale) {
        _toKeyPointI++;
    }
	
	if (prevFromKeyPointI != _fromKeyPointI || prevToKeyPointI != _toKeyPointI) {
		
		// vertices for visible area
		_nHillVertices = 0;
		_nBorderVertices = 0;
		CGPoint p0, p1, pt0, pt1;
		p0 = _hillKeyPoints1[_fromKeyPointI];
		printf("\n_fromKeyPoint top: %i", _fromKeyPointI);
		printf("\n");
		for (int i=_fromKeyPointI+1; i<_toKeyPointI+1; i++) {
			p1 = _hillKeyPoints1[i];
			
			// triangle strip between p0 and p1
			int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
			float dx = (p1.x - p0.x) / hSegments;
			float da = M_PI / hSegments;
			float ymid = (p0.y + p1.y) / 2;
			float ampl = (p0.y - p1.y) / 2;
			pt0 = p0;
			_borderVertices1[_nBorderVertices++] = pt0;
			for (int j=1; j<hSegments+1; j++) {
				pt1.x = p0.x + j*dx;
				pt1.y = ymid + ampl * cosf(da*j);
				_borderVertices1[_nBorderVertices++] = pt1;
				
				_hillVertices1[_nHillVertices] = CGPointMake(pt0.x, winSize.height);
				_hillTexCoords1[_nHillVertices++] = CGPointMake(pt0.x/512, 1.0f);
				_hillVertices1[_nHillVertices] = CGPointMake(pt1.x, winSize.height);
				_hillTexCoords1[_nHillVertices++] = CGPointMake(pt1.x/512, 1.0f);
				
				_hillVertices1[_nHillVertices] = CGPointMake(pt0.x, pt0.y);
				_hillTexCoords1[_nHillVertices++] = CGPointMake(pt0.x/512, winSize.height);
				_hillVertices1[_nHillVertices] = CGPointMake(pt1.x, pt1.y);
				_hillTexCoords1[_nHillVertices++] = CGPointMake(pt1.x/512, winSize.height);
			
				pt0 = pt1;
			}
			
			p0 = p1;
		}
		
		prevFromKeyPointI = _fromKeyPointI;
		prevToKeyPointI = _toKeyPointI;    
		
		printf("\n prevfromekeypointI after top: %i", prevFromKeyPointI);
		printf("\n prevToKeyPointI after top: %i", prevToKeyPointI);
	}
	
	
	
	prevFromKeyPointI = -1;
	prevToKeyPointI = -1;
	
	if (prevFromKeyPointI != _fromKeyPointI || prevToKeyPointI != _toKeyPointI) {
		// vertices for visible area
		_nHillVertices = 0;
		_nBorderVertices = 0;
		//printf("border verticies: %i", _nBorderVertices);
		CGPoint p20, p21, pt20, pt21;
		p20 = _hillKeyPoints[_fromKeyPointI];
		//printf("\np20: %3.2f, %3.2f", p20.x, p20.y);
		printf("\n_fromKeyPoint: %i", _fromKeyPointI);
		for (int i=_fromKeyPointI+1; i<_toKeyPointI+1; i++) {
			p21 = _hillKeyPoints[i];
			
			// triangle strip between p0 and p1
			int hSegments1 = floorf((p21.x-p20.x)/kHillSegmentWidth);
			float d2x = (p21.x - p20.x) / hSegments1;
			float da = M_PI / hSegments1;
			float ymid = (p20.y + p21.y) / 2;
			float ampl = (p20.y - p21.y) / 2;
			pt20 = p20;
			_borderVertices[_nBorderVertices++] = pt20;
			for (int j=1; j<hSegments1+1; j++) {
				pt21.x = p20.x + j*d2x;
				pt21.y = ymid + ampl * cosf(da*j);
				_borderVertices[_nBorderVertices++] = pt21;
				
				
				_hillVertices[_nHillVertices] = CGPointMake(pt20.x, 0);
				_hillTexCoords[_nHillVertices++] = CGPointMake(pt20.x/512, 1.0f);
				_hillVertices[_nHillVertices] = CGPointMake(pt21.x, 0);
				_hillTexCoords[_nHillVertices++] = CGPointMake(pt21.x/512, 1.0f);
				
				_hillVertices[_nHillVertices] = CGPointMake(pt20.x, pt20.y);
				_hillTexCoords[_nHillVertices++] = CGPointMake(pt20.x/512, 0);
				_hillVertices[_nHillVertices] = CGPointMake(pt21.x, pt21.y);
				_hillTexCoords[_nHillVertices++] = CGPointMake(pt21.x/512, 0);
				
				pt20 = pt21;
				
			}
			
			pt20 = pt21;
		
		}
		
		prevFromKeyPointI = _fromKeyPointI;
		prevToKeyPointI = _toKeyPointI;        
	}

}

-(id) init {
	
	if(self == [super init])
	{
		[self generateHills];
		[self resetHillVerticies];
	}
	
	
	return self;
}


-(void) draw {
	
	glBindTexture(GL_TEXTURE_2D, _stripes.texture.name);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glColor4f(1, 1, 1, 1);
	glVertexPointer(2, GL_FLOAT, 0, _hillVertices1);
	glTexCoordPointer(2, GL_FLOAT, 0, _hillTexCoords1);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)_nHillVertices);
	
	glBindTexture(GL_TEXTURE_2D, _stripes.texture.name);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glColor4f(1, 1, 1, 1);
	glVertexPointer(2, GL_FLOAT, 0, _hillVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, _hillTexCoords);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)_nHillVertices);

	
	for(int i = MAX(_fromKeyPointI, 1); i <= _toKeyPointI; ++i) {
        glColor4f(1.0, 0, 0, 1.0); 
        //ccDrawLine(_hillKeyPoints1[i-1], _hillKeyPoints1[i]);     
		
		glColor4f(1.0, 1.0, 1.0, 1.0);
		
		CGPoint p0 = _hillKeyPoints1[i-1];
		CGPoint p1 = _hillKeyPoints1[i];
		int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
		float dx = (p1.x - p0.x) / hSegments;
		float da = M_PI / hSegments;
		float ymid = (p0.y + p1.y) / 2;
		float ampl = (p0.y - p1.y) / 2;
		
		CGPoint pt0, pt1;
		pt0 = p0;
		for (int j = 0; j < hSegments+1; ++j) {
			
			pt1.x = p0.x + j*dx;
			pt1.y = ymid + ampl * cosf(da*j);
			
			//ccDrawLine(pt0, pt1);
			
			pt0 = pt1;
			
		}
    }
	
}


-(void) setOffsetX:(float)newOffsetX {
	_offsetX = newOffsetX;
	self.position = CGPointMake(-_offsetX*self.scale, 0);
	[self resetHillVerticies];
}


-(void) dealloc {
	[_stripes release];
	_stripes = NULL;
	[super dealloc];
}


@end
