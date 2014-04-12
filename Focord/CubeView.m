//
//  CubeView.m
//  Focord
//
//  Created by Lanston Peng on 4/12/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "CubeView.h"
#import "Util.h"

@implementation CubeView

-(UIView*)configureView:(CubeView*)cubeView
{
    [cubeView setBackgroundColor:[Util randomColor]];
    cubeView.origin = CGPointMake(0, 100);
    cubeView.containerSize = CGSizeMake(320, 320);
    cubeView.cubeSize = CGSizeMake(20, 20);
    return cubeView;
}
-(id)initWithIndex:(NSInteger)idx{
    if(self = [super init]){
        [self configureView:self];
        int cubeWidth = (int)self.cubeSize.width;
        int cubeHeight = (int)self.cubeSize.height;
        int containerWidth = (int)self.containerSize.width;
        int unit = containerWidth / cubeWidth;
        int allCubeWidth = cubeWidth * (int)idx ;
        int modeNum = fmod(allCubeWidth,containerWidth);
        int x =  modeNum *  unit * cubeWidth / containerWidth ;
        int y = allCubeWidth / containerWidth * cubeHeight ;
        self.frame = CGRectMake(self.origin.x + x,  self.origin.y + y, cubeWidth , cubeHeight );
    }
    return self;
}
-(id)init{
    if(self = [super init]){
        [self configureView:self];
        self.frame = CGRectMake(self.origin.x, self.origin.y,self.cubeSize.width,self.cubeSize.height);
    }
    return self;
}
+(int)getCurrentCubeIndex{
    return 1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
