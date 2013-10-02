//
//  Player.m
//  FlyingChess_
//
//  Created by yzq on 12-10-13.
//
//

#import "Player.h"

@implementation Player
@synthesize tag=_tag;
@synthesize planeArray=_planeArray;
@synthesize routeArray=_routeArray;
@synthesize isUserCouldShakeDice;
@synthesize isUserCouldTouchPlane;
@synthesize numOfPreparedPlane;
@synthesize round;

-(id) intiWithPlaneArray:(NSMutableArray *)PlaneArray andRoutes:(NSMutableArray *)Routes{
    self=[super init];
    if (self) {
        _routeArray=[[NSMutableArray alloc] initWithArray:Routes];
        _planeArray=[[NSMutableArray alloc] initWithArray:PlaneArray];
    }
    return self;
}

-(void) dealloc{
    NSLog(@"Player dealloc!");
    [self setPlaneArray:nil];
    [self setRouteArray:nil];
    [super dealloc];
}

@end
