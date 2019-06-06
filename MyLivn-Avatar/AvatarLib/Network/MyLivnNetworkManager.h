//
//  MyLivnNetworkManager.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnNetworkManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadFileWithUrl:(NSString *)url delegate:(id <NSURLSessionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
