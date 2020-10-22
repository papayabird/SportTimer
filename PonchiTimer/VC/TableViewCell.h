//
//  TableViewCell.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableCellDelegate <NSObject>

- (void)selectModeActions:(int)indexPath;

- (void)selectTimeActions:(int)indexPath;

@end

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *activeName;
@property (weak, nonatomic) IBOutlet UIButton *activeTime;

@property (weak) id <TableCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (TableViewCell *)cell;

@end
