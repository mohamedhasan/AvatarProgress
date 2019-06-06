//
//  MyLivnNetworkManager.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnNetworkManager.h"
#import "MyLivnDataOperation.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"

@interface MyLivnNetworkManager ()
{
  BOOL _hasConnection;
  NSTimer *_timer;
}
@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation MyLivnNetworkManager

+ (instancetype)sharedInstance
{
  static MyLivnNetworkManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MyLivnNetworkManager alloc] init];
  });
  return sharedInstance;
}

-(instancetype)init
{
  self = [super init];
  if (self) {
    self.operationQueue = [NSOperationQueue new];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
      [self refreshFileOperations];
      [self.internetReachability startNotifier];
    }];
  }
  return self;
}

- (void)refreshFileOperations
{
  if (self.internetReachability.currentReachabilityStatus == NotReachable) {
    [self.operationQueue cancelAllOperations];
  } else {
    for (MyLivnDataOperation *operation in self.operationQueue.operations) {
      if (operation.cancelled) {
        [operation start];
      }
    }
  }
}

- (void)loadFileWithUrl:(NSString *)url delegate:(id <NSURLSessionDelegate>)delegate
{
  MyLivnDataOperation *operation = [[MyLivnDataOperation alloc] initWithDataUrl:url delegate:delegate];
  [self addOperation:operation];
}

- (void)addOperation:(NSOperation *)operation
{
  [self.operationQueue addOperation:operation];
}


@end
