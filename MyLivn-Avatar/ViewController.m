//
//  ViewController.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "ViewController.h"
#import "MyLivnAvatar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.avatar loadImageWithUrl:@"https://thedcpmaster.com/wp2016/wp-content/uploads/2017/06/big-pumpkin.jpg" placeholder:@"placeHolder"];
}


@end
