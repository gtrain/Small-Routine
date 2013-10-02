//
//  MenuLayer.m
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer

-(id) init{
	self = [super init];
    if (self) {
        //lable 纯文本
//        CCLabelTTF *intro = [CCLabelTTF labelWithString:@"左边" fontName:@"Marker Felt" fontSize:40];
//        intro.position = ccp(160, 345);
//        [self addChild: intro];
        
        CCMenuItemImage *startNew=[CCMenuItemImage itemFromNormalImage:@"newGameItem.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onModelSelect:)];
        CCMenuItemImage *charts=[CCMenuItemImage itemFromNormalImage:@"RankingItem.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onWin:)];
        CCMenuItemImage *intro=[CCMenuItemImage itemFromNormalImage:@"aboutItem.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onIntro:)];
        //CCMenuItemFont *intro = [CCMenuItemFont itemFromString:@"Intro" target:self selector: @selector(onIntro:)];
        
        //创建个菜单，添加菜单项进来
        CCMenu *menu = [CCMenu menuWithItems:startNew,  charts, intro, nil];
        menu.position = ccp(160, 280);
        [menu alignItemsVerticallyWithPadding: 0.0f];
        [self addChild:menu z: 2];
        
        CCSprite *menuBg=[CCSprite spriteWithFile:@"MenuBg.png"];
        menuBg.position=ccp(160, 240);
        [self addChild:menuBg z:0];
    }
	return self;
}

-(void) onModelSelect:(id) sender{
    [SceneManager go2select];
}
 
- (void)onWin:(id)sender{
    [SceneManager go2GameOver:@"YOU WIN!"];
}

- (void)onIntro:(id)sender{
	[SceneManager go2intro];
}
@end
