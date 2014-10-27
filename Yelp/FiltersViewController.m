//
//  FiltersViewController.m
//  Yelp
//
//  Created by Vinit Patwa on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *filtersView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;


-(void)initCategories;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibBundleOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleBordered target:self action:@selector(onApplyButton)];
    
    self.title = @"Filters";
    self.filtersView.delegate = self;
    self.filtersView.dataSource = self;
    
    [self.filtersView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Switch cell delegate methods

-(NSDictionary *) filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if(self.selectedCategories.count > 0){
    NSMutableArray  *names = [NSMutableArray array];
    for(NSDictionary *category in self.selectedCategories){
        [names addObject:category[@"code"]];
    }
    NSString *categoryFilter = [names componentsJoinedByString:@","];
    [filters setObject:categoryFilter forKey:@"category_filter"];
  }
    return filters;
}

-(void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.filtersView indexPathForCell:cell];
    
    if(value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
        
    }
    
}

#pragma mark - Private methods

- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self.delegate FiltersViewController:self didchangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initCategories {
    self.categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                        @{@"name" : @"African", @"code": @"african" },
                        @{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Burgers", @"code": @"burgers" },
                        @{@"name" : @"Burmese", @"code": @"burmese" },
                        @{@"name" : @"Chinese", @"code": @"chinese" },
                        @{@"name" : @"Diners", @"code": @"diners" },
                        @{@"name" : @"Dumplings", @"code": @"dumplings" },
                        @{@"name" : @"Indian", @"code": @"indpak" },
                        @{@"name" : @"Malaysian", @"code": @"malaysian" },
                        @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
                        @{@"name" : @"Mexican", @"code": @"mexican" },
                        @{@"name" : @"Salad", @"code": @"salad" },
                        @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
                        @{@"name" : @"Seafood", @"code": @"seafood" },
                        @{@"name" : @"Spanish", @"code": @"spanish" },
                        @{@"name" : @"Steakhouses", @"code": @"steak" },
                        @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                        @{@"name" : @"Swedish", @"code": @"swedish" },
                        @{@"name" : @"Swiss Food", @"code": @"swissfood" },
                        @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                        @{@"name" : @"Tapas Bars", @"code": @"tapas" },
                        @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
                        @{@"name" : @"Thai", @"code": @"thai" },
                        @{@"name" : @"Vegan", @"code": @"vegan" },
                        @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                        @{@"name" : @"Vietnamese", @"code": @"vietnamese" }];
}

@end
