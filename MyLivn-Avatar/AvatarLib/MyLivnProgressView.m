//
//  MyLivnProgressView.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnProgressView.h"

#define kDefaultLineWidth 2.0

@interface MyLivnProgressView ()
{
  CAShapeLayer *_progressLayer;
}
@end

@implementation MyLivnProgressView

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
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
  CGFloat radius = (self.bounds.size.width / 2);
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

- (void)showProgress
{
  self.progressLayer.lineWidth = self.loadingWidth;
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
