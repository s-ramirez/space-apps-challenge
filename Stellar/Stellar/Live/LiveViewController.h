//
//  LiveViewController.h
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonNearLocation;

- (IBAction)actionNearLocation:(id)sender;
@end
