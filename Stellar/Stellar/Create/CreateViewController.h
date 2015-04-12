//
//  CreateViewController.h
//  Stellar
//
//  Created by Sebastián Ramírez on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface CreateViewController : UIViewController

@property(nonatomic, assign) id delegate;

- (IBAction)pickImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
- (IBAction)uploadChallenge:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *challengeTitle;
@property (weak, nonatomic) IBOutlet UITextView *challengeDescription;

@end
