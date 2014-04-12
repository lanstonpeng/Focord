//
//  Config.m
//  Focord
//
//  Created by Lanston Peng on 4/12/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Config.h"

@implementation Config
+(instancetype)sharedConfig{
    static Config* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Config alloc]init];
        instance.cubeSize = 20;
        instance.minSecond = 60;
    });
    return instance;
}
@end
