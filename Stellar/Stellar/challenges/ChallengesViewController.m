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
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChallengeTableViewCell" bundle:nil] forCellReuseIdentifier:@"challengeTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"challengeTableViewCell"];
    }
    
    if ([tableView isEqual:_voteChallengeListView]) {
        cell.titleLabel.text = voteChallenges[indexPath.row][@"title"];
        cell.descriptionTextView.text = voteChallenges[indexPath.row][@"description"];
        int votes = [voteChallenges[indexPath.row][@"votes"] intValue];
        cell.votesLabel.text = [NSString stringWithFormat:@"%d", votes];
    } else if ([tableView isEqual:_winnerChallengeListView]) {
        cell.titleLabel.text = winningChallenges[indexPath.row][@"title"];
        cell.descriptionTextView.text = winningChallenges[indexPath.row][@"description"];
        int votes = [winningChallenges[indexPath.row][@"votes"] intValue];
        cell.votesLabel.text = [NSString stringWithFormat:@"%d votes", votes];    }
    [hudProgress hide:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 149.0f;
}

@end
