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
-(void)configureCell{
    self.backgroundColor = [UIColor blackColor];
    self.countLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:24.0];
    self.timeLabel.frame =CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 80);
}
@end
