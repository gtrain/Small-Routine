//
//  HomePageViewController.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-3-14.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "HomeViewController.h"



@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)dealloc {
    [_homeTableView release];
    self.requestEngine=nil;
    self.statusArray=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetHomeStatus object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetImagesStatus object:nil];
    
    [_refreshBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _homeTableView.delegate=self;
    _homeTableView.dataSource=self;
    
    self.statusArray=nil;
    self.requestEngine=[[RequestEngine alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleHomeStatus:) name:DidGetHomeStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTableCellImg:) name:DidGetImagesStatus object:nil];
    
    
    [self GetHomeStatus];
}

-(void) GetHomeStatus{
    self.refreshBtn.title=@"载入中..";
    
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCESS_TOKEN];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: token,USER_ACCESS_TOKEN,nil];
    NSURL* url = [RequestEngine serializeURL:SINAweiboHomeStatuses params:params];
    [_requestEngine addRequestWithUrl:url Method:@"GET" Tag:GetHomeStatus];
}
-(void) HandleHomeStatus:(NSNotification *)notify{
    self.refreshBtn.title=@"刷新";
    //获取最新的公共微博
    if (!self.homeTableView.window) {
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
    [_homeTableView reloadData];
    
    //返回到第一章节的第一行
    if (_homeTableView.numberOfSections) {
        [self.homeTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    //文字数据已经reload,可以获取图片数据了
    for (Status *status in _statusArray) {
        [status getImagesDate];
    }
    
}

-(void) ReloadTableCellImg:(NSNotification *)notify{
    if (!self.view.window) {
        //NSLog(@"已经离开视图");
        return;
    }
    
    NSInteger cellIndex=[[notify.userInfo objectForKey:WeiboCellIndexKey] intValue];
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    NSArray *indexArray = [NSArray arrayWithObject:indexPath];
    [self.homeTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:NO];         //reload table cell,不reload的话就只能等回收利用的时候重新加载了
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        //_mark 没有设置identify的！！
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

- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [self GetHomeStatus];       //发送请求
    //[self.tableView setContentOffset:CGPointMake(0, 20) animated:YES];  
}
- (void)viewDidUnload {
    [self setRefreshBtn:nil];
    [super viewDidUnload];
}
@end









