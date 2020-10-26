//
//  PCBasicViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/6.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCBasicViewController.h"

@interface PCBasicViewController ()

{
    CAGradientLayer * layer;
}

@end

@implementation PCBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

//    [self addGradientLayer];
}

- (void)addGradientLayer {
    [layer removeFromSuperlayer];
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *lightColor = [UIColor clearColor];
    UIColor *middleColor = [UIColor colorNamed:kLightColor];
    UIColor *anotherColor = [UIColor colorNamed:kMiddleColor];
    UIColor *darkColor = [UIColor colorNamed:kMainColor];
    layer.colors = @[(id)lightColor.CGColor, (id)middleColor.CGColor, (id)anotherColor.CGColor, (id)darkColor.CGColor];
    layer.locations = @[@(0), @(0.1), @(0.65), @(1)];
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
