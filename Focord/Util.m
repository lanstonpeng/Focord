//
//  Util.m
//  Focord
//
//  Created by Lanston Peng on 2/18/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "Util.h"

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
@end
