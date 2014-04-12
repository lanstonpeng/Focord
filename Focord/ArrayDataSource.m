//
//  ArrayDataSource.m
//  Focord
//
//  Created by Lanston Peng on 3/22/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "ArrayDataSource.h"


@interface ArrayDataSource()
@property (nonatomic,strong)NSArray* results;
@property (nonatomic,copy)NSString* cellIdentifier;
@property (nonatomic,copy)collectionCellConfigure configureBlock;
@end

@implementation ArrayDataSource
- (void)updateData:(NSArray*)items
{
    self.results = items;
}
- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifer cellConfigurateBlock:(collectionCellConfigure)collectionConfigrueBlock
{
    if (self = [super init])
    {
        self.results = items;
        self.cellIdentifier = cellIdentifer;
        self.configureBlock = collectionConfigrueBlock;
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSLog(@"cellForItemAtIndexPath %@",cell);
    NSInteger idx = indexPath.row;
    self.configureBlock(cell,[self.results objectAtIndex:idx],idx);
    return cell;
}
@end
