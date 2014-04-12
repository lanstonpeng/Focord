//
//  CubeView.h
//  Focord
//
//  Created by Lanston Peng on 4/12/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CubeView : UIView
@property (nonatomic)CGPoint origin;
@property (nonatomic)CGSize cubeSize;
@property (nonatomic)CGSize containerSize;
-(id)init;
-(id)initWithIndex:(NSInteger)idx;
+(int)getCurrentCubeIndex;
@end
