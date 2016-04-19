//
//  PCSettingViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCSettingViewController.h"

@interface PCSettingViewController ()

@end

@implementation PCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            [dict setObject:@"1" forKey:activeRepeatCount];
            [activeDict setObject:dict forKey:array[i]];
        }
    }
    
    [self startAction:buttonMode1];
    
    alert = [[IHAlertView alloc] init];
    alert.delegate = self;
}

- (IBAction)startAction:(id)sender
{
    [self saveData];
    
    //轉換資料
    int tag = (int)[sender tag];
    
    [self resetButtonType];
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.textColor = [UIColor blackColor];
    
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

- (IBAction)backAction:(id)sender
{
    [self saveData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (IBAction)repeatAction:(id)sender
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = @"請輸入循環次數";
    inputViewField.keyboardType = UIKeyboardTypeNumberPad;
    [inputViewField becomeFirstResponder];
    inputType = PCInputtypeRepeatCount;
}

- (void)reloadtableView
{
    [settingTableView reloadData];
    [self reloadRepeatCountlabel];
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

- (void)saveData
{
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
    
    BOOL isSave = [activeDict writeToFile:[[AppDelegate sharedAppDelegate] getActivePlistPath] atomically:YES];
}

- (void)resetButtonType
{
    buttonMode1.backgroundColor = [UIColor blackColor];
    buttonMode2.backgroundColor = [UIColor blackColor];
    buttonMode3.backgroundColor = [UIColor blackColor];
    
    buttonMode1.titleLabel.textColor = [UIColor redColor];
    buttonMode2.titleLabel.textColor = [UIColor redColor];
    buttonMode3.titleLabel.textColor = [UIColor redColor];
}

#pragma mark - Cell Delegate
-(void)selectModeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = @"請輸入運動名稱";
    inputViewField.keyboardType = UIKeyboardTypeDefault;
    [inputViewField becomeFirstResponder];;
    inputType = PCInputtypeName;
    editRow = indexPath;
}

-(void)selectTimeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = @"請輸入運動時間";
    inputViewField.keyboardType = UIKeyboardTypeNumberPad;
    [inputViewField becomeFirstResponder];
    inputType = PCInputtypeTime;
    editRow = indexPath;
}

- (IBAction)inputCancel:(id)sender
{
    if (!alert.isAnimationDone) {
        return;
    }
    
    inputViewField.text = @"";
    [alert removeAlert];
}

- (IBAction)inputSave:(id)sender
{
    if (!alert.isAnimationDone) {
        return;
    }
    
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
        else {
            if ([self isPureInt:inputViewField.text]) {
                repeatCount = [inputViewField.text intValue];
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

#pragma mark - UITableView Delegate & Datasource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(0, 0, 160, 44);
    [addButton setTitle:@"增加項目" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addButton setBackgroundColor:[UIColor blackColor]];
    [addButton addTarget:self action:@selector(addRowAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(160, 0, 160, 44);
    [deleteButton setTitle:@"編輯項目" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor blackColor]];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [headerView addSubview:addButton];
    [headerView addSubview:deleteButton];

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
    [dict setObject:@"運動" forKey:activeName];
    [dict setObject:@"0" forKey:activeTime];
    [activeArray addObject:dict];
    [self reloadtableView];
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
