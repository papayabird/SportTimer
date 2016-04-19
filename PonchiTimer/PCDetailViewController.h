//
//  PCDetailViewController.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SpeechUtteranceViewController.h"
#import "PCBasicViewController.h"

@interface PCDetailViewController : PCBasicViewController <UITableViewDataSource, UITableViewDelegate>

{
    PCStatusType statusType;
    __weak IBOutlet UITableView *progressTableView;
    __weak IBOutlet UILabel *totalTimeLabel;
    __weak IBOutlet UILabel *currentTimeLabel;

    NSMutableArray *activeArray;
    NSMutableArray *displayTableArray;

    NSMutableDictionary *activeDict;

    int repeatCount;

    __weak IBOutlet UIButton *startButton;
    NSTimer *currentTimer;
    int currentTimeInt;

    BOOL firstStart;
    int count;
    int sumSec;
    AVAudioPlayer *sound;
    SpeechUtteranceViewController *speakVC;
}

- (instancetype)initWithType:(PCStatusType)type;

@end
