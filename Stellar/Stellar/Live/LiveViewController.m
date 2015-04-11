//
//  LiveViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *streamingWebview;
@property (weak, nonatomic) IBOutlet UIView *galleryContainerView;
@property (weak, nonatomic) IBOutlet UIView *streamingContainerView;

@end

@implementation LiveViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Live", @"Live");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
- (IBAction)toggleViews:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [self.galleryContainerView setHidden:NO];
        [self.streamingContainerView setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [self.streamingContainerView setHidden:NO];
        [self.galleryContainerView setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* url = @"http://www.ustream.tv/embed/6540154?v=3&amp;wmode=direct";
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    self.streamingWebview.scalesPageToFit = YES;
    [self.streamingWebview loadRequest:request];

    self.streamingWebview.scalesPageToFit = YES;
    self.streamingWebview.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
