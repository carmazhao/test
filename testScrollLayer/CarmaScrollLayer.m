//
//  ScrollLayer.m
//  testScrollLayer
//
//  Created by carmazhao on 12-12-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CarmaScrollLayer.h"


@implementation CarmaScrollLayer
@synthesize  m_main_layer;
@synthesize  m_sprite_arr;
@synthesize  m_cur_sprite;
@synthesize  m_hor_or_ver;
@synthesize  m_max_pos;
@synthesize  m_inter_dis;
@synthesize  m_in_scroll_mode;
@synthesize  m_touch_begin_pos;
@synthesize  m_touch_cur_pos;
@synthesize  m_move_dir;
@synthesize  m_touch_move_stop_time;
@synthesize  m_layer_width;
@synthesize  m_layer_height;

+(id)create_layer:(BOOL)dir{
    CarmaScrollLayer * layer = [[[CarmaScrollLayer alloc]init:dir]autorelease];
    return layer;
}

-(CarmaScrollLayer *)init:(BOOL)dir {
    if ((self = [super init])) {
        m_main_layer = [CCLayerColor node];
        m_main_layer.isTouchEnabled = YES;
        CGPoint _pos = CGPointMake(0, 0);
        m_main_layer.position = _pos;
        [m_main_layer setColor:ccRED];
        [self addChild:m_main_layer];
        
        
        //about size
        m_layer_width = 0;
        m_layer_height = 0;
        
        //set the index
        m_cur_sprite = 0;
        
        m_hor_or_ver = dir;
        m_max_pos = 0;
        m_inter_dis = 2;
        m_in_scroll_mode = NO;
        m_move_dir = YES;
        m_touch_move_stop_time = 0;
       
        //init the array
        m_sprite_arr = [[NSMutableArray alloc]init];
        
        //open the touch catcher
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [m_sprite_arr release];
}

//set the event catcher
-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:LAYER_PRIORITY swallowsTouches:NO];
}


-(void)add_sprite:(CCSprite *)sprite{
    CGPoint             _pos;
    
    if (m_hor_or_ver == HORIZON_SCROLL_MODE) {
        //if it scroll horizenally
        _pos = CGPointMake(m_max_pos + sprite.contentSize.width/2, sprite.contentSize.height/2);
        m_max_pos += sprite.contentSize.width + m_inter_dis;
        
        //change the width of layer
        m_layer_width += sprite.contentSize.width;
    }else{
        NSLog(@"%daaaaa" , (int)m_max_pos);
        _pos = CGPointMake(sprite.contentSize.width/2 , m_max_pos + sprite.contentSize.height/2);
        m_max_pos += sprite.contentSize.height + m_inter_dis;
        
        //change the height of layer
        m_layer_height += sprite.contentSize.height;
    }
    sprite.position = _pos;
    [m_main_layer addChild:sprite];
    [m_sprite_arr addObject:sprite];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    //stop the actions
    [m_main_layer stopAllActions];
    
    CGPoint  _pos = [touch locationInView:[touch view]];
    _pos = [[CCDirector sharedDirector] convertToGL:_pos];
    m_touch_begin_pos = _pos;
    m_touch_cur_pos = _pos;
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint _pos = [touch locationInView:[touch view]];
    _pos = [[CCDirector sharedDirector] convertToGL:_pos];
    CGPoint             _new_pos;
    NSInteger           _dis;
    
    if (m_hor_or_ver == HORIZON_SCROLL_MODE) {
        _dis = _pos.x - m_touch_cur_pos.x;

        _new_pos = CGPointMake(m_main_layer.position.x + _dis, m_main_layer.position.y);
    }else{
        _dis = _pos.y - m_touch_cur_pos.y;
        
        _new_pos = CGPointMake(m_main_layer.position.x , m_main_layer.position.y + _dis);
    }
    
    //set the flag of dir
    m_move_dir = (_dis >= 0)?MOVE_DIR_PLUS : MOVE_DIR_MINUS;
    
    //set the current position of layer
    m_main_layer.position = _new_pos;
    
    //update the cur pos
    m_touch_cur_pos = _pos;
    
    //flush the move time
    NSDate * _date = [NSDate date];
    NSTimeInterval _timeInterval = [_date timeIntervalSince1970];
    m_touch_move_stop_time = (NSInteger)_timeInterval;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    //do some bound check
    if ([self check_bound] == NO) {
        return;
    }

    //get the time
    NSDate *            _date = [NSDate date];
    NSTimeInterval      _timeInterval = [_date timeIntervalSince1970];
    NSInteger           _cur_time = (NSInteger)_timeInterval;
    
    //the distance to play action
    NSInteger           _action_dis = MAX_ACTION_DISTANCE;
    NSInteger           _time = _cur_time - m_touch_move_stop_time;
    
    if (_time < TO_PLAY_ACTION_THRESHOLD) {
        //create target position
        CGPoint     _target_pos ;

        if (m_hor_or_ver == HORIZON_SCROLL_MODE) {
            if (m_move_dir == MOVE_DIR_PLUS) {
                _target_pos = CGPointMake(m_main_layer.position.x + _action_dis , m_main_layer.position.y);
            }else{
                _target_pos = CGPointMake(m_main_layer.position.x - _action_dis , m_main_layer.position.y);
            }  
        }else{           
            if (m_move_dir == MOVE_DIR_PLUS) {
                _target_pos = CGPointMake(m_main_layer.position.x , m_main_layer.position.y + _action_dis);
            }else{
                _target_pos = CGPointMake(m_main_layer.position.x , m_main_layer.position.y - _action_dis);
            }
        }
        //create action
        CCMoveTo * _move = [CCMoveTo actionWithDuration:0.5 position:_target_pos];
        CCEaseOut * _action = [CCEaseOut actionWithAction:_move rate:4];
        
        [m_main_layer runAction:_action];
    }
}

-(BOOL)check_bound{
    if (m_hor_or_ver == HORIZON_SCROLL_MODE) {
        //check left bound
        if (m_main_layer.position.x > 0) {
            CGPoint  _target = CGPointMake(0, 0);
            CCMoveTo * _move = [CCMoveTo actionWithDuration:0.5 position:_target];
            CCEaseOut * _action = [CCEaseOut actionWithAction:_move rate:4];
            [m_main_layer stopAllActions];
            [m_main_layer runAction:_action];
            return NO;
        }
        //check right bound
        CGSize      _win_size = [[CCDirector sharedDirector]winSize];
        NSInteger   _rest_width = m_layer_width + m_main_layer.position.x;
        if (_rest_width < _win_size.width) {
            CGPoint     _target = CGPointMake(m_main_layer.position.x + (_win_size.width - _rest_width), m_main_layer.position.y);
            
            CCMoveTo * _move = [CCMoveTo actionWithDuration:0.5 position:_target];
            CCEaseOut * _action = [CCEaseOut actionWithAction:_move rate:4];
            [m_main_layer stopAllActions];
            [m_main_layer runAction:_action];
            return NO;
        }
    }else{
        //check left bound
        if (m_main_layer.position.y > 0) {
            CGPoint  _target = CGPointMake(0, 0);
            CCMoveTo * _move = [CCMoveTo actionWithDuration:0.5 position:_target];
            CCEaseOut * _action = [CCEaseOut actionWithAction:_move rate:4];
            [m_main_layer stopAllActions];
            [m_main_layer runAction:_action];
            return NO;
        }
        //check right bound
        CGSize      _win_size = [[CCDirector sharedDirector]winSize];
        NSInteger   _rest_height = m_layer_height + m_main_layer.position.y;
        if (_rest_height < _win_size.height) {
            CGPoint     _target = CGPointMake(m_main_layer.position.x, m_main_layer.position.y + (_win_size.height - _rest_height));
            
            CCMoveTo * _move = [CCMoveTo actionWithDuration:0.5 position:_target];
            CCEaseOut * _action = [CCEaseOut actionWithAction:_move rate:4];
            [m_main_layer stopAllActions];
            [m_main_layer runAction:_action];
        }
        return NO;
    }
    return YES;
}
@end
