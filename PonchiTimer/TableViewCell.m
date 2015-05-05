//
//  TableViewCell.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

+ (TableViewCell *)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (IBAction)modeAction:(id)sender
{
    [self.delegate selectModeActions:(int)self.indexPath.row];
}

- (IBAction)timeAction:(id)sender
{
    [self.delegate selectTimeActions:(int)self.indexPath.row];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
