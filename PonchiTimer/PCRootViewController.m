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
        case 8:
            statusType = PCStatusType8M;
            break;
        case 5:
            statusType = PCStatusType5M;
            break;
        case 3:
            statusType = PCStatusType3M;
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

- (void)setLocalNotification
{
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:3600];
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔 每天
        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = @"是不想瘦了嗎肥子！";
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        //立即推送用 [app presentLocalNotificationNow:notification];
        [app scheduleLocalNotification:notification];
    }

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
