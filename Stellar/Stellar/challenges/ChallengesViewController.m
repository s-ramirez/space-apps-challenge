//
//  ChallengesViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "ChallengesViewController.h"
#import "ChallengeTableViewCell.h"
#import "CreateViewController.h"

@interface ChallengesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *voteChallengeListView;
@property (strong, nonatomic) IBOutlet UITableView *winnerChallengeListView;
@end

@implementation ChallengesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Challenges", @"Challenges");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_voteChallengeListView setHidden:NO];
    [_winnerChallengeListView setHidden:YES];
}

- (IBAction)toggleViews:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            [_voteChallengeListView setHidden:NO];
            [_winnerChallengeListView setHidden:YES];
            break;
        case 1:
            [_voteChallengeListView setHidden:YES];
            [_winnerChallengeListView setHidden:NO];
            break;
    }
}

#pragma mark - table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_winnerChallengeListView]) {
        return 10;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChallengeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeTableViewCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChallengeTableViewCell" bundle:nil] forCellReuseIdentifier:@"challengeTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"challengeTableViewCell"];
    }
    
    if ([tableView isEqual:_voteChallengeListView]) {
       
    } else if ([tableView isEqual:_winnerChallengeListView]) {
       
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

//Creating a new challenge
- (void)add:(id)sender {
    CreateViewController *createController = [[CreateViewController alloc] init];
    createController.delegate = self;
}

@end
