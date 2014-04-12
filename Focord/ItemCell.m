//
//  ItemCell.m
//  Focord
//
//  Created by Lanston Peng on 3/11/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "ItemCell.h"
#import "DeviceInfo.h"
@implementation ItemCell
- (UILabel *)timeLabel{
    if(_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, IPHONE_SCREEN_WIDTH, 60)];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:24.0];
    }
    return _timeLabel;
}
- (UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 50, 50)];
        _countLabel.textColor = [UIColor blackColor];
    }
    return _countLabel;
}
-(void)configureCell{
    [self addSubview:self.timeLabel];
    [self addSubview:self.countLabel];
}
@end
