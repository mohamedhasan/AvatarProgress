//
//  MyLivnAvatar.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnAvatar.h"
#import "MyLivnImageLoader.h"

#define kLineWidth 1.0

@interface MyLivnAvatar ()
{
  CAShapeLayer *_progressLayer;
  float _progress;
}
@property (nonatomic) MyLivnImageLoader *imageLoader;

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
  if (placeHolder) {
    UIImage *image = [UIImage imageNamed:placeHolder];
    if (image) {
      self.image = image;
    }
  }
  [self.imageLoader loadImage:url delegate:self];
}

- (void)dowloadProgressUpdated:(float)updatedValue
{
  [self animateProgressFromValue:_progress to:updatedValue];
  _progress = updatedValue;
}

- (void)dowloadTaskFinished:(UIImage *)image error:(NSError *)error
{
  self.image = image;
  [self.progressLayer removeFromSuperlayer];
}

- (CAShapeLayer *)progressLayer
{
  if (!_progressLayer) {
    
    _progressLayer = [[CAShapeLayer alloc] init];
    _progressLayer.strokeColor = [UIColor greenColor].CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.path = [self bezierPath].CGPath;
    _progressLayer.lineWidth = kLineWidth;
    _progressLayer.strokeStart = 0.0;
    _progressLayer.strokeEnd = 1.0;
    [self.layer addSublayer:_progressLayer];
  }
  
  return _progressLayer;
}

- (UIBezierPath *)bezierPath
{
  UIBezierPath *path = [UIBezierPath bezierPath];
  CGPoint middlePoint = CGPointMake(CGRectGetMaxX(self.bounds) / 2, CGRectGetMaxY(self.bounds) / 2);
  CGFloat radius = (self.bounds.size.width / 2) - (kLineWidth / 2) - 2;
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
@end
