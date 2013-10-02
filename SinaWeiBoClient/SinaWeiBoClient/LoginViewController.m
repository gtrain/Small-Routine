//
//  LoginViewController.m
//  WeiboClient_yzq
//
//  Created by yang on 13-2-8.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark --ViewLifeCycle--
-(void) dealloc{
    self.userInfo=nil;
    self.requestEngine=nil;
    self.managedObjectContext=nil;
    self.managedObjectModel=nil;
    self.persistentStoreCoordinator=nil;
    self.usersArray=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDGETCODE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetAccessToken object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidGetPersonalInfo object:nil];
    [_indicatorView release];
    [_usersTable release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setUsersTable:nil];
    self.indicatorView=nil;
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidLoad{
    //设置nav
    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor brownColor]];
    UILabel *titleLabe=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, self.navigationController.navigationBar.bounds.size.width,self.navigationController.navigationBar.bounds.size.height)];
    titleLabe.textColor=[UIColor blackColor];
    [titleLabe setBackgroundColor:[UIColor clearColor]];
    titleLabe.text=@"登陆";
    [titleLabe setTextAlignment:NSTextAlignmentCenter];
    //标题，这里用items数组添加
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.titleView=titleLabe;
    //item.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];          //注意这里的target是self.viewDeckController
    NSArray *items = [[NSArray alloc]initWithObjects:item,nil];
    [self.navigationController.navigationBar setItems:items];
//    //左按钮，这里直接加到view上
//    UIButton *leftBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 42)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"alpha"] forState:UIControlStateNormal];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"LeftNavBtnSelect"] forState:UIControlStateHighlighted];
//    [leftBtn addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftBtn];
//    //右按钮，
//    UIButton *rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(ViewBoundsSize.width-50, 0, 50, 43)];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"alpha"] forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"RightNavBtnSelect"] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightBtn];
    
    
    
    self.usersTable.delegate=self;
    self.usersTable.dataSource=self;
    [self LoadCoreData];
    //获取用户资料时，这里也进行接受，用于更新用户名显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserName:) name:DidGetPersonalInfo object:nil];
    
    //如果用户已登陆且不过期，执行跳转，否则注册通知，准备接收新用户的授权信息
    if (![self DidUserLogin]) {
        _requestEngine=[[RequestEngine alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetTokenByCode:) name:DIDGETCODE object:nil]; //获取code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleAccessToken:) name:DidGetAccessToken object:nil]; //获取token
    }
    else{
        self.requestEngine=nil;
        [self performSegueWithIdentifier:@"TabSegue" sender:nil];
    }
}
//判断是否有“没过期”的用户资料
-(BOOL) DidUserLogin{
    NSDate *expirationDate=[[NSUserDefaults standardUserDefaults] objectForKey:USER_EXPIRATION_DATE];
    NSDate *now = [NSDate date];
    NSLog(@"now:%@,expirationDate:%@",now,expirationDate);
    //如果已经有用户数据，而且没有过期
    return ((expirationDate != nil) && ([expirationDate compare:now] == NSOrderedDescending));
}
//加载CoreData中的用户资料
-(void) LoadCoreData{
    NSString *modelPath=[[NSBundle mainBundle] pathForResource:@"weiboDataStorage" ofType:@"momd"];
    NSURL *modelUrl=[NSURL fileURLWithPath:modelPath];
    self.managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    NSError *error=nil;
    NSURL *storeUrl=nil;
    storeUrl=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    storeUrl=[storeUrl URLByAppendingPathComponent:@"weiboDataStorage.sqlite"];
    NSLog(@"storeUrl:%@",storeUrl);
    self.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
    self.managedObjectContext=[[NSManagedObjectContext alloc] init];
    _managedObjectContext.persistentStoreCoordinator=_persistentStoreCoordinator;
    _managedObjectContext.mergePolicy=NSOverwriteMergePolicy;
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UsersCoreData" inManagedObjectContext:_managedObjectContext];
    fetchRequest.entity=entityDescription;
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(access_token!=%@)",@""];
//    fetchRequest.predicate=predicate;
    NSArray *array=[_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [fetchRequest release];
    self.usersArray=[NSMutableArray arrayWithArray:array];
}

#pragma mark --NSNotificationCenter	event--
//
-(void) GetTokenByCode:(NSNotification *)notify{
    NSString *code=[notify.userInfo objectForKey:@"code"];
    NSLog(@"获取到code:%@",code);
    //NSString *code =[[NSUserDefaults standardUserDefaults] objectForKey:USER_CODE];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            APPKEY, @"client_id",
                            APPSECRET, @"client_secret",
                            @"authorization_code", @"grant_type",
                            APPREDIRECTURI, @"redirect_uri",
                            code, @"code", nil];
    NSURL* url = [RequestEngine serializeURL:SINAWEIBOWebAccessTokenURL params:params];
    [_requestEngine addRequestWithUrl:url Method:@"POST" Tag:GetAccessToken];
}
-(void) HandleAccessToken:(NSNotification *)notify{
    NSLog(@"用户资料：%@",notify.userInfo);
    //存放到standerUserDefaulets，作为默认的用户
    NSString *accessToken = [notify.userInfo objectForKey:@"access_token"];
    NSString *userID = [notify.userInfo objectForKey:@"uid"];
    NSString *remind_in = [notify.userInfo objectForKey:@"remind_in"];
    NSDate *expirationDate=nil;
    if (remind_in != nil)
    {
        int expVal = [remind_in intValue];
        expirationDate =  expVal == 0 ? [NSDate distantFuture]:[NSDate dateWithTimeIntervalSinceNow:expVal];
    }
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:USER_EXPIRATION_DATE];
    
    //插入或更新coreData的数据
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UsersCoreData" inManagedObjectContext:_managedObjectContext];
    fetchRequest.entity=entityDescription;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(uid==%@)",userID];
    fetchRequest.predicate=predicate;
    //NSUInteger existCount=[_managedObjectContext countForFetchRequest:fetchRequest error:nil];
    NSArray *arrayTmp=[_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (arrayTmp.count==0) {
        NSError *error=nil;
        UsersCoreData *userInfo=[[UsersCoreData alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:_managedObjectContext];
        userInfo.uid=userID;
        userInfo.access_token=accessToken;
        userInfo.expires_in=expirationDate;
        [_managedObjectContext insertObject:userInfo];
        //handel error   if (!)
        [_managedObjectContext save:&error];
        [userInfo release];
    }else{
        for (UsersCoreData *userTmp in arrayTmp) {
            userTmp.access_token=accessToken;
            userTmp.expires_in=expirationDate;
        }
        [_managedObjectContext save:nil];
    }
    [self.usersTable reloadData];
    [fetchRequest release];
    //[_indicatorView startAnimating];
    //执行页面跳转
    [self performSegueWithIdentifier:@"TabSegue" sender:nil];
}
//更新用户名显示
-(void) refreshUserName:(NSNotification *)notify{
    //插入或更新coreData的数据
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UsersCoreData" inManagedObjectContext:_managedObjectContext];
    fetchRequest.entity=entityDescription;
    NSString *uid=[notify.userInfo objectForKey:@"id"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(uid==%@)",uid];
    fetchRequest.predicate=predicate;
    NSArray *arrayTmp=[_managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (UsersCoreData *userTmp in arrayTmp) {
        userTmp.userName=[notify.userInfo objectForKey:@"screen_name"];
    }
    [_managedObjectContext save:nil];
    [self.usersTable reloadData];
}

#pragma mark --UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _usersArray? _usersArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify=@"userCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell=[[UITableViewCell alloc] init];
    }
    
    NSInteger row=[indexPath row];
    UsersCoreData *userInfo=[self.usersArray objectAtIndex:row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",userInfo.userName];
    //userInfo.userName ? userInfo.userName : @"用户名";
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",userInfo.uid];
    return cell;
}
#pragma mark --UITableViewDelegate--
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"选择用户";
}
//选择已保持的用户登陆
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UsersCoreData *selectedUser=[self.usersArray objectAtIndex:indexPath.row];
    
    NSString *accessToken = selectedUser.access_token;
    NSString *userID = selectedUser.uid;
    NSDate *expirationDate=selectedUser.expires_in;

    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:USER_EXPIRATION_DATE];
    if (![self DidUserLogin]) { //过期
        //清除数据，并弹出认证，或者直接弹出认证，这里可以考虑要不要提示用户
        [self LoginBtnPress:nil];
        [self performSegueWithIdentifier:@"OAuthSegue" sender:self];
    }else{
        [self performSegueWithIdentifier:@"TabSegue" sender:nil];
    }
}

#pragma mark --segue pass value--
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OAuthSegue"]) {
        
        NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"client_id",  @"code",@"response_type",  APPREDIRECTURI,@"redirect_uri",  @"mobile", @"display",nil];
        NSURL *authorizeUrl=[RequestEngine serializeURL:SINAWEIBOAUTHORIZE params:parameter];
        [segue.destinationViewController setUrl:authorizeUrl];
    }
}

- (IBAction)LoginBtnPress:(UIButton *)sender {
    //! 过期的不要清空这个，！一闪而过就行了
    //清空原有数据，
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* sinaweiboCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://open.weibo.cn"]];
    for (NSHTTPCookie* cookie in sinaweiboCookies)
    {
        [cookies deleteCookie:cookie];
    }
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_CODE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end







