//
//  ScrollLayer.h
//  testScrollLayer
//
//  Created by carmazhao on 12-12-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.

//  ***************本版本不支持多线程****************

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define LAYER_PRIORITY  -1  //the priority of layer
#define CHILD_PRIORITY  1   //the priority of child on layer

#define VERTICAL_SCROLL_MODE YES
#define HORIZON_SCROLL_MODE  NO

#define MOVE_DIR_PLUS YES
#define MOVE_DIR_MINUS NO

#define TO_PLAY_ACTION_THRESHOLD 1
#define MAX_ACTION_DISTANCE   50
@interface CarmaScrollLayer : CCLayer {
    CCLayerColor*            m_main_layer;    //layer to content objs
    
    NSMutableArray *    m_sprite_arr;    //store the sprites
    NSInteger           m_cur_sprite;    //index of the current layer
  
    BOOL                m_hor_or_ver;    //move horizen or vertical
    NSInteger           m_max_pos;       //store the max pos
    NSInteger           m_inter_dis;     //the distance between two sprites
    
    BOOL                m_in_scroll_mode;//if it is scrolling
    CGPoint             m_touch_begin_pos;//touch begin position
    CGPoint             m_touch_cur_pos;  //current touch position
    BOOL                m_move_dir;       //position plus or minus
    
    NSInteger           m_touch_move_stop_time;//as you see
    
    //about size
    NSInteger           m_layer_width;
    NSInteger           m_layer_height;
}
@property(nonatomic , retain)CCLayer*            m_main_layer;
@property(nonatomic , retain)NSMutableArray *    m_sprite_arr;
@property(nonatomic)NSInteger           m_cur_sprite;
@property(nonatomic)BOOL                m_hor_or_ver; 
@property(nonatomic)NSInteger           m_max_pos;
@property(nonatomic)NSInteger           m_inter_dis;    

@property(nonatomic)BOOL                m_in_scroll_mode;
@property(nonatomic)CGPoint             m_touch_begin_pos;
@property(nonatomic)CGPoint             m_touch_cur_pos;  
@property(nonatomic)BOOL                m_move_dir;      
@property(nonatomic)NSInteger           m_touch_move_stop_time;
@property(nonatomic)NSInteger           m_layer_width;
@property(nonatomic)NSInteger           m_layer_height;


+(id)create_layer:(BOOL)dir;
-(CarmaScrollLayer *)init:(BOOL)dir;

-(void)add_sprite:(CCSprite *)sprite;
-(BOOL)check_bound;

@end
