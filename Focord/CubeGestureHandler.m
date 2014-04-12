//
//  GestureHandler.m
//  Focord
//
//  Created by Lanston Peng on 4/12/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "CubeGestureHandler.h"

@implementation CubeGestureHandler
static CGRect cacheFrame;
+(void)handleSingleTap
{
    NSLog(@"taping");
}
+(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        CGRect frame = recognizer.view.frame;
        cacheFrame = frame;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        CGRect frame = cacheFrame;
        CGPoint point = [recognizer translationInView:recognizer.view];
        frame.size.height = (point.y / frame.size.height) * 400;
        recognizer.view.frame = frame;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        recognizer.view.frame = cacheFrame;
    }
}
+(void)addCubeView:(UIView*)view{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    UIPanGestureRecognizer* pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [view addGestureRecognizer:singleTap];
    [view addGestureRecognizer:pan];
}
@end
