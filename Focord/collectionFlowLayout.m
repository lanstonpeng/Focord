//
//  collectionFlowLayout.m
//  Focord
//
//  Created by Lanston Peng on 2/17/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "collectionFlowLayout.h"

@implementation collectionFlowLayout
-(id)init{

  if(!(self = [super init])){
    return nil;
  }
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  self.itemSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
  self.sectionInset = UIEdgeInsetsMake(0,0,0,0);
  self.minimumInteritemSpacing = 0;
  self.minimumLineSpacing = 0;
  return self;
}
@end
