//
//  PCDetailViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCDetailViewController.h"
#import "TableViewCell.h"
#import "UIView+Toast.h"
#import <YKFoundation3/YKFoundation3.h>

@interface PCDetailViewController ()

@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

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
    
    if ([activeArray count] == 0) {
        return;
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
    
    //初始化
    count = 0;
    sumSec = [activeArray[0][activeTime] intValue];
    
    
    //聲音
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mouse_click" ofType:@"mp3"];
    AVAudioPlayer *aPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path2] error:NULL];
    sound = aPlayer2;
    [sound prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [currentTimer invalidate];
    currentTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (IBAction)startAction:(UIButton *)sender
{
    //如果沒有設定排程就擋掉
    if ([activeArray count] == 0) {
        
        [YKBlockAlert alertWithTitle:@"請先設定排程" message:nil blocksAndButtons:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }, @"OK",nil];
        
        return;
    }
    
    if (!sender.selected) {
        sender.selected = YES;
        //開始
        
        if (firstStart) {
            [self startTime];
            firstStart = NO;
            [self speakword:activeArray[count][activeName]];
        }
        else {
            [currentTimer setFireDate:[NSDate distantPast]];
        }
        
    }
    else {
        sender.selected = NO;
        //暫停
        
        [currentTimer setFireDate:[NSDate distantFuture]];

    }
}

- (void)speakword:(NSString *)word
{
    speakVC = [[SpeechUtteranceViewController alloc] init];
    [speakVC speakWord:word];
}

- (BOOL)getTime
{
    NSLog(@"sumSec = %i",sumSec);
    if (sumSec == currentTimeInt) {
        
        if (count == [activeArray count] - 1) {
            
        }
        else {
            count++;
            sumSec += [activeArray[count][activeTime] intValue];
            [self speakword:activeArray[count][activeName]];
        }
        
        return YES;
    }
    else {
        
    }
    
    return NO;
}

- (void)startTime
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(currentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:currentTimer forMode:NSRunLoopCommonModes];
}

- (void)currentTime
{
    currentTimeInt++;
    
    if (![self getTime]) {
        [sound play];
    }
    
    int min = currentTimeInt / 60;
    int sec = currentTimeInt % 60;
    
    currentTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
    
    if ([totalTimeLabel.text isEqualToString:currentTimeLabel.text]) {
        
        int finishedCount = [[[NSUserDefaults standardUserDefaults] objectForKey:FinishedUserDefaults] intValue];
        finishedCount++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",finishedCount] forKey:FinishedUserDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [currentTimer invalidate];
        
        NSString *str = @"";
        if (finishedCount%10 == 0) {
            str = [NSString stringWithFormat:@"已經完成了%i次了喔！",finishedCount];

        }else {
            str = @"何不再一次呢肥子!";
        }
        
        YKSimpleAlert(str);
        
        [self backAction:nil];
    }
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
