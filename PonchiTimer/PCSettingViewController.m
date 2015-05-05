//
//  PCSettingViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "PCSettingViewController.h"
#import "AppDelegate.h"

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
        activeDict = [NSMutableDictionary dictionary];
        [activeDict setObject:@{activeArrayStr:[NSMutableArray array],activeRepeatCount:@"1"} forKey:@"8M"];
        [activeDict setObject:@{activeArrayStr:[NSMutableArray array],activeRepeatCount:@"1"} forKey:@"5M"];
        [activeDict setObject:@{activeArrayStr:[NSMutableArray array],activeRepeatCount:@"1"} forKey:@"3M"];
    }
    [self startAction:button8M];
    
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
        case 8:
            [activeDict[@"8M"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"8M"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        case 5:
            [activeDict[@"5M"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"5M"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        case 3:
            [activeDict[@"3M"] setObject:activeArray forKey:activeArrayStr];
            [activeDict[@"3M"] setObject:repeatCountbutton.titleLabel.text forKey:activeRepeatCount];
            break;
        default:
            break;
    }
    
    [activeDict writeToFile:[[AppDelegate sharedAppDelegate] getActivePlistPath] atomically:YES];
}

- (void)resetButtonType
{
    button3M.backgroundColor = [UIColor blackColor];
    button5M.backgroundColor = [UIColor blackColor];
    button8M.backgroundColor = [UIColor blackColor];
    
    button3M.titleLabel.textColor = [UIColor redColor];
    button5M.titleLabel.textColor = [UIColor redColor];
    button8M.titleLabel.textColor = [UIColor redColor];
}

#pragma mark - Cell Delegate
-(void)selectModeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = @"請輸入運動名稱";
    inputType = PCInputtypeName;
    editRow = indexPath;
}

-(void)selectTimeActions:(int)indexPath
{
    [alert displayViewAtCenter:inputView];
    inputViewTitle.text = @"請輸入運動時間";
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
            NSMutableDictionary *dict = [activeArray[editRow] mutableCopy];
            [dict setObject:inputViewField.text forKey:activeTime];
            [activeArray replaceObjectAtIndex:editRow withObject:dict];
        }
        else {
            repeatCount = [inputViewField.text intValue];
            
        }
        [self reloadtableView];
    }
    
    inputViewField.text = @"";
    [alert removeAlert];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"此功能尚未開放" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
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
