//
//  ViewController.m
//  weather
//
//  Created by yang on 12-8-27.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) Model *model;
-(void) displayInfo:(NSDictionary *)dic;
@end


@implementation ViewController
@synthesize theCity;

@synthesize cityDisplay;
@synthesize imgDisplay;
@synthesize tempDisplay;
@synthesize dateDisplay;
@synthesize suggestDisplay;

//方便使用self.model访问Model的公开方法
-(Model *) model{
    if (!_model) {
        _model=[[Model alloc] init];
    }
    return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [self setTheCity:nil];
    [self setCityDisplay:nil];
    [self setImgDisplay:nil];
    [self setTempDisplay:nil];
    [self setDateDisplay:nil];
    [self setSuggestDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//退下键盘
-(IBAction)backgroundTap:(id)sender
{
    [theCity resignFirstResponder];
}


- (IBAction)go {
    NSString *city = self.theCity.text;
    if (city) {
        NSDictionary *weatherInfo = [self.model weatherInfo:city];
        if (weatherInfo) {
            //解析到的json是两重的，key:weatherinfo里面还有一个字典
            [self displayInfo:[weatherInfo objectForKey:@"weatherinfo"]];
        } else{
            //NO weather info, is correct input?
        }
    }
}


-(void) displayInfo:(NSDictionary *)dic
{
    UIImage *saveImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[self.model weatherImg:[dic objectForKey:@"img1"]]]];
    self.imgDisplay.image =saveImg;
    
    //self.cityDisplay.text =[[dic objectForKey:@"city"] stringByAppendingString:[dic objectForKey:@"city_en"]];
    self.cityDisplay.text =[dic objectForKey:@"city"];
    self.tempDisplay.text =[[dic objectForKey:@"weather1"] stringByAppendingString:[dic objectForKey:@"temp1"]];
    self.dateDisplay.text =[[dic objectForKey:@"date_y"] stringByAppendingString:[dic objectForKey:@"week"]];
    self.suggestDisplay.text = [dic objectForKey:@"index_d"];
    
//    NSLog(@"%@ (%@)",[dic objectForKey:@"city"],[dic objectForKey:@"city_en"]);//北京
//    NSLog(@"今天是%@ %@\n",[dic objectForKey:@"date_y"],[dic objectForKey:@"week"]);
//    NSLog(@"天气 :%@ 气温：%@\n",[dic objectForKey:@"weather1"],[dic objectForKey:@"temp1"]);
//    NSLog(@"%@ \n",[dic objectForKey:@"index_d"]);
//    NSLog(@"%@ %@",[self.model weatherImg:[dic objectForKey:@"img1"]],[dic objectForKey:@"img_title1"]);
}




@end










