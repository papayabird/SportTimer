//
//  PCDetailViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCDetailViewController.h"
#import "TableViewCell.h"

@interface PCDetailViewController ()

@end

@implementation PCDetailViewController

- (instancetype)initWithType:(PCStatusType)type
{
    self = [super init];
    if (self) {
        statusType = type;
        
        activeArray = [NSMutableArray array];
        activeDict  = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    firstStart = YES;
    
    activeDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[AppDelegate sharedAppDelegate] getActivePlistPath]];
    
    switch (statusType) {
        case 8:
            statusType = PCStatusType8M;
            activeArray = activeDict[@"8M"][activeArrayStr];
            repeatCount = [activeDict[@"8M"][activeRepeatCount] intValue];
            break;
        case 5:
            statusType = PCStatusType5M;
            activeArray = activeDict[@"5M"][activeArrayStr];
            repeatCount = [activeDict[@"5M"][activeRepeatCount] intValue];
            break;
        case 3:
            statusType = PCStatusType3M;
            activeArray = activeDict[@"3M"][activeArrayStr];
            repeatCount = [activeDict[@"3M"][activeRepeatCount] intValue];
            break;
        default:
            break;
    }
    
    //加總重複次數
    NSMutableArray *copyArray = [activeArray copy];
    for (int i = 0; i < repeatCount - 1; i++) {
        [activeArray addObjectsFromArray:copyArray];
    }
    
    //計算全部時間
    int timeSum = 0;
    
    for (NSMutableDictionary *dict in activeArray) {
        
        timeSum += [dict[activeTime] intValue];
    }
    
    int min = timeSum / 60;
    int sec = timeSum % 60;
    
    totalTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mouse_click" ofType:@"mp3"];
    AVAudioPlayer *aPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path2] error:NULL];
    sound = aPlayer2;
    [sound prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    
    [currentTimer invalidate];
    currentTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (IBAction)startAction:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        //開始
        
        if (firstStart) {
            [self getTime];
            [self startTime];
            firstStart = NO;
        }
        else {
            [timer setFireDate:[NSDate distantPast]];
            [currentTimer setFireDate:[NSDate distantPast]];
        }
        
    }
    else {
        sender.selected = NO;
        //暫停
        
        [timer setFireDate:[NSDate distantFuture]];
        [currentTimer setFireDate:[NSDate distantFuture]];

    }
}

- (void)getTime
{
    [timer invalidate];
    timer = nil;
    
    int time = 0;
    if ([activeArray count] > count) {
        
        time = [activeArray[count][activeTime] intValue];
        count++;
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(getTime) userInfo:nil repeats:NO];
    }
    else {
        
    }
    
}

- (void)startTime
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(currentTime) userInfo:nil repeats:YES];
}

- (void)currentTime
{
    
    [sound play];

    currentTimeInt++;
    
    int min = currentTimeInt / 60;
    int sec = currentTimeInt % 60;
    
    currentTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
    
}

#pragma mark - UITableView Delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cell];
    
    NSDictionary *dict = activeArray[indexPath .row];
    [cell.activeName setTitle:dict[activeName] forState:UIControlStateNormal];
    [cell.activeTime setTitle:[dict[activeTime] stringByAppendingString:@"s"] forState:UIControlStateNormal];
    
    return cell;
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
