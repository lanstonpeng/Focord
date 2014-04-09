//
//  ItemCell.m
//  Focord
//
//  Created by Lanston Peng on 3/11/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "ItemCell.h"
#import "DeviceInfo.h"

@interface ItemCell()
@end
@implementation ItemCell
- (UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 80)];
        [_countLabel setBackgroundColor:[UIColor whiteColor]];
    }
    return _countLabel;
}
- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 200)];
        [_timeLabel setFont:[UIFont fontWithName:@"Helvetica" size:37]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
    }
    return _timeLabel;
}
-(void)configureCell{
    self.backgroundColor = [UIColor blackColor];
    self.countLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor whiteColor];
}
@end
