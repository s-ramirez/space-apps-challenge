//
//  ProfileViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "ProfileViewController.h"
#import "CircleProgressBar.h"
#import "APIManager.h"
#import "Client.h"
#import <Parse/Parse.h>

@interface ProfileViewController (){
    int currentProgress;
    PFObject *currentUser;
    BOOL loaded;
}

@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *badgesScrollview;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Profile", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [_circleProgressBar setProgress:0.0 animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if(loaded){
        [_circleProgressBar setProgress:0.57 animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _profileImageView.layer.cornerRadius = 106;//Half of the height
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_circleProgressBar setStartAngle:270];
    
    NSArray *ranks = [NSArray arrayWithObjects: @"Space Baby", @"Space Cadet", @"Cosmonaut", @"Astronaut", @"Jedi", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PFUser currentUser] refreshInBackgroundWithBlock:
         ^(PFObject *object, NSError *error){
             currentUser = [PFUser currentUser];
             _usernameLabel.text = currentUser[@"name"];
             int points = [(NSString *)currentUser[@"points"] intValue];
             int rankPos = (points/100)<ranks.count?(points/100):(int)ranks.count-1;
             _rankLabel.text = ranks[rankPos];
             _pointsLabel.text = [NSString stringWithFormat:@"%d", points];
             if(!loaded){
                 [_circleProgressBar setProgress:0.57 animated:YES];
                 loaded = YES;
             }
             NSString *imageUrl = currentUser[@"pictureUrl"];
             if (imageUrl) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                     
                     _profileImageView.image = [UIImage imageWithData:imageData];
                 });
             }

         }];
        
    });

    
   
    
    NSArray *images = [NSArray arrayWithObjects: @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", @"trophy_placeholder", nil];
    [self loadImagesScrollView:images];
    _badgesScrollview.showsHorizontalScrollIndicator = false;
}



#pragma mark Swipe
- (void)settingSwipe
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
//    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
//    swipeRight.delegate = self;
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self.tabBarController setSelectedIndex:1];
    }
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        //[self.tabBarController setSelectedIndex:0];
    }
}

-(void)loadImagesScrollView:(NSArray*) arrayImages{
    
    [self settingSwipe];

    //    if (arrayImages.count == 0) {
//        [hudProgress hide:YES];
//    }
//

    float customWidth = _badgesScrollview.bounds.size.height;
    for (int i = 0; i < arrayImages.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*customWidth+(10 * i - 1), 0, customWidth, _badgesScrollview.bounds.size.height)];
        
        [_badgesScrollview setCanCancelContentTouches:YES];
        [imageView setUserInteractionEnabled:YES];
        
        NSString *imageName = [arrayImages objectAtIndex:i];
        if (imageName) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageNamed:imageName];
                [_badgesScrollview addSubview:imageView];
                _badgesScrollview.contentSize = CGSizeMake(arrayImages.count*customWidth+(10 * i - 1), _badgesScrollview.bounds.size.height);
                if (i == arrayImages.count - 1) {
//                    [hudProgress hide:YES];
                }
            });
        }
    }
    [_badgesScrollview setContentInset:UIEdgeInsetsMake(0, 40, 0, 40)];
}


@end
