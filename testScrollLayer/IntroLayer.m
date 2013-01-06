//
//  IntroLayer.m
//  testScrollLayer
//
//  Created by carmazhao on 12-12-3.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "CarmaScrollLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];
    CarmaScrollLayer * layer = [CarmaScrollLayer create_layer:HORIZON_SCROLL_MODE];
    CGPoint _pos = CGPointMake(0, 0);
    layer.position = _pos;
    
    CCSprite * sprite1 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite2 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite3 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite4 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite5 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite6 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite7 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite8 = [CCSprite spriteWithFile:@"Icon-72.png"];
    CCSprite * sprite9 = [CCSprite spriteWithFile:@"Icon-72.png"];
    [layer add_sprite:sprite1];
    [layer add_sprite:sprite2];
    [layer add_sprite:sprite3];
    [layer add_sprite:sprite4];
    [layer add_sprite:sprite5];
    [layer add_sprite:sprite6];
    [layer add_sprite:sprite7];
    [layer add_sprite:sprite8];
    [layer add_sprite:sprite9];
    [self addChild:layer];
}
@end
