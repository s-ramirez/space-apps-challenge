//
//  AstronautsTableViewCell.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "AstronautsTableViewCell.h"

@implementation AstronautsTableViewCell {
    BOOL isSelected;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)subscribe:(id)sender {
    UIImage *btnImage;
    
    if(isSelected){
        btnImage = [UIImage imageNamed:@"subscribe"];
    }
    else {
        btnImage = [UIImage imageNamed:@"subscribe"];
    }
    isSelected = !isSelected;
    [self.subscribeBtn setImage:btnImage forState:UIControlStateNormal];
}
@end
