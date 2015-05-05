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
        [activeDict setObject:[NSMutableArray array] forKey:@"8M"];
        [activeDict setObject:[NSMutableArray array] forKey:@"5M"];
        [activeDict setObject:[NSMutableArray array] forKey:@"3M"];
    }
    [self startAction:button8M];
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
            activeArray = activeDict[@"8M"];
            break;
        case 5:
            statusType = PCStatusType5M;
            activeArray = activeDict[@"5M"];
            break;
        case 3:
            statusType = PCStatusType3M;
            activeArray = activeDict[@"3M"];
            break;
        default:
            break;
    }
    
    [settingTableView reloadData];
}

- (IBAction)backAction:(id)sender
{
    [self saveData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)saveData
{
    //儲存
    switch (statusType) {
        case 8:
            [activeDict setObject:activeArray forKey:@"8M"];
            break;
        case 5:
            [activeDict setObject:activeArray forKey:@"5M"];
            break;
        case 3:
            [activeDict setObject:activeArray forKey:@"3M"];
            break;
        default:
            break;
    }
    
    BOOL saveBool = [activeDict writeToFile:[[AppDelegate sharedAppDelegate] getActivePlistPath] atomically:YES];
    
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
    
}

-(void)selectTimeActions:(int)indexPath
{
    
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
    [cell.activeTime setTitle:[dict[activeTime] stringByAppendingString:@"S"] forState:UIControlStateNormal];
    
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
        
        [settingTableView reloadData];
    }

}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //Even if the method is empty you should be seeing both rearrangement icon and animation.
}

- (void)addRowAction
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"運動" forKey:activeName];
    [dict setObject:@"0" forKey:activeTime];
    [activeArray addObject:dict];
    [settingTableView reloadData];
}

- (void)deleteAction:(UIButton *)button
{
    if (!editBool) {
        [settingTableView setEditing:YES animated:YES];
        [settingTableView reloadData];
        editBool = YES;
    }
    else {
        [settingTableView setEditing:NO animated:YES];
        [settingTableView reloadData];
        editBool = NO;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
