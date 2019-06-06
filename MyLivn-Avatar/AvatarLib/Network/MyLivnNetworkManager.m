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

@interface MyLivnNetworkManager ()
{
  BOOL _hasConnection;
  NSTimer *_timer;
}
@property (nonatomic) NSOperationQueue *operationQueue;

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
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self selector:@selector(checkNetworkChanges)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

  }
  return self;
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

- (void)checkNetworkChanges
{
  if ([self isNetworkAvailable] != _hasConnection) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"networkStatusChanged" object:@{@"hasConnection":@([self isNetworkAvailable])}];
  }
  _hasConnection = [self isNetworkAvailable];
}

- (bool)isNetworkAvailable
{
  SCNetworkReachabilityFlags flags;
  SCNetworkReachabilityRef address;
  address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
  Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
  CFRelease(address);
  
  bool canReach = success
  && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
  && (flags & kSCNetworkReachabilityFlagsReachable);
  
  return canReach;
}

@end
