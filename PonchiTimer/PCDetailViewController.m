//
//  PCDetailViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCDetailViewController.h"

@interface PCDetailViewController ()

@end

@implementation PCDetailViewController

- (instancetype)initWithType:(PCStatusType)type
{
    self = [super init];
    if (self) {
        statusType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
