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

@interface PCDetailViewController : PCBasicViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithType:(PCStatusType)type;

@end
