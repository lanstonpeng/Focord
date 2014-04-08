//
//  DataAbstract.m
//  Focord
//
//  Created by Lanston Peng on 3/26/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "DataAbstract.h"
#import "objc/runtime.h"

@interface DataAbstract()
@property (strong,nonatomic)NSMutableArray* dayContainerData;
@end
@implementation DataAbstract
+ (instancetype)sharedData
{
    static DataAbstract* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataAbstract alloc]init];
    });
    return instance;
}
-(NSArray*)dayContainerData
{
    if(!_dayContainerData){
        _dayContainerData = [[NSMutableArray alloc]init];
    }
    return _dayContainerData;
}
- (NSString*)getFilePath
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if(![[NSFileManager defaultManager]fileExistsAtPath:docPath ]){
        [[NSFileManager defaultManager]createFileAtPath:docPath contents:nil attributes:nil];
    }
    return [docPath stringByAppendingPathComponent:@"test.dat"];
}
- (NSMutableDictionary*)InstanceToDictionary:(id)entity
{
    Class itemClass = [entity class];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    unsigned int count;
    objc_property_t* proplist =  class_copyPropertyList(itemClass, &count);
    for(int i = 0; i < count; i++){
        NSString* properName = [NSString stringWithFormat:@"%s",property_getName(proplist[i])];
        [dict setObject:[entity valueForKey:properName] forKey:properName];;
    }
    return dict;
}
-(BOOL)addItem:(id)item
{
    NSMutableDictionary* dict = [self InstanceToDictionary:item];
    [self.dayContainerData insertObject:dict atIndex:0];
    //[NSKeyedArchiver archiveRootObject:self.dayContainerData toFile:docPath];
    return YES;
}
-(BOOL)removeItem:(NSDictionary*)item{
    return YES;
}
-(BOOL)updateItem:(id)dayContainer{
    NSMutableArray* allResults = [self getAllItem];
    for(NSDictionary* item in allResults){
        if([[[item valueForKey:@"dayID"] stringValue] isEqualToString:[[dayContainer valueForKey:@"dayID"] stringValue]]){
            NSMutableDictionary* dict = [self InstanceToDictionary:dayContainer];
            [allResults replaceObjectAtIndex:[allResults indexOfObject:item] withObject:dict];
            break;
        }
    }
    return YES;
}
-(NSMutableArray*)searchItem:(NSString*)key value:(NSString *)value
{
    NSMutableArray* allResults = [[NSMutableArray alloc]init];
    for(NSDictionary* dic in [self getAllItem]){
        if([[dic valueForKey:key] isEqualToString:value]){
            [allResults addObject:dic];
        }
    }
    return allResults;
}
-(NSMutableArray*)getAllItem
{
    if(![self.dayContainerData firstObject]){
        NSString* docPath = [self getFilePath];
        self.dayContainerData = [NSKeyedUnarchiver unarchiveObjectWithFile:docPath];
    }
    return self.dayContainerData;
}
-(void)removeDataFile
{
    NSString* docPath = [self getFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:docPath error:nil];
}
-(void)flushData
{
    NSString* docPath = [self getFilePath];
    [NSKeyedArchiver archiveRootObject:self.dayContainerData toFile:docPath];
}
@end
