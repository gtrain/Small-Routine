//
//  TweetingViewController.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-5-17.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "TweetingViewController.h"
#import "ASIFormDataRequest.h"

@interface TweetingViewController ()

@end

@implementation TweetingViewController

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
	self.requestEngine=[[RequestEngine alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendBtn:(UIBarButtonItem *)sender {
    NSURL *url = [NSURL URLWithString:URL_POSTSTATUSES];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCESS_TOKEN];
    NSString *content=[self.textContent.text isEqualToString:@""] ? [NSString stringWithFormat:@"test post status : %@", [NSDate date]] :self.textContent.text;
    
    ASIFormDataRequest *requestItem = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestItem setPostValue:content forKey:USER_STATUS];
    [requestItem setPostValue:authToken forKey:USER_ACCESS_TOKEN];

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:SinaPostText] forKey:@"requestType"];
    [requestItem setUserInfo:dict];
    [dict release];
    [_requestEngine addRequestWithRequest:requestItem Method:@"POST" Tag:PostStatus];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_textContent release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextContent:nil];
    [super viewDidUnload];
}
@end
