//
//  DropBehaviour.h
//  Focord
//
//  Created by Lanston Peng on 3/24/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropBehaviour :UIDynamicBehavior
- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;
@end
