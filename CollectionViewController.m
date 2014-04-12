//
//  CollectionViewController.m
//  Focord
//
//  Created by Lanston Peng on 2/14/14.
//  Copyright (c) 2014 Vtmer. All rights reserved.
//

#import "CollectionViewController.h"
#import "ItemCell.h"
#import "collectionFlowLayout.h"
#import "Util.h"
#import "LocationMonitor.h"
#import "MotionMonitor.h"
#import "Counter.h"
#import "ArrayDataSource.h"
#import "DropBehaviour.h"
#import "DayContainer.h"
#import "Record.h"
#import "DeviceInfo.h"


#define DEBUG_MODE 1
#define RECORD_MOTION @"up"
#define DATE_FORMATE @"yyyy-MM-dd"

@interface CollectionViewController ()
@property  (strong,nonatomic)NSArray* results;
@property (strong,nonatomic)ArrayDataSource* recordDataSource;
@property (strong,nonatomic)NSMutableArray*  records;
@property (strong,nonatomic)DayContainer* currentDayContainer;
@property (strong,nonatomic)DropBehaviour* dropBehaviour;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic)NSMutableArray* dropViewArray;
@property (strong,nonatomic)UICollectionViewLayout* layout;
@property (strong,nonatomic)NSTimer* timer;
@property (strong,nonatomic)UIView* currentCubeView;
@property (strong,nonatomic)ItemCell* currentItemCell;
@property (strong,nonatomic)UITapGestureRecognizer* tapGesture;
@property (strong,nonatomic)UIPanGestureRecognizer* panGesture;
@property (strong,nonatomic)Counter* counter;
@property (strong,nonatomic)MotionMonitor* motionMonitor;
@property (nonatomic)BOOL   isRunningCubeBlock;
@end
@implementation CollectionViewController

static CGRect cacheFrame;

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}
static const CGSize DROP_SIZE = { 40, 40 };
- (NSMutableArray *)records
{
    if(!_records){
        _records = [[NSMutableArray alloc]init];
    }
    return _records;
}
- (NSMutableArray *)dropViewArray
{
    if(!_dropViewArray){
        _dropViewArray = [[NSMutableArray alloc]init];
    }
    return _dropViewArray;
}
- (DropBehaviour *)dropBehaviour
{
    if (!_dropBehaviour) {
    _dropBehaviour = [[DropBehaviour alloc] init];
        [self.animator addBehavior:_dropBehaviour];
    }
    return _dropBehaviour;
}
-(DayContainer*)currentDayContainer
{
    if(!_currentDayContainer){
        _currentDayContainer = [[DayContainer alloc]init];
    }
    return _currentDayContainer;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator =[[UIDynamicAnimator alloc]initWithCollectionViewLayout:self.layout];
        //_animator =[[UIDynamicAnimator alloc]initWithReferenceView:self.myCollection];
        _animator.delegate = self;
    }
    return _animator;
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    for(UIView* view in self.dropViewArray){
        [self.dropBehaviour removeItem:view];
    }
}

- (UIPanGestureRecognizer *)panGesture{
    if(!_panGesture){
        _panGesture  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    }
    return _panGesture;
}
-(void)handleSingleTap
{
    NSLog(@"taping");
}
-(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    NSLog(@"paning%@",recognizer.view);
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
- (void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.myCollection.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    [dropView setBackgroundColor:[self randomColor]];
    [self.myCollection addSubview:dropView];
    [self.dropViewArray addObject:dropView];
    
    [self.dropBehaviour addItem:dropView];
}

- (UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}
- (void)dropCube
{
    [self.dropBehaviour addItem:self.currentCubeView];
}
-(void)drawCube
{
    UIView* cubeView = [[UIView alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 20, IPHONE_SCREEN_HEIGHT / 3, 40, 40)];
    UILabel* indicator = [[UILabel alloc]init];
    [cubeView setBackgroundColor:[self randomColor]];
    [cubeView addSubview:indicator];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    [cubeView addGestureRecognizer:singleTap];
    [self.myCollection addSubview:cubeView];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(bigifyCube:) userInfo:@{@"view":cubeView} repeats:YES];
    self.currentCubeView = cubeView;
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
-(void)bigifyCube:(id)sender{
    NSTimer* timer = (NSTimer*)sender;
    UIView* cubeView= [timer.userInfo objectForKey:@"view"];
    UILabel* indicator = cubeView.subviews[0];
    //indicator.text = [NSString stringWithFormat:@"%d",(int)cubeView.frame.size.width + 1];
    indicator.text =[NSString stringWithFormat:@"%lu",self.counter.duration];
    indicator.frame = CGRectMake(cubeView.frame.size.width/2 - 10, cubeView.frame.size.height/2 - 10, 20, 20);
    [indicator sizeToFit];
    indicator.textColor=[UIColor whiteColor];
    CGRect frame;
    frame.origin = cubeView.frame.origin;
    frame.size.width = cubeView.frame.size.width + 1;
    frame.size.height = cubeView.frame.size.height + 1;
    frame.origin.x = frame.origin.x - 0.5;
    frame.origin.y = frame.origin.y - 0.5;
    [cubeView setFrame:frame];
}
- (UIView*)generateCube:(Record*)record
{
    int duration = [record.endTime intValue] - [record.startTime intValue];
    UIView* cube = [[UIView alloc]initWithFrame:CGRectMake(arc4random()% 300 , arc4random()% 300, 20 + duration, 20 + duration)];
    CGFloat cubeWidth =cube.frame.size.width;
    CGFloat cubeHeight = cube.frame.size.height;
    UILabel* durationLabel  = [[UILabel alloc]initWithFrame:CGRectMake(cubeWidth * 0.4, cubeWidth*0.4, cubeWidth* 0.6, cubeHeight*0.6)];
    [durationLabel setText:[NSString stringWithFormat:@"%d",duration ]];
    [durationLabel setTextColor:[UIColor whiteColor]];
    [cube addSubview:durationLabel];
    [cube setBackgroundColor:[self randomColor]];
    return cube;
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.myCollection reloadData];
}


#pragma Monitor Handler
-(void)handleMonitor:(id)sender{
    NSNotification* notification = (NSNotification*)sender;
    NSString* type = [notification.userInfo objectForKey:@"type"];
    if([type isEqualToString:MOTION_UP]){
        if(self.counter.status == CounterStop){
            [self.counter startCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drawCube];
            });
        }
    }
    else if([type isEqualToString:MOTION_OTHER]){
        NSLog(@"isRunningBlock: %d",self.isRunningCubeBlock);
        
        if(self.isRunningCubeBlock || self.counter.status == CounterStop){
            return;
        }
        self.isRunningCubeBlock = YES;
        [self.counter stopCount];
        [self.timer invalidate];
        Record* record = [[Record alloc]init];
        record.recordID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        record.endTime =  [[NSNumber alloc]initWithDouble:self.counter.endTime];
        record.startTime = [[NSNumber alloc]initWithDouble:self.counter.startTime];
        record.recordDescription = @"Well,Test Data";
        NSTimeInterval duration = self.counter.duration;
        //only duration more 30s is count
        if(self.currentCubeView){
            if(duration > 5.0){
        #ifdef DEBUG_MODE
                if(duration < 6.0){
        #endif
                    [Record addRecord:record belongsToDate:self.currentDayContainer.date];
                    if([(NSString*)[notification.userInfo objectForKey:@"timing"] isEqualToString:TIMING_LASTCALL]){
                        //[self.recordDataSource updateData:[DayContainer getAllDayContainer]];
                        //[self.myCollection reloadData];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self dropCube];
                        });
                    }
                    DayContainer* dc =[DayContainer getAllDayContainer][0];
                    NSLog(@"Current Data ==> %@",dc.record);
        #ifdef DEBUG_MODE
                }
        #endif
            }
            else{
                //otherwise it should disappear
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        //self.currentCubeView.alpha = 0.0;
                        CGRect cubeFrame = self.currentCubeView.frame;
                        self.currentCubeView.frame= CGRectMake(cubeFrame.origin.x + cubeFrame.size.width/2, cubeFrame.origin.y  + cubeFrame.size.height/2, 0,0);
                    } completion:^(BOOL finished) {
                        [self.currentCubeView removeFromSuperview];
                    }];
                });
            }
        }
        self.isRunningCubeBlock = NO;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    //self.myCollection.alwaysBounceHorizontal = YES;
    self.myCollection.scrollEnabled = YES;
    UICollectionViewFlowLayout* customLayout = [[collectionFlowLayout alloc]init];
    self.myCollection.collectionViewLayout = customLayout;
    [self.myCollection setPagingEnabled:YES];
    [self.myCollection setBounces:NO];

#pragma Motion Stuffs
    self.motionMonitor = [MotionMonitor sharedMotionManager];
    self.counter = [Counter sharedConter];
    
#pragma CollectionView DataSource
    collectionCellConfigure configureBlock = ^(id cell,id item,NSInteger idx){
        ItemCell* itemcell = (ItemCell*)cell;
        DayContainer* cellDayContainer = (DayContainer*)item;
        if((int)idx > 0){
            NSLog(@"stop Monitor");
            [self.motionMonitor stopMonitor];
        }
        else{
            NSLog(@"start Monitor");
            [self.motionMonitor addListener:self withSelector:@selector(handleMonitor:)];
            [self.motionMonitor startMonitor];
        }
        [itemcell configureCell];
        for(UIView* lastView in self.records){
            [lastView removeFromSuperview];
            [self.dropBehaviour removeItem:lastView];
        }
        for(Record* recordItem in cellDayContainer.record){
                UIView* temp = [self generateCube:recordItem];
                //NSLog(@"->%d,%@",[recordItem.endTime intValue] - [recordItem.startTime intValue],temp);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dropBehaviour addItem:temp];
                });
                [self.records addObject:temp];
                [itemcell addSubview:temp];
        }
        
        NSString* count = [NSString stringWithFormat:@"%lu",(unsigned long)[cellDayContainer.record count]];
        itemcell.countLabel.text = count;
        NSString* date = cellDayContainer.date;
        itemcell.timeLabel.text = date;
        [self rearrangeCubes];
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMATE];
    DayContainer* todayContainer = [[DayContainer searchDayContainer:@"date" withValue:[dateFormatter stringFromDate:[NSDate date]]] firstObject];
    if(!todayContainer){//if there's the first time entering the app in a day, create a new dayContainer
        DayContainer* dayContainer = [[DayContainer alloc]init];
        dayContainer.dayID = [[NSNumber alloc]initWithDouble:NSTimeIntervalSince1970];
        dayContainer.date = [dateFormatter stringFromDate:[NSDate date]];
        dayContainer.record = [[NSMutableArray alloc]initWithCapacity:0];
        [DayContainer addDayContainer:dayContainer];
    }
    self.results = [DayContainer getAllDayContainer];
    self.currentDayContainer = [self.results firstObject];
    
    self.recordDataSource = [[ArrayDataSource alloc]initWithItems:self.results cellIdentifier:@"cell" cellConfigurateBlock:configureBlock];
    self.myCollection.dataSource = self.recordDataSource;
    
    //prevent app from sleeping
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    //DataAbstract* da = [DataAbstract sharedData];
    //[da removeDataFile];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}

//I need an algorithm
-(void)rearrangeCubes
{
    [self.records sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* v1 = (UIView*)obj1;
        UIView* v2 = (UIView*)obj2;
        if(v1.frame.size.height > v2.frame.size.height){
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
    }];
}
@end
