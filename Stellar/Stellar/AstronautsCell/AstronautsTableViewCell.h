//
//  AstronautsTableViewCell.h
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AstronautDelegate.h"

@interface AstronautsTableViewCell : UITableViewCell
@property (nonatomic, assign) id<AstronautDelegate> delegate;
@property (nonatomic, strong) NSString *astronautId;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
- (IBAction)subscribe:(id)sender;

@end
