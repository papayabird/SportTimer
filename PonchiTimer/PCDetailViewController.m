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
        speakVC = [[SpeechUtteranceViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    firstStart = YES;
    
    activeDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[AppDelegate sharedAppDelegate] getActivePlistPath]];
    
    switch (statusType) {
        case 1:
            statusType = PCStatusTypeMode1;
            activeArray = activeDict[@"mode1"][activeArrayStr];
            repeatCount = [activeDict[@"mode1"][activeRepeatCount] intValue];
            break;
        case 2:
            statusType = PCStatusTypeMode2;
            activeArray = activeDict[@"mode2"][activeArrayStr];
            repeatCount = [activeDict[@"mode2"][activeRepeatCount] intValue];
            break;
        case 3:
            statusType = PCStatusTypeMode3;
            activeArray = activeDict[@"mode3"][activeArrayStr];
            repeatCount = [activeDict[@"mode3"][activeRepeatCount] intValue];
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
    
    displayTableArray = [NSMutableArray arrayWithArray:activeArray];
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
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"請先設定排程" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
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
            
            [displayTableArray removeObjectAtIndex:0];
            [progressTableView reloadData];
            
//            [progressTableView beginUpdates];
//            [progressTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//
//            [progressTableView endUpdates];
//            
//            [progressTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
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
            str = @"好棒喔,完成了!";
        }
        
        UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:str message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [finishAlert show];
        
        [self backAction:nil];
    }
}

#pragma mark - UITableView Delegate & Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayTableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cell];
    
    NSDictionary *dict = displayTableArray[indexPath .row];
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
