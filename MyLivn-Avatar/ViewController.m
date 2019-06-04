//
//  ViewController.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "ViewController.h"
#import "MyLivnAvatar.h"
#import "MyLivnCachManager.h"

#define IMAGES_URL @"https://api.unsplash.com/search/photos?page=1&query=faces&client_id=1b3f7d0be4e131592f6ccc8d0ada3f6b3882c7fe646baabbdabc3cf002b87865"

@interface ViewController ()
{
  NSInteger _currentIndex;
}
@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [MyLivnCachManager sharedInstance].maximumNumberOfObjects = @8;
  [MyLivnCachManager sharedInstance].maximumStorageSpace = @32598752;
  self.nextButton.enabled = NO;
  [self loadImagesFromFreeApi];
}

- (void)loadImagesFromFreeApi
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  NSURL *URL = [NSURL URLWithString:IMAGES_URL];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request
  completionHandler:
  ^(NSData *data, NSURLResponse *response, NSError *error) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    if (data && !error) {
      id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
      self.images = jsonObject[@"results"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        self.nextButton.enabled = YES;
        [self loadNext:nil];
      });
    }
  
  }];
  
  [task resume];
}

- (IBAction)loadNext:(id)sender
{
  if (_currentIndex < self.images.count) {
    NSString *url = self.images[_currentIndex][@"urls"][@"full"];
    [self.avatar loadImageWithUrl:url placeholder:@"placeHolder"];
    _currentIndex ++;
  }
}

@end
