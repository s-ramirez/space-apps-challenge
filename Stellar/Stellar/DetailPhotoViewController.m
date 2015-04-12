//
//  DetailPhotoViewController.m
//  Stellar
//
//  Created by Jorge Vivas on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "DetailPhotoViewController.h"

@interface DetailPhotoViewController ()

@end

@implementation DetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mainImage setImage:_photoDetail.photo];
    _labelTitle.text = _photoDetail.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
