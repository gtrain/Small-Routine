//
//  ViewController.h
//  weather
//
//  Created by yang on 12-8-27.
//  Copyright (c) 2012年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *theCity;

@property (weak, nonatomic) IBOutlet UILabel *cityDisplay;
@property (weak, nonatomic) IBOutlet UIImageView *imgDisplay;
@property (weak, nonatomic) IBOutlet UILabel *tempDisplay;
@property (weak, nonatomic) IBOutlet UILabel *dateDisplay;
@property (weak, nonatomic) IBOutlet UILabel *suggestDisplay;


- (IBAction)go;

//把一个按钮放在地层，点击时退下键盘
- (IBAction)backgroundTap:(id)sender;

@end
