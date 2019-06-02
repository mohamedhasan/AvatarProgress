//
//  MyLivnAvatar.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLivnImageLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnAvatar : UIImageView <MyLivnLoadingImageProtocol>

/*! @brief Loads Avatar from a http string (url) placeHolder is an optional image to show while loading the actual image*/
- (void)loadImageWithUrl:(nonnull NSString *)url placeholder:(NSString *)placeHolder;

@end

NS_ASSUME_NONNULL_END
