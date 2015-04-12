//
//  LoginViewController.h
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<MBProgressHUDDelegate>

- (IBAction)loginButtonTouchHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gif;


@end
