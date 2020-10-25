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

#define earlySec 2

@interface PCDetailViewController ()

{
    PCStatusType statusType;
    __weak IBOutlet UITableView *progressTableView;
    __weak IBOutlet UILabel *totalTimeLabel;
    __weak IBOutlet UILabel *currentTimeLabel;
    __weak IBOutlet UIButton *startButton;
    __weak IBOutlet UILabel *totalTimeTitleLabel;
    __weak IBOutlet UILabel *currentTimeTitleLabel;
    __weak IBOutlet UIButton *backBtn;
    
    NSMutableArray *activeArray;
    NSMutableArray *displayTableArray;

    NSMutableDictionary *activeDict;

    int repeatCount;

    NSTimer *currentTimer;
    int currentTimeInt;
    int totalTimeInt;
    int singleItemTimeInt;
    int ignoreTimeInt;

    BOOL firstStart;
    BOOL firstRing;
    int count;
    int itemSumSec;
    AVAudioPlayer *clickSoundAV;
    AVAudioPlayer *startSoundAV;
    SpeechUtteranceViewController *speakVC;
}


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
    firstRing = YES;
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
    for (int i = 0; i < repeatCount; i++) {
        [activeArray addObjectsFromArray:copyArray];
    }

    //計算全部時間
    int timeSum = 0;
    for (NSMutableDictionary *dict in activeArray) {
        timeSum += [dict[activeTime] intValue];
    }
    totalTimeInt = timeSum;
    
    //開頭準備,要在加總重複次數&計算全部時間後面!!!
    [self addPrepareActive];
    
    [self totalTime];
    
    //初始化
    count = 0;
    itemSumSec = [activeArray[0][activeTime] intValue];
    singleItemTimeInt = [activeArray[0][activeTime] intValue];
    ignoreTimeInt = [kPrepareTime intValue];
    
    //聲音

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mouse_click" ofType:@"mp3"];
    AVAudioPlayer *aPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path2] error:NULL];
    AVAudioSession * avSession = [AVAudioSession sharedInstance];
    [avSession  setCategory:AVAudioSessionCategoryPlayback error:nil];
    clickSoundAV = aPlayer2;
    [clickSoundAV prepareToPlay];

    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"start" ofType:@"mp3"];
    AVAudioPlayer *aPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path1] error:NULL];
    AVAudioSession * avSession1 = [AVAudioSession sharedInstance];
    [avSession1  setCategory:AVAudioSessionCategoryPlayback error:nil];
    startSoundAV = aPlayer1;
    [startSoundAV prepareToPlay];
    
    displayTableArray = [NSMutableArray arrayWithArray:activeArray];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [currentTimer invalidate];
    currentTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)addPrepareActive {
    [activeArray insertObject:@{activeName:kPrepareName,activeTime:kPrepareTime} atIndex:0];
}

- (IBAction)startAction:(UIButton *)sender
{
    //如果沒有設定排程就擋掉
    if ([activeArray count] == 0) {
        [[Utils sharedManager] showOneBtnAlert:self
                                         title:GetStringWithKeyFromTable(kPlease_Create_Schedule_First,kLocalizable)
                                       message:@""
                                    completion:^{
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
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
    NSLog(@"itemSumSec = %i",itemSumSec);
    NSLog(@"currentTimeInt = %i",currentTimeInt);
    NSLog(@"singleItemTimeInt = %i",singleItemTimeInt);
    NSLog(@"totalTimeInt = %i",totalTimeInt);

    if (itemSumSec == currentTimeInt) {
        
        if (count == [activeArray count] - 1) {
            
        }
        else {
            count++;
            itemSumSec += [activeArray[count][activeTime] intValue];
            singleItemTimeInt = [activeArray[count][activeTime] intValue];
            [startSoundAV play];
//            [clickSoundAV play];
            [displayTableArray removeObjectAtIndex:0];
            [progressTableView reloadData];
        }
        return YES;
    }
    
    //念聲音要提早一秒,要判斷是不是剩最後一個,是的話不要抓
    if ([displayTableArray count] > 1 && itemSumSec == currentTimeInt + earlySec) {
        NSLog(@"activeArray[count + 1][activeName] = %@",activeArray[count + 1][activeName]);
        [self speakword:activeArray[count + 1][activeName]];
    }
    
    [clickSoundAV play];
    return NO;
}

- (void)startTime
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(currentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:currentTimer forMode:NSRunLoopCommonModes];
}

- (void)totalTime {
    int min = totalTimeInt / 60;
    int sec = totalTimeInt % 60;
    totalTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
}

- (void)singleItemTime {
    /*原本是顯示運動時間,現在要改成每個item的時間
    int min = currentTimeInt / 60;
    int sec = currentTimeInt % 60;
    currentTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
     */
    
    int min = singleItemTimeInt / 60;
    int sec = singleItemTimeInt % 60;
    currentTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
}

- (void)currentTime
{
    NSLog(@"ignoreTimeInt = %i",ignoreTimeInt);
    if (ignoreTimeInt != 0) {
        //準備的時間要跳過不要計算
        if (ignoreTimeInt == [kPrepareTime intValue]) {
            [activeArray removeObjectAtIndex:0];
            count = 0;
            itemSumSec = [activeArray[0][activeTime] intValue];
            singleItemTimeInt = [activeArray[0][activeTime] intValue];
        }
#warning 正式第一組念的時間
        if (ignoreTimeInt == earlySec) {
            [self speakword:activeArray[0][activeName]];
            [displayTableArray removeObjectAtIndex:0];
            [progressTableView reloadData];
        }
        ignoreTimeInt--;
        [clickSoundAV play];
        return;
    }
    
    if (firstRing) {
#warning 正式第一組響鈴的時間
        [startSoundAV play];
        firstRing = NO;
    }
    
    currentTimeInt++;
    totalTimeInt--;
    singleItemTimeInt--;
    
    [self getTime];
    [self totalTime];
    [self singleItemTime];
    
    if (totalTimeInt == 0) {
        
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
        [self speakword:str];

        [[Utils sharedManager] showOneBtnAlert:self title:str message:@"" completion:^{
            [self backAction:nil];
        }];
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
