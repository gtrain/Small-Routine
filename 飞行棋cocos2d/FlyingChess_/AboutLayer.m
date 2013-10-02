//
//  AboutLayer.m
//  FlyingChess_
//
//  Created by yzq on 12-12-15.
//
//

#import "AboutLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"

@implementation AboutLayer

-(id) init{
	self = [super init];
    if (self) {
        //lable 纯文本
        //        CCLabelTTF *intro = [CCLabelTTF labelWithString:@"左边" fontName:@"Marker Felt" fontSize:40];
        //        intro.position = ccp(160, 345);
        //        [self addChild: intro];
        
        CCMenuItemImage *goBack=[CCMenuItemImage itemFromNormalImage:@"backBtn.png" selectedImage:nil disabledImage:nil target:self selector:@selector(MianMenu)];
        //CCMenuItemImage *startNew=[CCMenuItemImage itemFromNormalImage:@"backBtn.png" selectedImage:nil];
        
        //startNew.position = ccp(160, 280);
        //创建个菜单，添加菜单项进来
        CCMenu *menu = [CCMenu menuWithItems:goBack,nil];
        menu.position = ccp(160, 50);
        //[menu alignItemsVerticallyWithPadding: 0.0f];
        [self addChild:menu z: 2];
        
        CCSprite *menuBg=[CCSprite spriteWithFile:@"about.png"];
        menuBg.position=ccp(160, 240);
        [self addChild:menuBg z:0];
    }
	return self;
}

- (void) MianMenu{
    [SceneManager go2menu];
}

@end
