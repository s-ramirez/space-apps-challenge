//
//  CreateViewController.m
//  Stellar
//
//  Created by Sebastián Ramírez on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//
#import "CreateViewController.h"
#import "CircleProgressBar.h"
#import <Parse/Parse.h>

@interface CreateViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    NSData *uploadImage;
    MBProgressHUD *hudProgress;
    int currentProgress;
    PFObject *currentUser;
    BOOL loaded;
    
}

@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;

@end

@implementation CreateViewController
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userImage.layer.cornerRadius = 33;//Half of the height
    _userImage.layer.masksToBounds = YES;
    _userImage.contentMode = UIViewContentModeScaleAspectFill;
    [_circleProgressBar setStartAngle:270];
    [_circleProgressBar setProgressBarWidth:4];
    [_circleProgressBar setProgress:0.57 animated:YES];
    // Do any additional setup after loading the view from its nib.
    NSArray *ranks = [NSArray arrayWithObjects: @"Space Baby", @"Space Cadet", @"Cosmonaut", @"Astronaut", @"Jedi", nil];
    
    currentUser = [PFUser currentUser];
    _username.text = currentUser[@"name"];
    int points = [(NSString *)currentUser[@"points"] intValue];
    int rankPos = (points/100)<ranks.count?(points/100):(int)ranks.count-1;
    _rankLabel.text = ranks[rankPos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Display a loader while uploading challenge
- (void) startLoader{
    hudProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudProgress];
    [hudProgress show:YES];
}

- (IBAction)pickImage:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *newImage = image;
        uploadImage = UIImagePNGRepresentation(newImage);
        _selectedImage.image = newImage;
    }];
}

- (IBAction)uploadChallenge:(id)sender {
    [self startLoader];
    if(uploadImage != nil && [_challengeTitle.text length] > 0) {
        PFObject *challenge = [PFObject objectWithClassName:@"Challenge"];
        challenge[@"image"] = [PFFile fileWithData:uploadImage];
        challenge[@"title"] = _challengeTitle.text;
        challenge[@"description"] = _challengeDescription.text;
        challenge[@"votes"] = @0;
        challenge[@"winner"] = @NO;
        [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hudProgress hide:YES];
            if(succeeded) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"It's on!" message:@"Your challenge was uploaded succesfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-oh" message:@"There was an error uploading yor challenge" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    } else {
        [hudProgress hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-oh" message:@"You must write a description and attach an image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
