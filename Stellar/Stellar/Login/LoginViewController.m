//
//  LoginViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Client.h"
#import "APIManager.h"
#import "UIImage+animatedGIF.h"


@interface LoginViewController ()

@end

@implementation LoginViewController{
    MBProgressHUD *hudProgressLogin;
    Client *client;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoader];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"gif"];
    _gif.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self loadFacebookData];
    }else{
        [hudProgressLogin hide:YES];
    }
}

- (void) loadFacebookData{
    NSLog(@"Load facebook data");
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            PFUser *currentUser = [PFUser currentUser];
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *email = userData[@"email"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *location = userData[@"location"][@"name"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSString *idUser  = currentUser.objectId;
            birthday = birthday? birthday:@"";
            currentUser[@"pictureUrl"] = pictureURL.absoluteString;
            currentUser[@"points"] = @0;
            currentUser[@"birthday"] = birthday? birthday:@"";
            currentUser[@"gender"] = gender ? gender:@"";
            currentUser[@"email"] = email;
            currentUser[@"name"] = name;
            currentUser[@"location"] = location ? location:@"";
            
            [currentUser saveInBackground];
            
            client = [[Client alloc]initClient:facebookID idUser:idUser name:name email:email birthday:birthday gender:gender pictureUrl:pictureURL];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSData* clientData = [NSKeyedArchiver archivedDataWithRootObject:client];
            [prefs setObject:clientData forKey:@"sessionKey"];
            [prefs synchronize];
            [[APIManager sharedManager] setSharedUser:client];
            [self showNewViewController];
        }
        [hudProgressLogin hide:YES];
    }];
}

-(void)startLoader{
    hudProgressLogin = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudProgressLogin];
    hudProgressLogin.delegate = self;
    [hudProgressLogin show:YES];
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    NSArray *permissionsArray = @[ @"user_about_me", @"user_birthday", @"user_location",@"email"];
    [self startLoader];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *userloaded, NSError *error) {
        NSLog(@"permissions granted::%@",FBSession.activeSession.permissions);
        
        [hudProgressLogin hide:YES];
        if (!userloaded) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (userloaded.isNew) {
            [self loadFacebookData];
        } else {
            [self loadFacebookData];
        }
    }];
    
}

-(void)showNewViewController{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
}

@end
