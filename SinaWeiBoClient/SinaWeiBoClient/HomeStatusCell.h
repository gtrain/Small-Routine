//
//  HomeStatusCell.h
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 246.0f
#define CELL_CONTENT_MARGIN 50.0f
#define CELL_CONTENT_MARGIN_Top 40.0f
#define CELL_CONTENT_MARGIN_Left 68.0f


#import <UIKit/UIKit.h>
#import "Status.h"

@interface HomeStatusCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *weiboAvatar;       //微博post主头像
@property (retain, nonatomic) IBOutlet UILabel *weiboBloger;           //微博post主
@property (retain, nonatomic) IBOutlet UILabel *weiboTime;             //微博发布时间
@property (retain, nonatomic) IBOutlet UILabel *weiboSource;           //微博来源，（通过什么客户端）
@property (retain, nonatomic) IBOutlet UILabel *weiboTranspond;        //微博转发
@property (retain, nonatomic) IBOutlet UILabel *weiboComment;          //微博评论


//@property (retain, nonatomic) IBOutlet UITextView *weiboContent;       //微博
//@property (retain, nonatomic) IBOutlet UIImageView *weiboImage;        //微博图片
@property (retain, nonatomic) IBOutlet UITextView *weiboContentTextView;            //微博内容
@property (retain, nonatomic) IBOutlet UITextView *retwitterWeiboContentTextView;   //转发内容
@property (retain, nonatomic) IBOutlet UIImageView *thumbnailPicView;

-(void) reLoadWithStatus:(Status *)status withTextViewFrame:(CGRect)frame andReTextViewFrame:(CGRect)reFrame;

@end
