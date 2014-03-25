//
//  Cell.m
//  Focord
//
//  Created by Lanston Peng on 2/14/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)initWithFrame:(CGRect)frame
{
  if( !(self = [super initWithFrame:frame])){
    return nil;
  }
  CGRect screenRect = [[UIScreen mainScreen]bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  self.myMap = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
  if(self.myMap == nil){
    NSLog(@"nil map");
  }
  else{
    NSLog(@"%@",self.myMap);
  }
  return self;
}
-(void)setProperty{
  self.myMap.zoomEnabled = NO;
  self.myMap.pitchEnabled = NO;
  self.myMap.scrollEnabled= NO;
  self.myMap.rotateEnabled = NO;
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
