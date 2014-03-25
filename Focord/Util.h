//
//  Util.h
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(void)openUIManagedDocument:(void (^)(UIManagedDocument* document))completionHandler;
+(UIManagedDocument*)getUIManagedDocument;
@end
