//
//  OAuthViewController.h
//  WeiboClient_yzq
//
//  Created by yang on 13-2-8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OAuthViewController : UIViewController<UIWebViewDelegate>{
    UIActivityIndicatorView *indicatorView;         //页面载入时的旋转圈圈
}

@property (strong,nonatomic) NSURL *url;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancel:(UIBarButtonItem *)sender;

@end
