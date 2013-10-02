//
//  Routes.h
//  FlyingChess_
//
//  Created by yzq on 12-10-5.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Routes : NSObject

@property (nonatomic) int routeIndex;                    //第几格
@property (nonatomic) CGPoint positionPoint;                  //格子的坐标，array[0]跟array[1]需要用到，

@property (nonatomic) BOOL needChangeDirections;            
@property (nonatomic,assign) NSString *routeDirections;

@end
