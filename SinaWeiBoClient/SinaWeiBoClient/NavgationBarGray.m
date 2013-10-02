//
//  NavgationBarGray.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-6-9.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "NavgationBarGray.h"

@implementation NavgationBarGray

- (void)drawRect:(CGRect)rect{
    [[UIImage imageNamed:@"navBg"] drawInRect:rect];
}

@end
