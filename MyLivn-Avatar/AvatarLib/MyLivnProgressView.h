//
//  MyLivnProgressView.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLivnProgressView : UIView

@property (nonatomic)IBInspectable NSInteger loadingWidth;
@property (nonatomic)IBInspectable UIColor *loadingColor;
@property (nonatomic)IBInspectable UIColor *errorColor;

- (void)animateProgressFromValue:(float)from to:(float)to;
- (void)showProgress;
- (void)hideProgress;
- (void)resetProgress;
- (void)showError;

@end

NS_ASSUME_NONNULL_END
