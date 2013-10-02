//
//  GameOver.h
//  FlyingChess_
//
//  Created by yzq on 12-12-4.
//
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
	CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
-(id) initWithString:(NSString *) str;
@end



@interface GameOver : CCScene{
    GameOverLayer *_layer;
}
-(id) initWithLabel:(NSString *) labelMsg;
@property (nonatomic, retain) GameOverLayer *layer;
@end
