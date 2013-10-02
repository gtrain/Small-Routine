//
//  OAuthViewController.m
//  WeiboClient_yzq
//
//  Created by yang on 13-2-8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "OAuthViewController.h"

@interface OAuthViewController ()

@end

@implementation OAuthViewController
@synthesize webView;
- (void)dealloc {
    [webView release];
    self.url=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate=self;
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:_url];
    [self.webView loadRequest:request];
    [request release];

    //self.navigationItem.hidesBackButton = NO;

    indicatorView =[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [indicatorView startAnimating];
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





#pragma mark ----UIWebViewDelegate----

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    [indicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //[indicatorView stopAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url = %@", url);
    
    NSString *siteRedirectURI = [NSString stringWithFormat:@"%@%@", SINAWEIBOOAuth2APIDomain, APPREDIRECTURI];
    
    //如果是回调网站（应用回调或者网站回调两种），则关闭页面（不显示）
    if ([url hasPrefix:APPREDIRECTURI] || [url hasPrefix:siteRedirectURI])
    {
        //如果包含error代码,输出相关error信息
        NSString *error_code = [self getParamValueFromUrl:url paramName:@"error_code"];
        if (error_code)
        {
            NSString *error = [self getParamValueFromUrl:url paramName:@"error"];
            NSString *error_uri = [self getParamValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [self getParamValueFromUrl:url paramName:@"error_description"];
            
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       error, @"error",
                                       error_uri, @"error_uri",
                                       error_code, @"error_code",
                                       error_description, @"error_description", nil];
            NSLog(@"errorInfo:%@",errorInfo);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {   //认证通过，截获code码
            NSString *code = [self getParamValueFromUrl:url paramName:@"code"];
            NSLog(@"认证通过");
            if (code)
            {
                //[self dismissModalViewControllerAnimated:YES];  Animated:NO, 不要做动画了，要不就只能if an
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:code,@"code", nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"上传code");
                    [[NSNotificationCenter defaultCenter] postNotificationName:DIDGETCODE object:nil userInfo:dic];
                }];
            }
        }
        return NO;
        //
    }
    return YES;
}

-(NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="]) //给参数名加上=号
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
