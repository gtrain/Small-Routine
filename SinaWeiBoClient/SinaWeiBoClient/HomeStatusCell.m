//
//  HomeStatusCell.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "HomeStatusCell.h"

@implementation HomeStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id) init{
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(void) reLoadWithStatus:(Status *)status withTextViewFrame:(CGRect)frame andReTextViewFrame:(CGRect)reFrame{
    _weiboContentTextView.frame=frame;      //_weiboContentTextView.editable=NO;
    _weiboContentTextView.text=status.weiboContent;
    
    if (status.retweetedStatus) {
        _retwitterWeiboContentTextView.hidden=NO;
        _retwitterWeiboContentTextView.frame=reFrame;
        _retwitterWeiboContentTextView.text=status.retweetedStatus.weiboContent;
        
        if (status.retweetedStatus.weibothumbnailPicUrl) {  
            UIImage *image=[[UIImage alloc] initWithData:status.retweetedStatus.weiboThumbnailPicData];
            if (image) {        //第一个image会是null，为什么？
                float ratio=fmax(image.size.width/80.0,image.size.height/80.0);
                CGSize imageSize = CGSizeMake (image.size.width/ratio,image.size.height/ratio);
                CGRect imgFrame = CGRectMake(reFrame.origin.x + 10 , reFrame.size.height+reFrame.origin.y-100, imageSize.width , imageSize.height);
                //为了“嵌入”微博的框里面，这里的y要-80，或者100
                self.thumbnailPicView.hidden=NO;
                self.thumbnailPicView.frame=imgFrame;
                _thumbnailPicView.image = image;
                [image release];
            }
        }else{
            self.thumbnailPicView.hidden=YES;
        }
    }
    else{
        if (status.weibothumbnailPicUrl) {
            _retwitterWeiboContentTextView.hidden=YES;
            UIImage *image=[[UIImage alloc] initWithData:status.weiboThumbnailPicData];
            if (image) {        //第一个image会是null，为什么？
                float ratio=fmax(image.size.width/80.0,image.size.height/80.0);
                CGSize imageSize = CGSizeMake (image.size.width/ratio,image.size.height/ratio);
                CGRect imgFrame = CGRectMake(frame.origin.x + 10 , frame.size.height+frame.origin.y-90, imageSize.width , imageSize.height);
                //为了“嵌入”微博的框里面，这里的y要-80，或者100
                self.thumbnailPicView.hidden=NO;
                self.thumbnailPicView.frame=imgFrame;
                _thumbnailPicView.image = image;
                [image release];
            }else{
                self.thumbnailPicView.hidden=YES;
            }
        }
    }
    
    self.weiboBloger.text=status.user.userScreenName;
    self.weiboTime.text=status.weiboCreatedTime;
    self.weiboSource.text=status.weiboSource;
    self.weiboTranspond.text=[NSString stringWithFormat:@"转发:%@",status.weiboRepostsCount];
    self.weiboComment.text=[NSString stringWithFormat:@"评论：%@",status.weiboCommentsCount];

    if (status.user.userProfilePicData) {
        self.weiboAvatar.image=[UIImage imageWithData:status.user.userProfilePicData];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc {
    [_weiboAvatar release];
    [_weiboBloger release];
    [_weiboTime release];
    [_weiboSource release];
    [_weiboTranspond release];
    [_weiboComment release];
    [super dealloc];
}

@end
