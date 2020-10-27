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
#import "PCInfoViewController.h"

@interface PCRootViewController ()

{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *mode1Btn;
    __weak IBOutlet UIButton *mode2Btn;
    __weak IBOutlet UIButton *mode3Btn;
    __weak IBOutlet UIButton *scheduleBtn;
    
}

@end

@implementation PCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[LanguageTool sharedInstance] setNewLanguage:kChinese_Traditional];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //本地推播先不要
//    [[AppDelegate sharedAppDelegate] setUserNotification];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kFirstInfoUserDefaults]) {
        PCInfoViewController *infoVC = [[PCInfoViewController alloc] init];
        [self presentViewController:infoVC animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstInfoUserDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

- (void)prepareUI {
    titleLabel.text = GetStringWithKeyFromTable(kTitle,kLocalizable);
    [mode1Btn setTitle:GetStringWithKeyFromTable(kMode1,kLocalizable) forState:UIControlStateNormal];
    [mode2Btn setTitle:GetStringWithKeyFromTable(kMode2,kLocalizable) forState:UIControlStateNormal];
    [mode3Btn setTitle:GetStringWithKeyFromTable(kMode3,kLocalizable) forState:UIControlStateNormal];
    [scheduleBtn setTitle:GetStringWithKeyFromTable(kSchedule,kLocalizable) forState:UIControlStateNormal];
    
    mode1Btn.layer.cornerRadius = 5;
    mode1Btn.layer.masksToBounds = YES;
    mode2Btn.layer.cornerRadius = 5;
    mode2Btn.layer.masksToBounds = YES;
    mode3Btn.layer.cornerRadius = 5;
    mode3Btn.layer.masksToBounds = YES;
    scheduleBtn.layer.cornerRadius = 5;
    scheduleBtn.layer.masksToBounds = YES;
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
