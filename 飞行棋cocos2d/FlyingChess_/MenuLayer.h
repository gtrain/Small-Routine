//
//  MenuLayer.h
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "cocos2d.h"
#import "SceneManager.h"
#import "GameLayer.h"
//#import "CreditsLayer.h"

@interface MenuLayer : CCLayer {
}

//- (void)onNewGame:(id)sender;
- (void)onIntro:(id)sender;

-(void) onModelSelect:(id) sender;
@end
