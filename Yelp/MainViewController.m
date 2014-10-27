//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"J7lqskc8K45XD2u9S4fuwQ";
NSString * const kYelpConsumerSecret = @"y85XTPBd2kx7vl0rbR3EpUXBIhw";
NSString * const kYelpToken = @"eQQdraxsgYEsFkKyKQONF0HBzUBpmNKf";
NSString * const kYelpTokenSecret = @"EUfSvjmbgZInhiZCSjQ1D3gpUJA";

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *businesses;


@property (nonatomic, strong) YelpClient *client;

-(void) fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 120;
    UINib *businessCellNib = [UINib nibWithNibName:@"BusinessCell" bundle:nil];
    [self.tableView registerNib:businessCellNib forCellReuseIdentifier:@"BusinessCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterButton)];
 
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [searchBar setDelegate:self];
    [[self navigationItem] setTitleView:searchBar];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    NSDictionary *current_item = self.businesses[indexPath.row];
    cell.name.text = current_item[@"name"];
    
    NSString *itemIconUrl = current_item[@"image_url"];
    [cell.business_image setImageWithURL:[NSURL URLWithString:itemIconUrl]];
    
    float dist = [current_item[@"distance"] floatValue];
    cell.distance.text = [NSString stringWithFormat:@"%0.2f mi", dist/1609];
    //cell.dollar = current_item[@"display_address"];
    cell.reviews.text = [NSString stringWithFormat:@"%@ %@", current_item[@"review_count"], @"reviews"];
    NSString *address = [NSString stringWithFormat:@"%@ %@", current_item[@"location"][@"display_address"][0], current_item[@"location"][@"city"]];
    cell.address.text = address;
    
    NSArray *categories = current_item[@"categories"];
    cell.cuisine.text = @"";
    for (int i = 0; i < [categories count]; i++) {
        if (i != 0) cell.cuisine.text = [cell.cuisine.text stringByAppendingString:@", "];
        cell.cuisine.text = [cell.cuisine.text stringByAppendingString:categories[i][0]];
    }
    
//    cell.cuisine.text = current_item[@"name"];
    NSString *ratingIconUrl = current_item[@"rating_img_url_small"];
   [cell.ratings_image setImageWithURL:[NSURL URLWithString:ratingIconUrl]];
    
    
    
//    NSLog(@"name: %lu",(unsigned long)[current_item[@"categories"] count]);
//    NSLog(@"name: %@",current_item[@"categories"][0][0]);
//    cell.movieDescription.text = self.movies[indexPath.row][@"synopsis"];
//    NSString *urlString = self.movies[indexPath.row][@"posters"][@"profile"];
//    NSURL *url = [NSURL URLWithString:urlString];
//    [cell.poster setImageWithURL:url];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Searchbar methods
- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar {
    NSLog(@"searchBarTextDidEndEditing");
   
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"The search text is: %@", searchText);
    [self fetchBusinessesWithQuery:searchText params:nil];
}

#pragma mark - FiltersViewControllerDelegate methods
-(void) FiltersViewController:(FiltersViewController *)FiltersViewController didchangeFilters:(NSDictionary *)filters{
    NSLog(@"do a network call:%@", filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

#pragma mark - Private methods
- (void)onFilterButton
{
    NSLog(@"filter button clicked");
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
    nvc.navigationBar.barTintColor = [UIColor redColor];
}

-(void) fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params{
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //            NSLog(@"response: %@", response[@"businesses"]);
        self.businesses = response[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}
@end
