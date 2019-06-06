//
//  MyLivnDataOperation.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnDataOperation.h"

@interface MyLivnDataOperation ()

@property (nonatomic) NSString *url;
@property (nonatomic, weak) id <NSURLSessionDelegate> delegate;
@property (nonatomic) NSURLSessionDataTask *dataTask;

@end

@implementation MyLivnDataOperation

+ (void)load
{
  [super load];
}
- (instancetype)initWithDataUrl:(NSString *)url delegate:(id <NSURLSessionDelegate>)delegate
{
  self = [super init];
  if (self) {
    self.url = url;
    self.delegate = delegate;
  }
  return self;
}

- (void)start
{
  [super start];
  
  NSString* encodedUrl = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  
  NSURLSessionConfiguration *configObject = [NSURLSessionConfiguration defaultSessionConfiguration];
  configObject.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
  configObject.URLCache = nil;
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configObject delegate:self.delegate delegateQueue:[NSOperationQueue mainQueue]];
  self.dataTask = [session dataTaskWithURL:[NSURL URLWithString:encodedUrl]];
  [self.dataTask resume];
}

- (void)cancel
{
  [super cancel];
  [self.dataTask cancel];
}
@end
