//
//  MyLivnImageLoader.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnImageLoader.h"
#import "MyLivnNetworkManager.h"

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
  [[MyLivnNetworkManager sharedInstance] loadFileWithUrl:urlString delegate:self];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
  completionHandler(NSURLSessionResponseAllow);
  _progress = 0.0f;
  _downloadSize = [response expectedContentLength];
  _imageData = [[NSMutableData alloc]init];
  
  if ([self.delegate respondsToSelector:@selector(dowloadTaskStarted)]) {
    [self.delegate dowloadTaskStarted];
  }
  
  if (dataTask.error) {
    if ([self.delegate respondsToSelector:@selector(dowloadTaskFinished:error:)]) {
      [self.delegate dowloadTaskFinished:nil error:dataTask.error];
    }
  }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  [_imageData appendData:data];
  _progress = [_imageData length] / _downloadSize;
  
  if ([self.delegate respondsToSelector:@selector(dowloadProgressUpdated:)]) {
      [self.delegate dowloadProgressUpdated:_progress];
  }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  if (error) {
    if ([self.delegate respondsToSelector:@selector(dowloadTaskFinished:error:)]) {
      [self.delegate dowloadTaskFinished:nil error:error];
    }
  }
  else {
    UIImage *image = [UIImage imageWithData:_imageData];
    if ([self.delegate respondsToSelector:@selector(dowloadTaskFinished:error:)]) {
      [self.delegate dowloadTaskFinished:image error:nil];
    }
  }
}
@end
