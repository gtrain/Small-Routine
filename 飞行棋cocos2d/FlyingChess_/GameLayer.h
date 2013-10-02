//
//  GameLayer.h
//  FlyingChess
//
//  Created by yang on 12-9-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface GameLayer : CCLayer {
    NSInteger _playerCount;              //用户选择的人数
    int curPlayerCount;                  //一个轮回的剩余人数
    
    Player *_player1;       //玩家1，就是机
    Player *_player2;       //玩家2，自动
    Player *_player3;       //玩家3，如果有的话
    Player *_player4;       //玩家4，如果有的话
    
    CCSprite *_dice;                    //骰子
    CCAction *_diceAction;              //骰子动画
    NSMutableArray *_diceActionArray;   //存骰子各种动画数组
    NSMutableArray *_animFramesArray;
    int curPoint;                       //储存骰子点数.
}
@property (nonatomic) int GameRound; //游戏轮数
@property (nonatomic,retain) NSMutableArray *playerArray;
@property (nonatomic,retain) CCSprite *dice;
@property (nonatomic,retain) CCAction *diceAction;
@property (nonatomic,retain) NSMutableArray *diceActionArray;
@property (nonatomic,retain) NSMutableArray *animFramesArray;
@property (nonatomic) NSInteger playerCount;  
@property (nonatomic,retain) Player *player1;       //玩家1

//返回一个包含GameLayer结点的场景
+(CCScene *) scene;
-(id) initWithPlayerCount:(NSInteger) playerNum;
@end


//[_dice runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.0f],[CCCallFunc actionWithTarget:self selector:@selector(stopNshowPoints)],nil]];
//[self performSelector:@selector(stopNshowPoints) withObject:self afterDelay:1.0f];









