//
//  GameLayer.m
//  FlyingChess
//
//  Created by yang on 12-9-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameOver.h"
#import "SceneManager.h"

@interface GameLayer()
-(void) setRouteDirections:(NSMutableArray *)routeArray changeDirections:(NSString *)directions which2change:(NSInteger) index1,...;
-(NSMutableArray *) initPlaneArrayWithImage:(NSString *)Image firstPlanePosition:(CGPoint)point;
-(void) disposePlane:(PlaneSprite *)selectedPlane Point:(int)dicePoint sender:(Player *)curPlayer;
-(void) disposeCollide:(Player *)curPlayer plane:(PlaneSprite *)selectPlane;
-(id) planeMove:(PlaneSprite *) plane dicePoint:(NSInteger) point;
-(void) performActions:(PlaneSprite *)plane ActionArray:(NSArray *)actionArray;
-(NSMutableArray *) Route1;
-(NSMutableArray *) Route2;
-(NSMutableArray *) Route3;
-(NSMutableArray *) Route4;
-(void) waitingForOpponentDo:(Player *)prePlayer;//其他飞机的动作
-(void) rootUser;//初始化各个玩家
-(int) shakeDice;
-(Player *) getplayerBytag:(int) tag;
-(NSString *) TurnDirection:(NSString *)formerDirection;
@end

@implementation GameLayer
@synthesize playerArray=_playerArray;
@synthesize dice=_dice;
@synthesize diceAction=_diceAction;
@synthesize diceActionArray=_diceActionArray;
@synthesize animFramesArray=_animFramesArray;
@synthesize playerCount=_playerCount;
@synthesize GameRound=_GameRound;
@synthesize player1=_player1;

#define WINSIZE [[CCDirector sharedDirector] winSize]   //屏幕大小
#define UNIT_DURATION 0.5                               //移动一个格子所需要的时间
#define UNIT_SPACE 27                                   //每个格子的间隔

enum{
    kTagSpriteSheet = 1,
};

+(CCScene *) scene{
    CCScene *scene=[CCScene node];
    GameLayer *layer=[GameLayer node];
    [scene addChild:layer];
    return scene;               //返回一个包含GameLayer结点的场景
}

-(id) initWithPlayerCount:(NSInteger) playerNum{
    self=[super init];
    if (self) {
        self.playerCount=playerNum;
        curPlayerCount=playerNum;
        [self setGameRound:0];
        
        self.isTouchEnabled=YES;
        CCSprite *gameBg=[CCSprite spriteWithFile:@"GameBg.png"];
        gameBg.position=ccp(160, 240);
        [self addChild:gameBg z:0];
        self.playerArray =[[NSMutableArray alloc] init];
        
        //初始化用户
        [self rootUser];
        
        //设置返回按钮
        CCMenuItemImage *startNew=[CCMenuItemImage itemFromNormalImage:@"backBtn.png" selectedImage:nil disabledImage:nil target:self selector:@selector(MianMenu)];
        CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
        menu.position = ccp(160, 50);
        [self addChild:menu z: 2];
        
        //设置骰子
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"diceAction.png"];//加载原始图片
        CCSpriteBatchNode *sheet=[CCSpriteBatchNode batchNodeWithTexture:texture capacity:6];   //6个帧
        [self addChild:sheet z:0 tag:kTagSpriteSheet];
        
        _diceActionArray = [[NSMutableArray alloc] init];                                       //不这样写的话，就写跟get函数吧，还只能用self.访问
        _animFramesArray=[[NSMutableArray alloc] init];
            for (int j = 0; j <6; j++) {
                CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:CGRectMake(j*75, 0, 75, 70) rotated:NO offset:CGPointZero originalSize:CGSizeMake(80,75)];
                [_animFramesArray addObject:frame];
            }
            CCAnimation *animation = [CCAnimation animationWithFrames:_animFramesArray delay:0.04f];
            CCAnimate *animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
        
        CCSequence *seq = [CCSequence actions: animate,nil];
        _diceAction = [CCRepeatForever actionWithAction: seq ];
        
        
        [_diceActionArray addObject:self.diceAction];
        
        CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture rectInPixels:CGRectMake(6*75, 0, 75, 70) rotated:NO offset:CGPointZero originalSize:CGSizeMake(75 , 70)];
        
        _dice = [CCSprite spriteWithSpriteFrame:frame1];
        _dice.position = ccp(230, 170);  //骰子的坐标ccp(WINSIZE.width/2-40, WINSIZE.height/2-30)
        [sheet addChild:_dice];
        
        _diceAction = [_diceActionArray objectAtIndex:0];
    }
    return self;
}

//用户点击屏幕
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation=[self convertTouchToNodeSpace:touch];                             //转换OpenGl坐标为指定结点坐标系
    
    //响应摇骰子
    if (_player1.isUserCouldShakeDice && CGRectContainsPoint(_dice.boundingBox, touchLocation)) {    //如果轮到用户摇骰子，且用户点击了骰子
        _player1.isUserCouldShakeDice=NO;
        curPoint=[self shakeDice];              //更新骰子点数curPoint=6;
        
        if ((curPoint)%2 & (_player1.numOfPreparedPlane==0)) {
            NSLog(@"只有偶数才能起飞.下一玩家");
            curPlayerCount=_playerCount;    //人数统计复位
            _GameRound++;                   //游戏轮数
            [self performSelector:@selector(waitingForOpponentDo:) withObject:_player1 afterDelay:1.5f];
            return;
        }
        
        _player1.isUserCouldTouchPlane=YES;
        
        curPlayerCount=_playerCount;    //人数统计复位
        ++_GameRound;                   //游戏轮数
    }
    //响应飞机起飞
    if (_player1.isUserCouldTouchPlane) {       //每个轮回用户只能移动一次飞机, && playerCount==4
        PlaneSprite *selectedPlane=[[[PlaneSprite alloc] init] autorelease];
        for (PlaneSprite *plane in _player1.planeArray) {
            if (CGRectContainsPoint(plane.boundingBox, touchLocation)) {
                _player1.isUserCouldTouchPlane=NO;
                selectedPlane=plane;
                //NSLog(@"选择第%d辆飞机",selectedPlane.tag+1);
                
                
                [self disposePlane:selectedPlane Point:curPoint sender:_player1];
                break;
            }
        }
    }
}

//处理飞机的特殊位置跟更新方向
-(void) disposePlane:(PlaneSprite *)selectedPlane Point:(int)dicePoint sender:(Player *)curPlayer{
    float exeTime=UNIT_DURATION*(dicePoint+1);  //飞机飞行时间，用于 “执行下一玩家的” 定时器,+1为缓冲时间
    
    NSMutableArray *actionArray=[[NSMutableArray alloc] init];
    //NSLog(@"所选飞机的位置是：%d",selectedPlane.planePosition);
    
    if (selectedPlane.planePosition==-1 ) {
        if ((dicePoint)%2) {
            NSLog(@"只有偶数才能起飞.请重新选择！");
            _player1.isUserCouldTouchPlane=YES;
            return;
        }
        
        Routes *unitRoute=[[[Routes alloc] init] autorelease];
        unitRoute=[curPlayer.routeArray objectAtIndex:0];
        id move2ready = [CCMoveTo actionWithDuration:UNIT_DURATION position:[unitRoute positionPoint]];
        [selectedPlane runAction:[CCSequence actions: move2ready, nil]];
        
        selectedPlane.planePosition=unitRoute.routeIndex;
        
        curPlayer.numOfPreparedPlane++;       //有飞机ready就+1
        
        //NSLog(@"下一个玩家,selectedPlane.planePosition==-1",curPlayer.tag);
        [self performSelector:@selector(waitingForOpponentDo:) withObject:curPlayer afterDelay:UNIT_DURATION+0.5];
        return;
    }else if (selectedPlane.planePosition==0) {
        Routes *unitRoute=[[[Routes alloc] init] autorelease];
        unitRoute=[curPlayer.routeArray objectAtIndex:1];
        //[selectedPlane runAction:[CCMoveTo actionWithDuration:UNIT_DURATION position:[unitRoute positionPoint]]];
        //NSLog(@"飞机变成起飞,移动到：%@",NSStringFromCGPoint([unitRoute positionPoint]));
        id actionMove = [CCMoveTo actionWithDuration:UNIT_DURATION position:[unitRoute positionPoint]];
        
        selectedPlane.realPosition=[unitRoute positionPoint];
        [actionArray addObject:actionMove];
        selectedPlane.planePosition=unitRoute.routeIndex;               //改飞机位置
        selectedPlane.planeOrientation=unitRoute.routeDirections;       //改飞机方向
        dicePoint--;
        if(dicePoint<1){
            [self performActions:selectedPlane ActionArray:actionArray];    //执行动作
            NSString *token=@"Collide";
            NSMutableArray *dataPack=[[[NSMutableArray alloc] initWithObjects:token,selectedPlane,curPlayer, nil] autorelease];
            [self performSelector:@selector(sendPlayerAndPlane:) withObject:dataPack afterDelay:UNIT_DURATION+0.5];

            return;
        }    //是否点数大于1，是的话继续下面的函数，不是就下一个玩家(骰子默认从0开始，所以这里就不-1了)
    }

    int nextPosition = selectedPlane.planePosition+1;
    int finalPosition= selectedPlane.planePosition+dicePoint;
    
    if (finalPosition>curPlayer.routeArray.count) {
    //if (finalPosition>7) {
        //if (finalPosition == curPlayer.routeArray.count+1) {
            [selectedPlane runAction:[CCMoveTo actionWithDuration:UNIT_DURATION*dicePoint position:ccp(WINSIZE.width/2,WINSIZE.height/2)]]; //飞到屏幕中间
        int curTag=selectedPlane.tag+1;
        while (curTag!=curPlayer.planeArray.count) {
            PlaneSprite *changeTagPlane=[curPlayer.planeArray objectAtIndex:curTag];
            changeTagPlane.tag=changeTagPlane.tag-1;
            ++curTag;
        }

        [curPlayer.planeArray removeObject:selectedPlane];          //从玩家数组中移除，但是场景中还是有的
        curPlayer.numOfPreparedPlane--;                             //numOfPreparedPlane,没有准备的飞机的话，不能起飞
        
            if (curPlayer.planeArray.count==0) {
                [SceneManager go2GameOver:@"YOU WIN!!"];
            }
            else{
                NSLog(@"下一个玩家");
                [self performSelector:@selector(waitingForOpponentDo:) withObject:curPlayer afterDelay:UNIT_DURATION*dicePoint];
                return;
            }
        /*}
        else{
            int tmp1=curPlayer.routeArray.count-selectedPlane.planePosition-1;
            int tmp2=finalPosition-curPlayer.routeArray.count;
            
            id action1=[self planeMove:selectedPlane dicePoint:tmp1];
            
            NSString *str=selectedPlane.planeOrientation;
            if ([str isEqualToString:@"u"])     {   selectedPlane.planeOrientation=@"d";    }
            else if([str isEqualToString:@"d"]) {   selectedPlane.planeOrientation=@"u";    }
            else if([str isEqualToString:@"l"]) {   selectedPlane.planeOrientation=@"r";    }
            else if([str isEqualToString:@"r"]) {   selectedPlane.planeOrientation=@"l";    }
            
            id action2=[self planeMove:selectedPlane dicePoint:tmp2];
            
            [selectedPlane runAction:[CCSequence actions:action1, action2, nil]];
            
            selectedPlane.planeOrientation=str;
            NSLog(@"下一个玩家!");
            [self performSelector:@selector(waitingForOpponentDo:) withObject:curPlayer afterDelay:1.0f];
        }*/
        return;
    }
    
        
    for (; nextPosition<=finalPosition; nextPosition++) {
        Routes *route=[curPlayer.routeArray objectAtIndex:nextPosition];
        if(route.needChangeDirections){                                 //方向要改
            int tmpPoint=nextPosition-selectedPlane.planePosition;      //这里要用实时的selectedPlane.planePosition，因为执行飞行后位置会改
            
            id actionMove = [self planeMove:selectedPlane dicePoint:tmpPoint];          //先执行飞行
            [actionArray addObject:actionMove];
            
            selectedPlane.planeOrientation=route.routeDirections;       //改飞机方向
            //NSLog(@"飞机改方向:%@",selectedPlane.planeOrientation);
            dicePoint -= tmpPoint;                                      //把点数减掉已经飞行的
            //NSLog(@"剩下的点数是%d",dicePoint);
        }
    }
    
    if (dicePoint!=0) {                                             //飞行剩余的点数，没有就下一个了
        id actionMove =[self planeMove:selectedPlane dicePoint:dicePoint];
        [actionArray addObject:actionMove];
    }
    
    if (finalPosition==6) {                 //幸运格子
        selectedPlane.planeOrientation=[self TurnDirection:selectedPlane.planeOrientation]; //改方向
        id actionMove =[self planeMove:selectedPlane dicePoint:2];                          //跳转
        [actionArray addObject:actionMove];                                                 //添加动作
        selectedPlane.planeOrientation=[self TurnDirection:selectedPlane.planeOrientation]; //改方向
        selectedPlane.planePosition=14;                                                      //改位置
        exeTime += UNIT_DURATION*2;
    }
    
    
    //NSLog(@"接收到%d个动作，开始处理",actionArray.count);
    //执行动作
    [self performActions:selectedPlane ActionArray:actionArray];
    
    NSString *token=@"Collide";
    NSMutableArray *dataPack=[[[NSMutableArray alloc] initWithObjects:token,selectedPlane,curPlayer, nil] autorelease];
    
    [self performSelector:@selector(sendPlayerAndPlane:) withObject:dataPack afterDelay:exeTime];
    

}

//飞机移动跟更新飞机位置
-(id) planeMove:(PlaneSprite *) plane dicePoint:(NSInteger) point{
    float actualDuration=UNIT_DURATION*point;     //移动所用的时间=单位时间*移动的布数
    int x=plane.realPosition.x;
    int y=plane.realPosition.y;
    
    int goal=plane.planePosition+point;

    if ([plane.planeOrientation isEqualToString:@"r"])      { x -= UNIT_SPACE*point; }
    else if ([plane.planeOrientation isEqualToString:@"l"]) { x += UNIT_SPACE*point; }
    else if ([plane.planeOrientation isEqualToString:@"u"]) { y += UNIT_SPACE*point; }
    else if ([plane.planeOrientation isEqualToString:@"d"]) { y -= UNIT_SPACE*point; }
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(x, y)];
    //NSLog(@"移动方向%@，从%@移动到：%d,%d",plane.planeOrientation,NSStringFromCGPoint(plane.realPosition),x,y);
    plane.realPosition=ccp(x, y);
    plane.planePosition=goal;
    return actionMove;
}

-(void) performActions:(PlaneSprite *)plane ActionArray:(NSArray *)actionArray
{
    CCSequence* seq=[CCSequence actionsWithArray:actionArray];      //需要一个nil，array里面应该有
    [plane runAction:seq];
}

-(int) shakeDice{//-(void) stopNshowPoints{
    int tmpDicePoint=arc4random()%6;                   //摇骰子,数组是从0开始，所以这里不+1了
    NSLog(@"骰子数是:%d",tmpDicePoint+1);
    CCSpriteFrame *frame=[_animFramesArray objectAtIndex:tmpDicePoint];
    
    [_dice runAction:_diceAction];                                                      //执行动画
    [self performSelector:@selector(sotpDiceActionWithFrame:) withObject:frame afterDelay:1.0f];    //一秒后停止
    
    int realPoint=tmpDicePoint+1;
    return realPoint;
    //    if (!numOfPreparedPlane && dicePoint%2 ) {      //用户的飞机中没有处于预备状态的 ，点数又是奇数的话，直接到下一个用户，(isPlaneReady初始值为NO)
    //        //直接下一个用户
    //        NSLog(@"不是偶数，不能起飞.");
    //        return;
    //    }
}
-(void) sotpDiceActionWithFrame:(CCSpriteFrame *)frame{
    [_dice stopAction:_diceAction];
    [_dice setDisplayFrame:frame];
}

//其他飞机的动作
-(void) waitingForOpponentDo:(Player *)prePlayer{
    int playerNum=prePlayer.tag+1;
    Player *curPlayer=[self getplayerBytag:playerNum];
    NSLog(@"curPlayer.round=%d,_GameRound=%d",curPlayer.round,_GameRound);
    while (curPlayer.round==_GameRound) {
        curPlayer=[self getplayerBytag:++playerNum];
    }
    
    curPlayerCount--;                   //这一轮，第一个玩家已经结束.
    
    NSLog(@"剩余%d个玩家",curPlayerCount);
    if (curPlayerCount>0) {
        NSLog(@"————玩家%d———————",playerNum);
        [curPlayer setRound:_GameRound];
        
        curPoint=[self shakeDice];                                          //更新骰子数   NSNumber *point=[[NSNumber alloc] initWithInt:curPoint];         //包装点数
        if ((curPoint)%2 & (curPlayer.numOfPreparedPlane==0)) {
            NSLog(@"只有偶数才能起飞.下一玩家");
            [self performSelector:@selector(waitingForOpponentDo:) withObject:_player1 afterDelay:1.5f];
            return;
        }

        //奇数的话不能选没起飞的亲
        PlaneSprite *selectedPlane=[curPlayer.planeArray objectAtIndex:(arc4random()%(curPlayer.planeArray.count))];
        while ((selectedPlane.planePosition==-1) & (curPoint)%2) {
            selectedPlane=[curPlayer.planeArray objectAtIndex:(arc4random()%(curPlayer.planeArray.count))];
        }
        
        //NSLog(@"，自动选择 第%d辆飞机",selectedPlane.tag+1);
        
        NSString *token=@"performFly";
        NSMutableArray *dataPack=[[[NSMutableArray alloc] initWithObjects:token,selectedPlane,curPlayer, nil] autorelease];
        [self performSelector:@selector(sendPlayerAndPlane:) withObject:dataPack afterDelay:1.0f];
    }
    else{
        _player1.isUserCouldShakeDice=YES;
        NSLog(@"————————%d—end————————",_GameRound);
        return;
    }
    //第二个用户，必须的
    //        摇骰子
    //        是不是没有飞机准备？，是不是偶数是的话优先准备，有二的话优先起飞
    //        随机选一个，起飞
    //        下一位
    //用户数--，还有就第三个用户，没有的话 用户1可以摇骰子，然后return;
    
    //用户数--，还有就第四个用户，没有的话 用户1可以摇骰子
}

//中转传送数据，用于延时
-(void) sendPlayerAndPlane:(NSMutableArray *)dataPack{
    NSString *token=[dataPack objectAtIndex:0];
    PlaneSprite *selectedPlane=[dataPack objectAtIndex:1];
    Player *curPlayer=[dataPack objectAtIndex:2];
    if ([token isEqualToString:@"performFly"]) {
        [self disposePlane:selectedPlane Point:curPoint sender:curPlayer];
    }
    else if([token isEqualToString:@"Collide"]){
        [self disposeCollide:curPlayer plane:selectedPlane];
    }
}

-(void) disposeCollide:(Player *)curPlayer plane:(PlaneSprite *)selectPlane{
      
    //当前飞机的范围，遍历当前玩家的其他飞机，3次就行%tag;  有则向前飞行，并return
    //两个for遍历，遍历其他玩家，遍历改玩家的飞机，有则让它飞回起点，并return
    NSLog(@"检测碰撞");
    CGRect selectPlaneRect=CGRectMake(selectPlane.position.x-selectPlane.contentSize.width, selectPlane.position.y-selectPlane.contentSize.height, selectPlane.contentSize.width, selectPlane.contentSize.height); //创建边界矩形
    
    int otherPlaneTag=(selectPlane.tag+1)%(curPlayer.planeArray.count);
    while (otherPlaneTag!=selectPlane.tag) {
        NSLog(@"移动的飞机是%d,检测对象%d",selectPlane.tag,otherPlaneTag);
        PlaneSprite *plane=[curPlayer.planeArray objectAtIndex:otherPlaneTag];
        CGRect targetPlaneRect=CGRectMake(plane.position.x-plane.contentSize.width, plane.position.y-plane.contentSize.height, plane.contentSize.width, plane.contentSize.height);
        if (CGRectIntersectsRect(selectPlaneRect, targetPlaneRect)) {     //检测碰撞
            //自己的飞机，向前移动一格
            [self disposePlane:selectPlane Point:1 sender:curPlayer];
            return;
        }
        otherPlaneTag=(otherPlaneTag+1)%(curPlayer.planeArray.count);
    }
    /*
    for (int nextPlaneTag=0; nextPlaneTag<curPlayer.planeArray.count; nextPlaneTag++) {
        if (nextPlaneTag==selectPlane.tag) { continue;}
        
        PlaneSprite *plane=[curPlayer.planeArray objectAtIndex:nextPlaneTag];
        CGRect targetPlaneRect=CGRectMake(plane.position.x-plane.contentSize.width, plane.position.y-plane.contentSize.height, plane.contentSize.width, plane.contentSize.height);
        if (CGRectIntersectsRect(selectPlaneRect, targetPlaneRect)) {     //检测碰撞
            //自己的飞机，向前移动一格
            [self disposePlane:selectPlane Point:1 sender:curPlayer];
            return;
        }
    }*/
    
    
    int otherPlyaerTag=(curPlayer.tag+1)%(self.playerArray.count);
    while (otherPlyaerTag!=curPlayer.tag) {
        Player *player=[self getplayerBytag:otherPlyaerTag];
        for (PlaneSprite *plane in player.planeArray) {
            CGRect targetPlayerRect=CGRectMake(plane.position.x-plane.contentSize.width, plane.position.y-plane.contentSize.height, plane.contentSize.width, plane.contentSize.height);
            if (CGRectIntersectsRect(selectPlaneRect, targetPlayerRect)) {     //检测碰撞
                //把敌方飞机碰回起点
                Routes *unitRoute=[[[Routes alloc] init] autorelease];
                unitRoute=[player.routeArray objectAtIndex:0];
                id move2ready = [CCMoveTo actionWithDuration:UNIT_DURATION position:[unitRoute positionPoint]];
                [plane runAction:[CCSequence actions: move2ready, nil]];
                plane.planePosition=unitRoute.routeIndex;
                break;
            }
        }
        otherPlyaerTag=(otherPlyaerTag+1)%(self.playerArray.count);
    }
    
    NSLog(@"dispose结束.");
    [self performSelector:@selector(waitingForOpponentDo:) withObject:curPlayer afterDelay:UNIT_DURATION*2];

}

-(Player *) getplayerBytag:(int) tag{
    Player *thePlayer=nil;
    switch (tag) {
        case 0:
            thePlayer=_player1;
            break;
        case 1:
            thePlayer=_player2;
            break;
        case 2:
            thePlayer=_player3;
            break;
        case 3:
            thePlayer=_player4;
            break;
        default:
            break;
    }
    return thePlayer;
}
//转换方向
-(NSString *) TurnDirection:(NSString *)formerDirection{
    NSString *newDirection=@"";
    if ([formerDirection isEqualToString:@"l"]) {
        newDirection=@"d";
    }else if ([formerDirection isEqualToString:@"d"]) {
        newDirection=@"r";
    }else if ([formerDirection isEqualToString:@"r"]) {
        newDirection=@"u";
    }else if ([formerDirection isEqualToString:@"u"]) {
        newDirection=@"l";
    }
    return newDirection;
}


#pragma mark --------初始化玩家，飞机，路线时调用的方法-------
//初始化各个玩家
-(void) rootUser{
    CGPoint point1=CGPointMake(296, 374);
    NSMutableArray *planeArray1=[self initPlaneArrayWithImage:@"planeGreen.png"  firstPlanePosition:point1];
    _player1=[[Player alloc] intiWithPlaneArray:planeArray1 andRoutes:[self Route1]];
    [_player1 setIsUserCouldShakeDice:YES];     //玩家1一开始是可以摇骰子的
    [_player1 setTag:0];
    [_playerArray addObject:planeArray1];
    
    CGPoint point2=CGPointMake(51, 374);
    NSMutableArray *planeArray2=[self initPlaneArrayWithImage:@"planeYellow.png"  firstPlanePosition:point2];
    _player2=[[Player alloc] intiWithPlaneArray:planeArray2 andRoutes:[self Route2]];
    _player2.tag=1;
    [_playerArray addObject:planeArray2];
    
    if (_playerCount>=3) {
        CGPoint point3=CGPointMake(296, 128);
        NSMutableArray *planeArray3=[self initPlaneArrayWithImage:@"planeBlue.png" firstPlanePosition:point3];
        _player3=[[Player alloc] intiWithPlaneArray:planeArray3 andRoutes:[self Route3]];
        _player3.tag=2;
        [_playerArray addObject:planeArray3];
        if (_playerCount == 4) {
            CGPoint point4=CGPointMake(51, 128);
            NSMutableArray *planeArray4=[self initPlaneArrayWithImage:@"planeRed.png" firstPlanePosition:point4];
            _player4=[[Player alloc] intiWithPlaneArray:planeArray4 andRoutes:[self Route4]];
            _player4.tag=3;
            [_playerArray addObject:planeArray4];
        }
    }
}

//初始化飞机
-(NSMutableArray *) initPlaneArrayWithImage:(NSString *)Image firstPlanePosition:(CGPoint)point
{
    NSMutableArray *planeArray=[[[NSMutableArray alloc] init] autorelease];
    int tag=0;
    for (int i=0; i<2; i++) {  //加个j循环得到一个矩阵
        for (int j=0; j<2; j++) {
            PlaneSprite *plane=[PlaneSprite spriteWithFile:Image];
            plane.position=ccp(point.x-j*28, point.y-i*28);
            plane.planePosition=-1;
            plane.tag=tag;

            [self addChild:plane];
            [planeArray addObject:plane];
            tag++;
        }
    }
    return planeArray;
}

//初始化路线
-(NSMutableArray *) Route1{
    NSMutableArray *route1Array=[[[NSMutableArray alloc] init] autorelease];
    Routes *unitRoute=[[Routes alloc] init];
    for (int i=0; i<46; i++) {
        [unitRoute setRouteIndex:i];
        [route1Array addObject:unitRoute];
    }
    [unitRoute release];
    
    //    _route2Array=[NSMutableArray arrayWithArray:_route1Array];
    //    if (_playerCount>=3) {
    //        _route3Array=[NSMutableArray arrayWithArray:_route1Array];
    //    }
    //    if (_playerCount==4) {
    //        _route4Array=[NSMutableArray arrayWithArray:_route1Array];
    //    }
    
    Routes *readyPoint=[[Routes alloc] init];
    readyPoint.positionPoint=CGPointMake(214,373);
    readyPoint.routeIndex=0;
    [route1Array replaceObjectAtIndex:0 withObject:readyPoint];                                 //设置0为准备状态
    [readyPoint release];
    
    Routes *startPoint=[[Routes alloc] init];
    startPoint.positionPoint=CGPointMake(186,373);
    startPoint.routeIndex=1;
    startPoint.routeDirections=@"d";
    [route1Array replaceObjectAtIndex:1 withObject:startPoint];                                 //设置1为开始状态
    [startPoint release];
    
    [self setRouteDirections:route1Array changeDirections:@"l" which2change:5,31,39,nil];  //转左的
    [self setRouteDirections:route1Array changeDirections:@"r" which2change:11,19,25,nil];  //转右的
    [self setRouteDirections:route1Array changeDirections:@"u" which2change:21,29,35,nil];  //转上的
    [self setRouteDirections:route1Array changeDirections:@"d" which2change:9,15,40,nil];  //转下的
    return route1Array;
}

-(NSMutableArray *) Route2{
    NSMutableArray *route2Array=[[[NSMutableArray alloc] init] autorelease];
    Routes *unitRoute=[[Routes alloc] init];
    for (int i=0; i<46; i++) {
        [unitRoute setRouteIndex:i];
        [route2Array addObject:unitRoute];
    }
    [unitRoute release];

    //设置准备的位置
    Routes *readyPoint=[[Routes alloc] init];
    readyPoint.positionPoint=CGPointMake(24,292);
    readyPoint.routeIndex=0;
    [route2Array replaceObjectAtIndex:0 withObject:readyPoint];                                 
    [readyPoint release];
    
    //设置开始的位置
    Routes *startPoint=[[Routes alloc] init];
    startPoint.positionPoint=CGPointMake(24,264);
    startPoint.routeIndex=1;
    startPoint.routeDirections=@"l";
    [route2Array replaceObjectAtIndex:1 withObject:startPoint];                                
    [startPoint release];
    
    //设置转弯
    [self setRouteDirections:route2Array changeDirections:@"l" which2change:9,15,40,nil];  //转左的
    [self setRouteDirections:route2Array changeDirections:@"r" which2change:21,29,35,nil];  //转右的
    [self setRouteDirections:route2Array changeDirections:@"u" which2change:5,31,39,nil];  //转上的
    [self setRouteDirections:route2Array changeDirections:@"d" which2change:11,19,25,nil];  //转下的
    return route2Array;
}

-(NSMutableArray *) Route3{
    
    NSMutableArray *route3Array=[[[NSMutableArray alloc] init] autorelease];
    Routes *unitRoute=[[Routes alloc] init];
    for (int i=0; i<46; i++) {
        [unitRoute setRouteIndex:i];
        [route3Array addObject:unitRoute];
    }
    [unitRoute release];
    
    Routes *readyPoint=[[Routes alloc] init];
    readyPoint.positionPoint=CGPointMake(295, 183);
    readyPoint.routeIndex=0;
    [route3Array replaceObjectAtIndex:0 withObject:readyPoint];                                 //设置0为准备状态
    [readyPoint release];
    
    Routes *startPoint=[[Routes alloc] init];
    startPoint.positionPoint=CGPointMake(295, 211);
    startPoint.routeIndex=1;
    startPoint.routeDirections=@"r";
    [route3Array replaceObjectAtIndex:1 withObject:startPoint];                                 //设置1为开始状态
    [startPoint release];
    
    [self setRouteDirections:route3Array changeDirections:@"l" which2change:21,29,35,nil];  //转左的
    [self setRouteDirections:route3Array changeDirections:@"r" which2change:9,15,40,nil];  //转右的
    [self setRouteDirections:route3Array changeDirections:@"u" which2change:11,19,25,nil];  //转上的
    [self setRouteDirections:route3Array changeDirections:@"d" which2change:5,31,39,nil];  //转下的
    return route3Array;
}

-(NSMutableArray *) Route4{
    NSMutableArray *route4Array=[[[NSMutableArray alloc] init] autorelease];
    Routes *unitRoute=[[Routes alloc] init];
    for (int i=0; i<46; i++) {
        [unitRoute setRouteIndex:i];
        [route4Array addObject:unitRoute];
    }
    [unitRoute release];
 
    
    Routes *readyPoint=[[Routes alloc] init];
    readyPoint.positionPoint=CGPointMake(106,102);
    readyPoint.routeIndex=0;
    [route4Array replaceObjectAtIndex:0 withObject:readyPoint];                                 //设置0为准备状态
    [readyPoint release];
    
    Routes *startPoint=[[Routes alloc] init];
    startPoint.positionPoint=CGPointMake(134,102);
    startPoint.routeIndex=1;
    startPoint.routeDirections=@"u";
    [route4Array replaceObjectAtIndex:1 withObject:startPoint];                                 //设置1为开始状态
    [startPoint release];
    
    [self setRouteDirections:route4Array changeDirections:@"l" which2change:11,19,25,nil];  //转左的
    [self setRouteDirections:route4Array changeDirections:@"r" which2change:5,31,39,nil];  //转右的
    [self setRouteDirections:route4Array changeDirections:@"u" which2change:9,15,40,nil];  //转上的
    [self setRouteDirections:route4Array changeDirections:@"d" which2change:21,29,35,nil];  //转下的
    return route4Array;
}

//更改某些单元格的方向
-(void) setRouteDirections:(NSMutableArray *)routeArray changeDirections:(NSString *)directions which2change:(NSInteger) index1,...{
    va_list arg_ptr;                         //定义一个指向个数可变的参数列表指针arg_ptr；
    va_start(arg_ptr, index1);               //使参数列表指针arg_ptr指向函数参数列表中的第一个可选参数
    NSInteger index=index1;
    while(index){
        Routes *route=[[Routes alloc] init];
        route.needChangeDirections=YES;
        route.routeDirections=directions;
        route.routeIndex=index;
        [routeArray replaceObjectAtIndex:index withObject:route];
        [route release];
        index=va_arg(arg_ptr, NSInteger);    //返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数。
    }
    va_end(arg_ptr);                         //清空参数列表，并置参数指针arg_ptr无效。在调用的时候要在参数结尾的时候加nil
}

- (void) MianMenu{
    [SceneManager go2menu];
}

-(void) dealloc{
    _dice=nil;                    
    _diceAction=nil;             
    _diceActionArray=nil;
    _animFramesArray=nil;
    
    _playerArray=nil;
    _player1=nil;
    _player2=nil;
    _player3=nil;
    _player4=nil;

    [super dealloc];
}

@end


