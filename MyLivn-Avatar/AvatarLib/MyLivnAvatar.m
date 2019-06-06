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
#import "MyLivnProgressView.h"

@interface MyLivnAvatar ()
{
  float _progress;
}

@property (nonatomic) MyLivnImageLoader *imageLoader;
@property (nonatomic) NSString *url;
@property (nonatomic) MyLivnProgressView *progressView;

@end

@implementation MyLivnAvatar

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.imageLoader = [MyLivnImageLoader new];
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  self.progressView = [[MyLivnProgressView alloc] initWithFrame:self.bounds];
}

- (void)setLoadingWidth:(NSInteger)loadingWidth
{
  _loadingWidth = loadingWidth;
  self.progressView.loadingWidth = loadingWidth;
}

- (void)setLoadingColor:(UIColor *)loadingColor
{
  _loadingColor = loadingColor;
  self.progressView.loadingColor = loadingColor;
}

- (void)setErrorColor:(UIColor *)errorColor
{
  _errorColor = errorColor;
  self.progressView.errorColor = errorColor;
  [self addSubview:self.progressView];
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
  [self.progressView resetProgress];
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
  [self.progressView animateProgressFromValue:_progress to:updatedValue];
  _progress = updatedValue;
}

- (void)dowloadTaskFinished:(UIImage *)image error:(NSError *)error
{
  
  if (error) {
    [self.progressView showError];
    return;
  }
  
  if (image) {
    self.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [[MyLivnCachManager sharedInstance] cachData:imageData forURL:self.url];
    [self.progressView hideProgress];
  }
}

- (void)dowloadTaskStarted
{
  [self.progressView showProgress];
}

- (void)setImage:(UIImage *)image
{
  [super setImage:[self roundedSizedImage:image]];
}

- (UIImage *)roundedSizedImage:(UIImage *)image
{
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.image = image;
  CALayer *layer = imageView.layer;
  layer.masksToBounds = YES;
  layer.cornerRadius = self.bounds.size.width / 2;
  UIGraphicsBeginImageContext(self.bounds.size);
  [layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return roundedImage;
}

@end
