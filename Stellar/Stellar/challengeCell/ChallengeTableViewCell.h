//
//  ChallengeTableViewCell.h
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) NSString *videoUrl;

@end
