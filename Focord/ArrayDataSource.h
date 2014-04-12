//
//  ArrayDataSource.h
//  Focord
//
//  Created by Lanston Peng on 3/22/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^collectionCellConfigure)(id cell,id item,NSInteger index);
@interface ArrayDataSource : NSObject<UICollectionViewDataSource>

- (id)initWithItems:(NSArray*)items
       cellIdentifier:(NSString*)cellIdentifer
 cellConfigurateBlock:(collectionCellConfigure)collectionConfigrueBlock;

- (void)updateData:(NSArray*)items;
@end
