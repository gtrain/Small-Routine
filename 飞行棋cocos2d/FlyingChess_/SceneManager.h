//
//  SceneManager.h
//  FlyingChess_
//
//  Created by yzq on 12-10-4.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuLayer.h"
#import "ModelSelect.h"
#import "GameOver.h"
#import "AboutLayer.h"

@interface SceneManager : NSObject

+(void) go2menu;        //菜单画面
+(void) go2select;      //选择对战模式
+(void) go2play:(NSInteger) playerCount;        //游戏画面
+(void) go2intro;       //简介画面
+(void) go2GameOver:(NSString *) labelMsg;       //结束游戏
@end
