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

@implementation AstronautsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Astronauts", @"Astronauts");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.astronautsTableView.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 10;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AstronautsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"astronautsTableViewCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AstronautsTableViewCell" bundle:nil] forCellReuseIdentifier:@"astronautsTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"astronautsTableViewCell"];
    }
    
//TODO: SETUP UI
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0f;
}

@end
