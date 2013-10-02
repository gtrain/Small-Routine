//
//  GameOver.m
//  FlyingChess_
//
//  Created by yzq on 12-12-4.
//
//

#import "GameOver.h"
#import "SceneManager.h"

@implementation GameOver
@synthesize layer=_layer;

-(id) initWithLabel:(NSString *)labelMsg{
    if ((self=[super init])) {
        GameOverLayer *txtLayer=[[[GameOverLayer alloc] initWithString:labelMsg] autorelease];
		[self setLayer:txtLayer];
        
		[self addChild:_layer];
        
    }
    return self;
    
//        CCLabelTTF *label=[[[CCLabelTTF alloc] initWithString:labelMsg fontName:@"Arial" fontSize:32] autorelease];
//        //[label setString:labelMsg];
//        CGSize winsize=[[CCDirector sharedDirector] winSize];
//        //label=[CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
//        
//        label.color=ccc3(0, 0, 0);
//        label.position=ccp(winsize.width/2, winsize.height/2);
//        
//        [self addChild:label];
//        
//        CCSprite *menuBg=[CCSprite spriteWithFile:@"MenuBg.png"];
//        menuBg.position=ccp(160, 240);
//        [self addChild:menuBg z:0];

}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}
@end





@implementation GameOverLayer
@synthesize label = _label;

-(id) initWithString:(NSString *) str{
    self=[super initWithColor:ccc4(255, 255, 255, 255)];
    if (self) {
        CGSize winsize=[[CCDirector sharedDirector] winSize];
        self.label=[CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:32];
        _label.color=ccc3(0, 0, 0);
        _label.position=ccp(winsize.width/2, winsize.height/2);
        [self addChild:_label];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],[CCCallFuncN actionWithTarget:self selector:@selector(gameOverDone)],nil]];
    }
    return  self;
}

-(void) gameOverDone{
    NSLog(@"返回主菜单");
    [SceneManager go2menu];
}

-(void) dealloc{
    [_label release];
    _label=nil;
    [super dealloc];
}

@end
