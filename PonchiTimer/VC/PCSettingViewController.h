//
//  PCSettingViewController.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "IHAlertView.h"
#import "PCBasicViewController.h"
typedef NS_ENUM(NSInteger, PCInputtype) {
    PCInputtypeRepeatCount = 0,
    PCInputtypeName = 1,
    PCInputtypeTime = 2
};

@interface PCSettingViewController : PCBasicViewController <UITableViewDataSource, UITableViewDelegate, TableCellDelegate>



@end
