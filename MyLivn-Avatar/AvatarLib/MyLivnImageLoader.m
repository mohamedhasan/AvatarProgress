//
//  MyLivnImageLoader.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnImageLoader.h"

@interface MyLivnImageLoader()
{
  float _progress;
  float _downloadSize;
  NSMutableData *_imageData;
}
@property (weak) id<MyLivnLoadingImageProtocol> delegate;

@end

@implementation MyLivnImageLoader

- (void)loadImage:(NSString *)urlString delegate:(id)delegate
{
  self.delegate = delegate;
  NSURLSessionConfiguration *configObject = [NSURLSessionConfiguration defaultSessionConfiguration];
  configObject.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
  configObject.URLCache = nil;
  NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:configObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  NSURLSessionDataTask *imageDownloadTask = [defaultSession dataTaskWithURL:[NSURL URLWithString:urlString]];
  [imageDownloadTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
  completionHandler(NSURLSessionResponseAllow);
  _progress = 0.0f;
  _downloadSize = [response expectedContentLength];
  _imageData = [[NSMutableData alloc]init];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  [_imageData appendData:data];
  _progress = [_imageData length] / _downloadSize;
  
  if (_progress == 1) {
    
    UIImage *image = [UIImage imageWithData:_imageData];
    if ([self.delegate respondsToSelector:@selector(dowloadTaskFinished:error:)]) {
      [self.delegate dowloadTaskFinished:image error:nil];
    }
  } else {
    if ([self.delegate respondsToSelector:@selector(dowloadProgressUpdated:)]) {
      [self.delegate dowloadProgressUpdated:_progress];
    }
  }
  
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
  if ([self.delegate respondsToSelector:@selector(dowloadTaskFinished:error:)]) {
    [self.delegate dowloadTaskFinished:nil error:error];
  }
}
@end
