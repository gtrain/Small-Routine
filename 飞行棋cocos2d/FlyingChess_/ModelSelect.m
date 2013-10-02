//
//  ModelSelect.m
//  FlyingChess_
//
//  Created by yzq on 12-10-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModelSelect.h"


@implementation ModelSelect


-(id) init{
	self = [super init];
    if (self) {
        //两个菜单项，这里是文字类型
        CCMenuItemImage *twoFight=[CCMenuItemImage itemFromNormalImage:@"two.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onNewGame:)];
        [twoFight setTag:2];
        
        CCMenuItemImage *thereFight=[CCMenuItemImage itemFromNormalImage:@"there.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onNewGame:)];
        [thereFight setTag:3];
        
        CCMenuItemImage *fourFight=[CCMenuItemImage itemFromNormalImage:@"four.png" selectedImage:nil disabledImage:nil target:self selector:@selector(onNewGame:)];
        [fourFight setTag:4];

        //创建个菜单，添加菜单项进来
        CCMenu *menu = [CCMenu menuWithItems:twoFight, thereFight, fourFight,nil];
        menu.position = ccp(160, 280);
        [menu alignItemsVerticallyWithPadding: 0.0f];   //垂直间距
        [self addChild:menu z: 2];
        
        CCSprite *menuBg=[CCSprite spriteWithFile:@"num.png"];
        menuBg.position=ccp(160, 240);
        [self addChild:menuBg z:0];
    }
	return self;
}


- (void)onNewGame:(id) sender{
    CCMenuItemFont *item = sender;
    [SceneManager go2play:item.tag];
}

@end
