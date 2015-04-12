//
//  ChallengesViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "ChallengesViewController.h"
#import "ChallengeTableViewCell.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "VotingChallengeTableViewCell.h"
#import "CreateViewController.h"

@interface ChallengesViewController (){
    NSMutableArray *voteChallenges;
    NSMutableArray *winningChallenges;
    MBProgressHUD *hudProgress;
}

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
        voteChallenges = [[NSMutableArray alloc] init];
        winningChallenges = [[NSMutableArray alloc] init];
        [self fetchChallenges];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayCreateView)];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
    
    NSArray *barButtons = [NSArray arrayWithObjects:addBtn, searchBtn, nil];
    self.navigationItem.rightBarButtonItems = barButtons;
    
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

//Display create view modal
- (void) displayCreateView{
    CreateViewController *createView =[[CreateViewController alloc] init];
    createView.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createView];
    
    [self presentViewController:navController animated:YES completion:nil];
}

//Fetch all astronauts from Parse platform
- (void) fetchChallenges{
    [self startLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"Challenge"];
    [query orderByAscending:@"votes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if ([object[@"winner"] boolValue]) {
                    [winningChallenges addObject:object];
                }else{
                    [voteChallenges addObject:object];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [_voteChallengeListView reloadData];
                [_winnerChallengeListView reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [hudProgress hide:YES];
        }
    }];
}

//Display a loader while fetching items
- (void) startLoader{
    hudProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudProgress];
    [hudProgress show:YES];
}


#pragma mark - table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_winnerChallengeListView]) {
        return [winningChallenges count];
    } else {
        return [voteChallenges count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChallengeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeTableViewCell"];
    VotingChallengeTableViewCell *votingCell = [tableView dequeueReusableCellWithIdentifier:@"votingChallengeTableViewCell"];
    
    
    if (!cell) {
        if ([tableView isEqual:_voteChallengeListView]) {
            [tableView registerNib:[UINib nibWithNibName:@"VotingChallengeTableViewCell" bundle:nil] forCellReuseIdentifier:@"votingChallengeTableViewCell"];
            votingCell = [tableView dequeueReusableCellWithIdentifier:@"votingChallengeTableViewCell"];
        } else {
            [tableView registerNib:[UINib nibWithNibName:@"ChallengeTableViewCell" bundle:nil] forCellReuseIdentifier:@"challengeTableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"challengeTableViewCell"];
        }
    }
    [hudProgress hide:YES];
    if ([tableView isEqual:_voteChallengeListView]) {
        votingCell.titleLabel.text = voteChallenges[indexPath.row][@"title"];
        votingCell.descriptionTextView.text = voteChallenges[indexPath.row][@"description"];
        int votes = [voteChallenges[indexPath.row][@"votes"] intValue];
        votingCell.votesLabel.text = [NSString stringWithFormat:@"%d", votes];
        return votingCell;
    } else {
        cell.titleLabel.text = winningChallenges[indexPath.row][@"title"];
        cell.descriptionTextView.text = winningChallenges[indexPath.row][@"description"];
        int votes = [winningChallenges[indexPath.row][@"votes"] intValue];
        cell.votesLabel.text = [NSString stringWithFormat:@"%d votes", votes];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 167.0f;
}

@end
