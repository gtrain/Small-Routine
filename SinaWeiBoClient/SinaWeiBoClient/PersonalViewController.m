//
//  PersonalViewController.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-22.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)dealloc {
    self.statusArray=nil;
    self.requestEngine=nil;
    [_personalTableView release];
    [_userProfilePic release];
    [_userName release];
    [_userFollowers release];
    [_userFriends release];
    [_userStatusCount release];
    [_userDescription release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetPersonalInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetPersonalAvatar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetPersonalStatus object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetImagesStatus object:nil];
    [_refreshBtn release];
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
    _personalTableView.delegate=self;
    _personalTableView.dataSource=self;
    
    self.statusArray=nil;
    self.requestEngine=[[RequestEngine alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandlePersonalInfo:) name:DidGetPersonalInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandlePersonaStatus:) name:DidGetPersonalStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTableCellImg:) name:DidGetImagesStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowAvatar:) name:DidGetPersonalAvatar object:nil];
    //注册通知在viewDidLoad就行了，防止多次注册
    
    [self GetPersonalInfo]; //注册通知，然后开始获取用户资料
}

-(void) GetPersonalInfo{
    self.refreshBtn.title=@"载入中...";
    NSString *uid=[[NSUserDefaults standardUserDefaults] objectForKey:USER_USER_ID];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCESS_TOKEN];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token,USER_ACCESS_TOKEN,
                                                                        uid,USER_USER_ID,nil];
    NSURL* url = [RequestEngine serializeURL:SINAweiboPersonalInfo params:params];
    [_requestEngine addRequestWithUrl:url Method:@"GET" Tag:GetPersonalInfo];
    [self GetPersonalStatus];
}
-(void) GetPersonalStatus{
    NSString *uid=[[NSUserDefaults standardUserDefaults] objectForKey:USER_USER_ID];
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCESS_TOKEN];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token,USER_ACCESS_TOKEN,
                            uid,USER_USER_ID,nil];
    NSURL* url = [RequestEngine serializeURL:SINAweiboPersonalStatus params:params];
    [_requestEngine addRequestWithUrl:url Method:@"GET" Tag:GetPersonalStatus];
}

-(void) HandlePersonalInfo:(NSNotification *)notify{
    if (!self.view.window) {
        //NSLog(@"已经离开视图");
        return;
    }
    
    NSURL *url=[NSURL URLWithString:[notify.userInfo objectForKey:@"avatar_large"]];
    [_requestEngine addRequestWithUrl:url Method:@"GET" Tag:GetPersonalAvatar];
    
    self.userName.text=[notify.userInfo objectForKey:@"screen_name"];
    NSString *userFollowersCount=[NSString stringWithFormat:@"粉丝:%@", [notify.userInfo objectForKey:@"followers_count"]];
    [self.userFollowers setTitle:userFollowersCount forState:UIControlStateNormal];
    NSString *userFriendsCount=[NSString stringWithFormat:@"关注:%@", [notify.userInfo objectForKey:@"friends_count"]];
    [self.userFriends setTitle:userFriendsCount forState:UIControlStateNormal];
    NSString *userStatusCount=[NSString stringWithFormat:@"微博:%@", [notify.userInfo objectForKey:@"statuses_count"]];
    [self.userStatusCount setTitle:userStatusCount forState:UIControlStateNormal];
    self.userDescription.text=[NSString stringWithFormat:@"简介：%@",[notify.userInfo objectForKey:@"description"]];

}
-(void) ShowAvatar:(NSNotification *)notify{
    if (!self.view.window) {
        //NSLog(@"已经离开视图");
        return;
    }
    UIImage *avatarImg=[[UIImage alloc] initWithData:[notify.userInfo objectForKey:@"avaterData"]];
    self.userProfilePic.image=avatarImg;
    [avatarImg release];
}

-(void) HandlePersonaStatus:(NSNotification *)notify{
    if (!self.view.window) {
        //NSLog(@"已经离开视图");
        return;
    }
    
    NSArray *weiboArray=[notify.userInfo objectForKey:@"statuses"];
    NSMutableArray *tempArray=[[NSMutableArray alloc] init];
    for (int i=0; i<weiboArray.count; i++) {
        id weiboItemDictionary=[weiboArray objectAtIndex:i];
        Status *status=[Status statusWithJsonDictionary:weiboItemDictionary];
        status.weiboCellIndex=[NSNumber numberWithInt:i];
        [tempArray addObject:status];
    }
    
    self.statusArray=[NSMutableArray arrayWithArray:tempArray];
    [self.personalTableView reloadData];
    
    //文字数据已经reload,可以获取图片数据了
    for (Status *status in _statusArray) {
        [status getImagesDate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) ReloadTableCellImg:(NSNotification *)notify{
    self.refreshBtn.title=@"刷新";
    if (!self.view.window) {
        return;
    }
    
    NSInteger cellIndex=[[notify.userInfo objectForKey:WeiboCellIndexKey] intValue];
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    NSArray *indexArray = [NSArray arrayWithObject:indexPath];
    [self.personalTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:NO];         //reload table cell,不reload的话就只能等回收利用的时候重新加载了
}


#pragma mark ---UITableViewDataSource---
//table的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _statusArray.count;
}
//填充cell数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    static NSString *cellIdentifier=@"homeStatusCell";
    HomeStatusCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        cell=[[HomeStatusCell alloc] init];
    }
    //cell应该在if里面赋值还是应该在外面？  如果回收的cell已经有值的话，是应该放在里面的对吧？  不对,这样reload就不能设置了
    
    Status *status = [_statusArray objectAtIndex:[indexPath row]];
    NSString *text=status.weiboContent;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN*2, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame=CGRectMake(CELL_CONTENT_MARGIN_Left, CELL_CONTENT_MARGIN_Top, CELL_CONTENT_WIDTH, MAX(size.height, 44.0f));
    Status *retwitterStatus=status.retweetedStatus;
    NSString *statusImgUrl=status.weibothumbnailPicUrl;
    NSString *retwitterStatusImgUrl=retwitterStatus.weibothumbnailPicUrl;
    
    CGRect reFrame=CGRectMake(0, 0, 0, 0);
    //有转发的画要加上转发的高度
    if (retwitterStatus) {
        NSString *reText=retwitterStatus.weiboContent;
        CGSize reConstraint = CGSizeMake(CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN*2, 20000.0f);
        CGSize reSize = [reText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:reConstraint lineBreakMode:NSLineBreakByWordWrapping];
        reFrame=CGRectMake(CELL_CONTENT_MARGIN_Left, frame.size.height+frame.origin.y, CELL_CONTENT_WIDTH, MAX(reSize.height, 44.0f));
        //如果有图片 转发那个+100
        if (statusImgUrl || retwitterStatusImgUrl) {
            reFrame.size.height += 80;
        }
    }else{
        //如果有图片  主微博 +100
        if (statusImgUrl || retwitterStatusImgUrl) {
            frame.size.height += 80;
        }
    }
    [cell reLoadWithStatus:[_statusArray objectAtIndex:row] withTextViewFrame:frame andReTextViewFrame:reFrame];
    return cell;
}

#pragma mark --UITableViewDelegate--
//计算行高

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Status *status = [_statusArray objectAtIndex:[indexPath row]];
    
    NSString *text=status.weiboContent;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = MAX(size.height, 44.0f);
    
    NSString *statusImgUrl=status.weibothumbnailPicUrl;
    Status *retwitterStatus=status.retweetedStatus;
    NSString *retwitterStatusImgUrl=retwitterStatus.weibothumbnailPicUrl;
    
    //有转发的画要加上转发的高度
    if (retwitterStatus) {
        NSString *retwitterText=retwitterStatus.weiboContent;
        CGSize retwitterConstraint = CGSizeMake(CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN/2 , 20000.0f);
        CGSize retwitterSize=[retwitterText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:retwitterConstraint lineBreakMode:NSLineBreakByWordWrapping];
        cellHeight += MAX(retwitterSize.height, 44.0f);
    }
    
    //如果有图片
    if (statusImgUrl || retwitterStatusImgUrl) {
        cellHeight += 100;
    }
    
    return cellHeight + (CELL_CONTENT_MARGIN * 2) + 80;
}

- (void)viewDidUnload {
    [self setRefreshBtn:nil];
    [super viewDidUnload];
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self GetPersonalInfo];
}
@end
