//
//  PCSettingViewController.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "IHAlertView.h"

typedef NS_ENUM(NSInteger, PCInputtype) {
    PCInputtypeRepeatCount = 0,
    PCInputtypeName = 1,
    PCInputtypeTime = 2
};

@interface PCSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TableCellDelegate>

{
    __weak IBOutlet UITableView *settingTableView;
    PCStatusType statusType;
    PCInputtype inputType;
    NSMutableArray *activeArray;
    NSMutableDictionary *activeDict;
    IHAlertView *alert;

    __weak IBOutlet UIButton *button8M;
    __weak IBOutlet UIButton *button5M;
    __weak IBOutlet UIButton *button3M;
    __weak IBOutlet UIButton *repeatCountbutton;
    __weak IBOutlet UILabel *activeTimeLabel;
    __weak IBOutlet UILabel *breakTimeLabel;
    __weak IBOutlet UILabel *totalTimeLabel;
    
    BOOL editBool;
    int editRow;
    
    //inputView
    IBOutlet UIView *inputView;
    __weak IBOutlet UILabel *inputViewTitle;
    __weak IBOutlet UITextField *inputViewField;
    
    //repeatCount
    int repeatCount;
    
}

@end
