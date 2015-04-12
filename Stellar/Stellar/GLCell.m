//
//  GLCell.m
//  GLGooglePlusLayout
//
//  Created by Gautam Lodhiya on 21/04/13.
//  Copyright (c) 2013 Gautam Lodhiya. All rights reserved.
//

#import "GLCell.h"

@interface GLCell()

@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *displayPhoto;

@end

@implementation GLCell

#pragma mark - Accessors
- (UILabel *)displayLabel
{
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _displayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayLabel.textColor = [UIColor whiteColor];
        _displayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayLabel;
}

- (UIImageView *)displayPhoto
{
    if (!_displayPhoto) {
        _displayPhoto = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _displayPhoto.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _displayPhoto.backgroundColor = [UIColor lightGrayColor];
        _displayPhoto.image = [UIImage imageNamed:@"liveOnSpace"];
    }
    return _displayPhoto;
}

- (void)setDisplayString:(NSString *)displayString
{
    if (![_displayString isEqualToString:displayString]) {
        _displayString = [displayString copy];
        //self.displayLabel.text = _displayString;
    }
}

- (void)setDisplayData:(NSString *)displayString photo:(UIImage*)image {
    if (![_displayString isEqualToString:displayString]) {
        _displayString = [displayString copy];
        self.displayLabel.text = _displayString;
    }
}


#pragma mark - Life Cycle
- (void)dealloc
{
    [_displayLabel removeFromSuperview];
    [_displayPhoto removeFromSuperview];
    _displayLabel = nil;
    _displayPhoto = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.displayPhoto];
    }
    return self;
}

@end
