//
//  VotingChallengeTableViewCell.m
//  Stellar
//
//  Created by Kai on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "VotingChallengeTableViewCell.h"

@implementation VotingChallengeTableViewCell {
    BOOL isSelected;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)vote:(id)sender {
    int totalVotes = [_votesLabel.text intValue];
    UIImage *btnImage;
    if(isSelected){
        totalVotes -= 1;
        btnImage = [UIImage imageNamed:@"first"];
    }
    else {
        totalVotes += 1;
        btnImage = [UIImage imageNamed:@"second"];
    }
    _votesLabel.text = [NSString stringWithFormat:@"%d", totalVotes];
    isSelected = !isSelected;
    [_voteBtn setImage:btnImage forState:UIControlStateNormal];
}
@end
