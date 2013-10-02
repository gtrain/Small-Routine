//
//  PlaneSprite.h
//  FlyingChess_
//
//  Created by yzq on 12-10-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlaneSprite : CCSprite {
    int _planePosition;             //现在的位置，第几格
    NSString *_planeOrientation;    //现在的方向
    int _tag;                       //第几架飞机
    CGPoint _realPosition;           //飞机的位置，因为在执行飞行动作前，自带的position是不会更改的
}
@property (nonatomic,retain) NSString *planeOrientation;
@property (nonatomic) int planePosition;
@property (nonatomic) int tag;
@property (nonatomic) CGPoint realPosition;
@end
