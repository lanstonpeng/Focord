//
//  ItemCell.h
//  Focord
//
//  Created by Lanston Peng on 3/11/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property(strong    ,nonatomic)IBOutlet UILabel* timeLabel;

-(void)configureCell;
@end
