//
//  Config.h
//  Focord
//
//  Created by Lanston Peng on 4/12/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
@property (nonatomic)int cubeSize;
@property (nonatomic)int minSecond;
+(instancetype)sharedConfig;
@end
