//
//  MyLivnAvatar.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnAvatar.h"
#import "MyLivnImageLoader.h"
#import "MyLivnCachManager.h"

#define kDefaultLineWidth 2.0

@interface MyLivnAvatar ()
{
  CAShapeLayer *_progressLayer;
  float _progress;
}
@property (nonatomic) MyLivnImageLoader *imageLoader;
@property (nonatomic) NSString *url;
@end

@implementation MyLivnAvatar

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.clipsToBounds = YES;
  self.layer.cornerRadius = self.frame.size.width / 2;
  self.imageLoader = [MyLivnImageLoader new];
  self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)loadImageWithUrl:(nonnull NSString *)url placeholder:(NSString *)placeHolder
{
  if (!url) {
    return;
  }
  self.url = url;
  
  UIImage *cahedImage = [self cachedVersion];
  if (cahedImage) {
    self.image = cahedImage;
    return;
  }
  
  if (placeHolder) {
    UIImage *image = [UIImage imageNamed:placeHolder];
    if (image) {
      self.image = image;
    }
  }
  [self resetProgress];
  [self.imageLoader loadImage:url delegate:self];
}

- (UIImage *)cachedVersion
{
  NSData *data = [[MyLivnCachManager sharedInstance] cachedDataForUrl:self.url];
  if (data) {
    return [UIImage imageWithData:data];
  }
  return nil;
}

#pragma mark MyLivnLoadingImageProtocol methods
- (void)dowloadProgressUpdated:(float)updatedValue
{
  [self animateProgressFromValue:_progress to:updatedValue];
  _progress = updatedValue;
}

- (void)dowloadTaskFinished:(UIImage *)image error:(NSError *)error
{
  
  if (error) {
    [self showError];
    return;
  }
  
  if (image) {
    self.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [[MyLivnCachManager sharedInstance] cachData:imageData forURL:self.url];
    [self hideProgress];
  }
}

- (void)dowloadTaskStarted
{
  [self showProgress];
}

- (UIColor *)loadingColor
{
  if (!_loadingColor) {
    return [UIColor greenColor];
  }
  return _loadingColor;
}

- (UIColor *)errorColor
{
  if (!_errorColor) {
    return [UIColor redColor];
  }
  return _errorColor;
}

- (NSInteger)loadingWidth
{
  if (!_loadingWidth) {
    return kDefaultLineWidth;
  }
  return _loadingWidth;
}

- (CAShapeLayer *)progressLayer
{
  if (!_progressLayer) {
    
    _progressLayer = [CAShapeLayer new];
    _progressLayer.strokeColor = self.loadingColor.CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.path = [self bezierPath].CGPath;
    _progressLayer.lineWidth = self.loadingWidth;
    _progressLayer.strokeStart = 0.0;
    _progressLayer.strokeEnd = 0.0;
    [self.layer addSublayer:_progressLayer];
  }
  
  return _progressLayer;
}

- (UIBezierPath *)bezierPath
{
  UIBezierPath *path = [UIBezierPath bezierPath];
  CGPoint middlePoint = CGPointMake(CGRectGetMaxX(self.bounds) / 2, CGRectGetMaxY(self.bounds) / 2);
  CGFloat radius = (self.bounds.size.width / 2) - (self.loadingWidth / 2) - 2;
  CGFloat startAngle = -M_PI_2;
  CGFloat endAngle = startAngle + (2 * M_PI);
  
  [path addArcWithCenter:middlePoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
  
  return path;
}

- (void)animateProgressFromValue:(float)from to:(float)to
{
  CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  animateStrokeEnd.fromValue = [NSNumber numberWithFloat:from];
  animateStrokeEnd.toValue = [NSNumber numberWithFloat:to];
  [self.progressLayer addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
}

#pragma mark progress methods

- (void)showProgress
{
  self.progressLayer.lineWidth = kDefaultLineWidth;
}

- (void)hideProgress
{
  self.progressLayer.lineWidth = 0;
}

- (void)resetProgress
{
  self.progressLayer.strokeColor = self.loadingColor.CGColor;
  self.progressLayer.strokeEnd = 0;
}

- (void)showError
{
  [self showProgress];
  self.progressLayer.strokeColor = self.errorColor.CGColor;
  self.progressLayer.strokeEnd = 1;
}

@end
