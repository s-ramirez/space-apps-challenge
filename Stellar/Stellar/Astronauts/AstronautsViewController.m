//
//  AstronautsViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "AstronautsViewController.h"
#import "AstronautsTableViewCell.h"

@interface AstronautsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *astronautsTableView;

@end

@implementation AstronautsViewController {
    NSMutableArray *astronauts;
    MBProgressHUD *hudProgress;
}

@synthesize tableView = _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        astronauts = [[NSMutableArray alloc] init];
        [self fetchAstronauts];
        self.title = NSLocalizedString(@"Astronauts", @"Astronauts");
        self.tabBarItem.image = [UIImage imageNamed:@"astronauts"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.astronautsTableView.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);
    self.astronautsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [astronauts count];    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AstronautsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"astronautsTableViewCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AstronautsTableViewCell" bundle:nil] forCellReuseIdentifier:@"astronautsTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"astronautsTableViewCell"];
    }
    
    if([astronauts count] > 0) {
        PFObject *astronaut = [astronauts objectAtIndex:indexPath.section];
        cell.title.text = astronaut[@"name"];
        cell.subLabel.text = astronaut[@"bio"];
        cell.astronautId = astronaut[@"objectId"];
        cell.mainImage.layer.cornerRadius = 53;//Half of the height
        cell.mainImage.layer.masksToBounds = YES;
        cell.mainImage.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *imageUrl = astronaut[@"pictureUrl"];
        
        if(imageUrl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                cell.mainImage.image = [UIImage imageWithData:imageData];
                [hudProgress hide:YES];
            });
        }
        
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116.0f;
}

//Fetch all astronauts from Parse platform
- (void) fetchAstronauts{
    [self startLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"Astronaut"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [astronauts addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
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

@end
