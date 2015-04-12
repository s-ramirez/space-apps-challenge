//
//  DetailPhotoViewController.h
//  Stellar
//
//  Created by Jorge Vivas on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetail.h"

@interface DetailPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) PhotoDetail* photoDetail;

- (IBAction)closeAction:(id)sender;


@end
