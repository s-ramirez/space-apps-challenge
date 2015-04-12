//
//  VotingChallengeTableViewCell.h
//  Stellar
//
//  Created by Kai on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VotingChallengeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
- (IBAction)vote:(id)sender;


@end
