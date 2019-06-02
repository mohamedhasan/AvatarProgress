//
//  MyLivnImageLoader.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MyLivnLoadingImageProtocol <NSObject>

- (void)dowloadProgressUpdated:(float)progress;
- (void)dowloadTaskFinished:(UIImage *)image error:(NSError *)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnImageLoader : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

- (void)loadImage:(NSString *)urlString delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
