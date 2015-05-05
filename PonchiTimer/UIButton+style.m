//
//  UIButton+style.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "UIButton+style.h"

@implementation UIButton (style)

-(void)awakeFromNib
{
    [self.layer setBorderColor:[UIColor redColor].CGColor];
    [self.layer setBorderWidth:2];
}

@end
