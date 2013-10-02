//
//  Player.h
//  FlyingChess_
//
//  Created by yzq on 12-10-13.
//
//

#import <Foundation/Foundation.h>
#import "PlaneSprite.h"
#import "Routes.h"

@interface Player : NSObject{
    BOOL isUserCouldShakeDice;          //判断能不能摇骰子
    BOOL isUserCouldTouchPlane;         //判断能不能点飞机
    int numOfPreparedPlane;             //处于准备状态的飞机 （双数才能起飞）
}
@property (nonatomic) int tag;
@property (nonatomic) int round;
@property (nonatomic,retain) NSMutableArray *planeArray;
@property (nonatomic,retain) NSMutableArray *routeArray;

@property (nonatomic) BOOL isUserCouldShakeDice;
@property (nonatomic) BOOL isUserCouldTouchPlane;
@property (nonatomic) int numOfPreparedPlane;

-(id) intiWithPlaneArray:(NSMutableArray *)PlaneArray andRoutes:(NSMutableArray *)Routes;

@end
