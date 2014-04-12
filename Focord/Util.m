//
//  Util.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Util.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation Util
+(NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
+(void)openUIManagedDocument:(void (^)(UIManagedDocument* document))completionHandler{

  NSURL *docURL = [[Util applicationDocumentsDirectory]URLByAppendingPathComponent:@"FocordDocument"];
  UIManagedDocument*  doc = [[UIManagedDocument alloc]initWithFileURL:docURL];
  BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:[docURL path]];
  if(fileExists){
    [doc openWithCompletionHandler:^(BOOL success){
      if(success)completionHandler(doc);
    }];
  }
  else{
    [doc saveToURL:docURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
      if(success)completionHandler(doc);
    }];
  }
}
+(UIManagedDocument*)getUIManagedDocument{
  
  NSURL *docURL = [[Util applicationDocumentsDirectory]URLByAppendingPathComponent:@"FocordDocument"];
  UIManagedDocument*  doc = [[UIManagedDocument alloc]initWithFileURL:docURL];
  return doc;
}
+(UIColor*)randomColor{
    switch (arc4random()%6) {
        case 0: return UIColorFromRGB(0x50ecb3);
        case 1: return UIColorFromRGB(0xb350ec);
        case 2: return UIColorFromRGB(0x50ec65);
        case 3: return UIColorFromRGB(0xecb350);
        case 4: return UIColorFromRGB(0xec5089);
        case 5: return UIColorFromRGB(0x50d7ec);
    }
    return [UIColor blackColor];
}
@end
