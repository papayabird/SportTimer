//
//  PCSettingViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCSettingViewController.h"

@interface PCSettingViewController ()

{
    __weak IBOutlet UITableView *settingTableView;
    PCStatusType statusType;
    PCInputtype inputType;
    NSMutableArray *activeArray;
    NSMutableDictionary *activeDict;
    IHAlertView *alert;

    __weak IBOutlet UIButton *buttonMode1;
    __weak IBOutlet UIButton *buttonMode2;
    __weak IBOutlet UIButton *buttonMode3;
    __weak IBOutlet UIButton *repeatCountbutton;
    __weak IBOutlet UILabel *totalTimeLabel;
    __weak IBOutlet UISwitch *resetSwitch;
    __weak IBOutlet UIButton *resetTimeBtn;
    
    BOOL editBool;
    int editRow;
    
    //inputView
    IBOutlet UIView *inputView;
    __weak IBOutlet UILabel *inputViewTitle;
    __weak IBOutlet UITextField *inputViewField;
    
    //repeatCount
    int repeatCount;
    
    //resetTime
    int resetTime;
}

@end

@implementation PCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.modalInPresentation = YES;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    activeDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[AppDelegate sharedAppDelegate] getActivePlistPath]];
    if (!activeDict) {
        activeDict = [[NSMutableDictionary alloc] init];
        NSArray *array = [NSArray arrayWithObjects:@"mode1",@"mode2",@"mode3", nil];
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSMutableArray array] forKey:activeArrayStr];
            [dict setObject:@"0" forKey:activeRepeatCount];
            [activeDict setObject:dict forKey:array[i]];
        }
    }
    
    [self startAction:buttonMode1];
    
    alert = [[IHAlertView alloc] init];
    alert.delegate = self;
    
    resetSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kAytoResetItemUserDefaults];

    [self prepareUI];
}

- (void)prepareUI {
    [buttonMode1 setTitle:GetStringWithKeyFromTable(kMode1,kLocalizable) forState:UIControlStateNormal];
    [buttonMode2 setTitle:GetStringWithKeyFromTable(kMode2,kLocalizable) forState:UIControlStateNormal];
    [buttonMode3 setTitle:GetStringWithKeyFromTable(kMode3,kLocalizable) forState:UIControlStateNormal];
}

- (IBAction)startAction:(id)sender
{
    [self saveData:^(bool isSuccess, NSString *errorStr) {
        if (!isSuccess) {
            [[Utils sharedManager] showOneBtnAlert:self title:errorStr message:@"" completion:^{
            }];
        }else {
            //轉換資料
            int tag = (int)[sender tag];
            
            [self resetButtonType];
            UIButton *btn = (UIButton *)sender;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            switch (tag) {
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
            
            [self reloadTimeLabel];
            
            [self reloadtableView];
        }
    }];
}

- (IBAction)backAction:(id)sender
{
    [self saveData:^(bool isSuccess, NSString *errorStr) {
        if (isSuccess) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else {
            [[Utils sharedManager] showOneBtnAlert:self title:errorStr message:@"" completion:^{
                
            }];
        }
    }];
}

- (IBAction)repeatAction:(id)sender
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = GetStringWithKeyFromTable(kInput_Repeat_Time,kLocalizable);
    inputViewField.keyboardType = UIKeyboardTypeNumberPad;
    [inputViewField becomeFirstResponder];
    inputType = PCInputtypeRepeatCount;
}

- (void)reloadtableView
{
    [settingTableView reloadData];
    [self reloadRepeatCountlabel];
    [self reloadResetTimelabel];
    [self reloadTimeLabel];
}

- (void)reloadTimeLabel
{
    int timeSum = 0;
    
    for (NSMutableDictionary *dict in activeArray) {
        
         timeSum += [dict[activeTime] intValue];
    }
    
    int min = timeSum / 60;
    int sec = timeSum % 60;
    
    totalTimeLabel.text = [NSString stringWithFormat:@"%i : %i",min,sec];
}

- (void)reloadRepeatCountlabel
{
    [repeatCountbutton setTitle:[NSString stringWithFormat:@"%i",repeatCount] forState:UIControlStateNormal];
}

- (void)reloadResetTimelabel
{
    [resetTimeBtn setTitle:[NSString stringWithFormat:@"%i",resetTime] forState:UIControlStateNormal];
}

- (void)saveData:(void (^)(bool isSuccess, NSString * errorStr))callback
{
    //判斷時間是否有0
    for (NSDictionary *dict in activeArray) {
        if ([dict[activeTime] isEqual:kActive_Time_Zero]) {
            callback(NO, kDataCantZero);
            return;
        }
    }
    
    //儲存
    switch (statusType) {
        case 1:
            [activeDict[@"mode1"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"mode1"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        case 2:
            [activeDict[@"mode2"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"mode2"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        case 3:
            [activeDict[@"mode3"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"mode3"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        default:
            break;
    }
    
    bool isSave = [activeDict writeToFile:[[AppDelegate sharedAppDelegate] getActivePlistPath] atomically:YES];
    
    callback(isSave, kSaveDataError);
}

- (void)resetButtonType
{
    buttonMode1.backgroundColor = [UIColor colorNamed:@"ScheduleBG"];
    buttonMode2.backgroundColor = [UIColor colorNamed:@"ScheduleBG"];
    buttonMode3.backgroundColor = [UIColor colorNamed:@"ScheduleBG"];
    
    buttonMode1.titleLabel.textColor = [UIColor whiteColor];
    buttonMode2.titleLabel.textColor = [UIColor whiteColor];
    buttonMode3.titleLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Cell Delegate
-(void)selectModeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = GetStringWithKeyFromTable(kInput_Active_Name,kLocalizable);
    inputViewField.keyboardType = UIKeyboardTypeDefault;
    [inputViewField becomeFirstResponder];;
    inputViewField.text = activeArray[indexPath][activeName];
    inputType = PCInputtypeName;
    editRow = indexPath;
}

-(void)selectTimeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = GetStringWithKeyFromTable(kInput_Active_Time,kLocalizable);
    inputViewField.keyboardType = UIKeyboardTypeNumberPad;
    [inputViewField becomeFirstResponder];
    //數字就直接清掉
//    inputViewField.text = activeArray[indexPath][activeTime];
    inputType = PCInputtypeTime;
    editRow = indexPath;
}

- (IBAction)inputCancel:(id)sender
{
    inputViewField.text = @"";
    [alert removeAlert];
}

- (IBAction)inputSave:(id)sender
{
    if (inputViewField.text.length != 0) {
        
        if (inputType == PCInputtypeName) {
            NSMutableDictionary *dict = [activeArray[editRow] mutableCopy];
            [dict setObject:inputViewField.text forKey:activeName];
            [activeArray replaceObjectAtIndex:editRow withObject:dict];
        }
        else if (inputType == PCInputtypeTime) {
            
            if ([self isPureInt:inputViewField.text]) {
        
                NSMutableDictionary *dict = [activeArray[editRow] mutableCopy];
                [dict setObject:inputViewField.text forKey:activeTime];
                [activeArray replaceObjectAtIndex:editRow withObject:dict];
            }
        }
        else if (inputType == PCInputtypeRepeatCount){
            if ([self isPureInt:inputViewField.text]) {
                repeatCount = [inputViewField.text intValue];
            }
        }else if (inputType == PCInputtypeResetTime) {
            if ([self isPureInt:inputViewField.text]) {
                resetTime = [inputViewField.text intValue];
            }
        }
        [self reloadtableView];
    }
    
    inputViewField.text = @"";
    [alert removeAlert];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (IBAction)resetSwitchAction:(id)sender {
    UISwitch *resetSwitch = (UISwitch *)sender;
    if (resetSwitch.on) {
        resetTimeBtn.userInteractionEnabled = YES;
        resetTimeBtn.alpha = 1.0f;
    }else {
        resetTimeBtn.userInteractionEnabled = NO;
        resetTimeBtn.alpha = 0.5f;
    }
    [[NSUserDefaults standardUserDefaults] setBool:resetSwitch.on forKey:kAytoResetItemUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)resetTimeAction:(id)sender {
    
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = GetStringWithKeyFromTable(kInput_Active_Time,kLocalizable);
    inputViewField.keyboardType = UIKeyboardTypeNumberPad;
    [inputViewField becomeFirstResponder];
    //數字就直接清掉
//    inputViewField.text = activeArray[indexPath][activeTime];
    inputType = PCInputtypeResetTime;
}

#pragma mark - UITableView Delegate & Datasource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 320, 44);
//    addButton.frame = CGRectMake(0, 0, 160, 44);
    [addButton setTitle:GetStringWithKeyFromTable(kAdd_Item,kLocalizable) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundColor:[UIColor blackColor]];
    [addButton addTarget:self action:@selector(addRowAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];

    /*
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(160, 0, 160, 44);
    [deleteButton setTitle:@"編輯項目" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorNamed:kMainColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor blackColor]];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
     [headerView addSubview:deleteButton];
     */

    

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cell];
    __weak id weakself = self;
    cell.delegate = weakself;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (editBool) {
        cell.activeName.frame = CGRectMake(16, 0, 110, 43);
        cell.activeTime.frame = CGRectMake(121, 0, 110, 43);
    }
    else {
        cell.activeName.frame = CGRectMake(0, 0, 162, 43);
        cell.activeTime.frame = CGRectMake(161, 0, 159, 43);
    }
    
    
    NSDictionary *dict = activeArray[indexPath .row];
    
    [cell.activeName setTitle:dict[activeName] forState:UIControlStateNormal];
    [cell.activeTime setTitle:[dict[activeTime] stringByAppendingString:@"s"] forState:UIControlStateNormal];
    cell.contentView.backgroundColor = [UIColor colorNamed:@"ScheduleBG"];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [activeArray removeObjectAtIndex:indexPath.row];
        
        [self reloadtableView];
    }

}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [activeArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [activeArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [activeArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

- (void)addRowAction
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:GetStringWithKeyFromTable(kDefault_Active_Name,kLocalizable) forKey:activeName];
    [dict setObject:@"0" forKey:activeTime];
    [activeArray addObject:dict];
    
    //如果有自動插入休息
    if (resetSwitch.on) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:GetStringWithKeyFromTable(kDefault_Reset_Name,kLocalizable) forKey:activeName];
        [dict setObject:resetTimeBtn.titleLabel.text  forKey:activeTime];
        [activeArray addObject:dict];
    }
    
    [self reloadtableView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[activeArray count] - 1 inSection:0];
    [settingTableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
}

- (void)deleteAction:(UIButton *)button
{
    return;
    
    if (!editBool) {
        [settingTableView setEditing:YES animated:YES];
        [self reloadtableView];
        editBool = YES;
    }
    else {
        [settingTableView setEditing:NO animated:YES];
        [self reloadtableView];
        editBool = NO;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
