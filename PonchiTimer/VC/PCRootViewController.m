//
//  PCRootViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCRootViewController.h"
#import "PCDetailViewController.h"
#import "PCSettingViewController.h"
@interface PCRootViewController ()

@end

@implementation PCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startAction:(id)sender
{
    int tag = (int)[sender tag];
    
    switch (tag) {
        case 1:
            statusType = PCStatusTypeMode1;
            break;
        case 2:
            statusType = PCStatusTypeMode2;
            break;
        case 3:
            statusType = PCStatusTypeMode3;
            break;
        default:
            break;
    }
    
    PCDetailViewController *detailVC = [[PCDetailViewController alloc] initWithType:statusType];
    [self presentViewController:detailVC animated:YES completion:^{
        
    }];
}

- (IBAction)settingsAction:(id)sender
{
    PCSettingViewController *settingsVC = [[PCSettingViewController alloc] init];
    [self presentViewController:settingsVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
