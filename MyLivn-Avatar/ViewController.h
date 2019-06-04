//
//  ViewController.h
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 5/31/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLivnAvatar.h"

@interface ViewController : UIViewController

@property(weak) IBOutlet MyLivnAvatar *avatar;
@property(weak) IBOutlet UIButton *nextButton;

- (IBAction)loadNext:(id)sender;

@end

