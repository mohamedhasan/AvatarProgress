//
//  MyLivnCachManager.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/4/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnCachManager : NSObject

+ (instancetype)sharedInstance;

/*! @brief Save files with a specific url as a key*/
- (void)cachData:(NSData *)data forURL:(NSString *)url;

/*! @brief retrieve saved file from a url*/
- (NSData *)cachedDataForUrl:(NSString *)url;

/*! @brief sets and retrieve maximum number of files can be cached by the app .... ignored if not set*/
@property(nonatomic) NSNumber *maximumNumberOfObjects;

/*! @brief sets and retrieve maximum number of bytes can be cached by the app .... ignored if not set*/
@property(nonatomic) NSNumber *maximumStorageSpace;

@end

NS_ASSUME_NONNULL_END
