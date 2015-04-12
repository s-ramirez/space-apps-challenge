//
//  LiveViewController.m
//  Stellar
//
//  Created by Kai on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "LiveViewController.h"
#import "SVPullToRefresh.h"
#import "GLGooglePlusLikeLayout.h"
#import "UIImageView+WebCache.h"
#import "GLSectionView.h"
#import "GLCell.h"
#import "FlickrRequest.h"

#define DATA_TO_ADD 40
#define SECTION_IDENTIFIER @"section"
#define CELL_IDENTIFIER @"cell"

@interface LiveViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, FlickerRequestDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray* arrayImageSize;
@property (nonatomic, strong) NSMutableArray* arrayUrlImages;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *galleryContainerView;
@property (weak, nonatomic) IBOutlet UIView *stationContainerView;
@property (weak, nonatomic) IBOutlet UIView *streamingContainerView;

@property (weak, nonatomic) IBOutlet UIWebView *streamingWebview;
@property (weak, nonatomic) IBOutlet UIWebView *stationWebView;


@property int countLoaded;

@end

@implementation LiveViewController {
    FlickrRequest *flickrRequest;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Live", @"Live");
        self.tabBarItem.image = [UIImage imageNamed:@"liveOnSpace"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flickrRequest = [[FlickrRequest alloc]init];
    flickrRequest.delegate = self;
    [flickrRequest createRequest];
    
    _arrayUrlImages = [[NSMutableArray alloc]init];
    _arrayImageSize = [[NSMutableArray alloc]init];
    
    _stationWebView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    NSString* url = @"http://www.ustream.tv/embed/6540154?v=3&amp;wmode=direct";
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.streamingWebview loadRequest:request];
    
    
    
    NSString* urlStation = @"http://app.friendsinspace.org/";
    NSURL* nsUrlStation = [NSURL URLWithString:urlStation];
    NSURLRequest* requestStation = [NSURLRequest requestWithURL:nsUrlStation cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    
    [self.stationWebView loadRequest:requestStation];
    
    [self.containerView addSubview:self.galleryContainerView];
    [self.containerView addSubview:self.stationContainerView];
    [self.containerView addSubview:self.streamingWebview];

    
    self.galleryContainerView.hidden = NO;
    self.stationContainerView.hidden = YES;
    self.streamingWebview.hidden = YES;
    
    // configure views
    GLGooglePlusLikeLayout *layout = (GLGooglePlusLikeLayout *)[self.collectionView collectionViewLayout];
    [layout setHasHeaders:NO];
    
    [self.collectionView registerClass:[GLSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_IDENTIFIER];
    [self.collectionView registerClass:[GLCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.dataSource removeAllObjects];
    self.dataSource = nil;
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleViews:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        self.galleryContainerView.hidden = NO;
        self.stationContainerView.hidden = YES;
        self.streamingWebview.hidden = YES;
    }
    else if (selectedSegment == 1) {
        //toggle the correct view to be visible
        self.galleryContainerView.hidden = YES;
        self.stationContainerView.hidden = NO;
        self.streamingWebview.hidden = YES;
    } else {
        self.galleryContainerView.hidden = YES;
        self.stationContainerView.hidden = YES;
        self.streamingWebview.hidden = NO;
    }
}

- (void)loadView
{
    [super loadView];
    [self.galleryContainerView addSubview:self.collectionView];
}

#pragma mark -
#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        GLGooglePlusLikeLayout* layout = [[GLGooglePlusLikeLayout alloc] init];
        CGFloat width = floorf((CGRectGetWidth(self.view.bounds) / 2));
        layout.minimumItemSize = CGSizeMake(width, width);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.containerView.bounds collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
//        _collectionView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)updateLayout
{
    GLGooglePlusLikeLayout *layout = (GLGooglePlusLikeLayout *)[self.collectionView collectionViewLayout];
    CGFloat width = floorf((CGRectGetWidth(self.containerView.bounds) / 2));
    layout.minimumItemSize = CGSizeMake(width, width);
}

- (CGSize)randomSize
{
    CGFloat width = (CGFloat) (arc4random() % (int) self.view.bounds.size.width * 0.7);
    CGFloat heigth = (CGFloat) (arc4random() % (int) self.view.bounds.size.height * 0.7);
    CGSize randomSize = CGSizeMake(width, heigth);
    return randomSize;
}

-(void)configurePullToRefresh {
    __weak LiveViewController *weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:DATA_TO_ADD];
        
        for (int i = 0; i < DATA_TO_ADD; i++) {
            [tmp addObject:[NSValue valueWithCGSize:[weakSelf randomSize]]];
            //[tmp addObject:weakSelf.arrayImageSize[i]];
        }
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:tmp];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    // setup infinite scrolling
    [self.collectionView addInfiniteScrollingWithActionHandler:^{

        NSUInteger dataSourceCount = weakSelf.dataSource.count;
        NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:DATA_TO_ADD];
        NSMutableArray* indexPaths = [[NSMutableArray alloc] initWithCapacity:DATA_TO_ADD];
        
        int itemsToLoad = 0;
        int pagination = weakSelf.countLoaded * DATA_TO_ADD;
        if (weakSelf.countLoaded == -1) {
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
            return;
        }
        if (pagination < weakSelf.arrayUrlImages.count) {
            weakSelf.countLoaded++;
            itemsToLoad = DATA_TO_ADD;
        } else {
            itemsToLoad = pagination - (int)weakSelf.arrayUrlImages.count;
            weakSelf.countLoaded = -1;
        }
        
        for (int i = 0; i < itemsToLoad; i++) {
            [tmp addObject:weakSelf.arrayImageSize[i]];
            [indexPaths addObject:[NSIndexPath indexPathForItem:(dataSourceCount + i) inSection:0]];
        }

        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.dataSource addObjectsFromArray:tmp];
            [weakSelf.collectionView performBatchUpdates:^{
            [weakSelf.collectionView insertItemsAtIndexPaths:(NSArray*)indexPaths];
                
            } completion:nil];
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        });
    }];
}

#pragma mark - UICollectionView Stuff

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout heightForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath; {
    return 30;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLCell *cell = (GLCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    if ([_arrayUrlImages objectAtIndex:indexPath.row] != nil) {
        NSString *imageUrl = [_arrayUrlImages objectAtIndex:indexPath.row];
        if (imageUrl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.displayPhoto sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_bg" ]];
                CGSize size = CGSizeMake(cell.displayPhoto.frame.size.width, cell.displayPhoto.frame.size.height);
                [_arrayImageSize addObject:[NSValue valueWithCGSize:size]];
            });
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    
    if (indexPath.item <= (self.dataSource.count - 1)) {
        NSValue *sizeValue = self.dataSource[indexPath.item];
        size = [sizeValue CGSizeValue];
        return size;
    }
    return size;
}



#pragma mark -
#pragma mark - Private methods
- (void)commonInit {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSMutableArray*)finishDownloadImages {
    _arrayUrlImages = flickrRequest.arrayUrlImages;
    [self.collectionView reloadData];
    [self configurePullToRefresh];
    [self.collectionView triggerPullToRefresh];
    _countLoaded = 2;
    return _arrayUrlImages;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *script = @"document.getElementsByClassName(\"fis-login-modal-bg\")[0].style.display = 'none';";
    NSString *script2 = @"document.getElementsByClassName(\"sam-actions\")[0].style.display = 'none';";
    NSString *script3 = @"document.getElementsByClassName(\"fis-user-profile\")[0].style.display = 'none';";
    NSString *script4 = @"document.getElementsByClassName(\"view-container bottom\")[0].style.display = 'none';";
    NSString *script5 = @"document.getElementsByClassName(\"fis-background-controls\")[0].style.display = 'none';";
    NSString *script6 = @"document.getElementsByClassName(\"view-container top\")[0].style.display = 'none';";
    NSString *script7 = @"document.getElementsByClassName(\"fis-logo\")[0].style.display = 'none';";
    NSString *script8 = @"document.getElementById(\"fis-show-map\").click();";
    NSString *script9 = @"document.getElementsByClassName(\"fis-online-map-controls\")[0].style.display = 'none';";
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script2];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script3];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script4];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script5];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script6];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script7];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script8];
    [self.stationWebView stringByEvaluatingJavaScriptFromString:script9];
}

@end
