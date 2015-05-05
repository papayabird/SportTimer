//
//  PCDetailViewController.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface PCDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    PCStatusType statusType;
    __weak IBOutlet UITableView *progressTableView;
    __weak IBOutlet UILabel *totalTimeLabel;
    __weak IBOutlet UILabel *currentTimeLabel;

    NSMutableArray *activeArray;
    NSMutableDictionary *activeDict;

    int repeatCount;

    __weak IBOutlet UIButton *startButton;
    NSTimer *timer;
    NSTimer *currentTimer;
    int currentTimeInt;

    BOOL firstStart;
    int count;
    
    AVAudioPlayer *sound;
}

- (instancetype)initWithType:(PCStatusType)type;

@end
