//
//  SceneManager.m
//  FlyingChess_
//
//  Created by yzq on 12-10-4.
//
//

#import "SceneManager.h"
@interface SceneManager ()
+(void) go: (CCLayer *) layer;
@end

@implementation SceneManager
+(void) go2menu{
    //CCLayer *newLayer = [[MenuLayer node];
    CCLayer *newLayer=[MenuLayer node];
    [self go:newLayer];
}

+(void) go2select{
    CCLayer *newLayer=[ModelSelect node];
    [self go:newLayer];
}

+(void) go2play:(NSInteger) selPlayerCount{
    GameLayer *newLayer = [[GameLayer alloc] initWithPlayerCount:selPlayerCount];
    [self go:newLayer];
}

+(void) go2intro{
    //NSLog(@"go2intro");
    CCLayer *newLayer=[AboutLayer node];
    [self go:newLayer];
    
}
+(void) go2GameOver:(NSString *) labelMsg{
    GameOver *newLayer = [[GameOver alloc] initWithLabel:labelMsg];
    [self go:newLayer];
}


+(void) go: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];                 //创建一个场景
    [newScene addChild:layer];                          //把层添加为结点
    
	CCDirector *director = [CCDirector sharedDirector]; //如果当前有场景在运行，替换没有就直接运行
	if ([director runningScene]) {
		[director replaceScene:newScene];
	}else {
		[director runWithScene:newScene];
	}
}

@end
