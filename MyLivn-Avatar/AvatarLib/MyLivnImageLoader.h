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

- (void)dowloadTaskStarted;
- (void)dowloadProgressUpdated:(float)progress;
- (void)dowloadTaskFinished:(UIImage *)image error:(NSError *)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnImageLoader : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

/*! @brief Loads Avatar from a http string (url) and uses delegate that conforms to MyLivnLoadingImageProtocol to repsond to specific events*/
- (void)loadImage:(NSString *)urlString delegate:(id <MyLivnLoadingImageProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
