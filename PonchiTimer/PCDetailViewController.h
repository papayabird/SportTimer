//
//  PCDetailViewController.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PCDetailViewController : UIViewController

{
    PCStatusType statusType;
    __weak IBOutlet UILabel *timeLabel;
}

@end
