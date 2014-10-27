//
//  FiltersViewController.m
//  Yelp
//
//  Created by Vinit Patwa on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "SortCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *filtersView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@property (nonatomic, strong) NSMutableSet *selectedRadius;
@property (nonatomic, strong) NSArray *radiusItems;




-(void)initCategories;

@end

@implementation FiltersViewController

BOOL radiusSelected = NO;
BOOL offeringDeals;
SortCell *sortCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibBundleOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
                self.selectedRadius = [NSMutableSet set];
        [self initCategories];
        [self initRadiusItems];
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
    [self.filtersView registerNib:[UINib nibWithNibName:@"SortCell" bundle:nil] forCellReuseIdentifier:@"SortCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.categories count];
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
        case 3:
            return (radiusSelected ? 3:1);
        default:
            break;
    }
    
    
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            cell.delegate = self;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SortCell"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            cell.titleLabel.text = @"Offering a Deal";
            cell.on = false;
            cell.delegate = self;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            cell.titleLabel.text = self.radiusItems[indexPath.row];
            cell.on = false;
            NSLog(@"AAA:%@", self.radiusItems[indexPath.row]);
            cell.delegate = self;
            break;
        default:
            break;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Categories";
            break;
        case 1:
            return @"Sort";
            break;
        case 2:
            return @"Deals";
            break;
        case 3:
            return @"Distance";
            break;
        default:
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 3){
        
        NSLog(@"value:%lu", indexPath.row);
        radiusSelected = !radiusSelected;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:3];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:3];
        if(radiusSelected){
            [tableView insertRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
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
    if(offeringDeals){
        [filters setValue:(offeringDeals? @"true":@"false") forKey:@"deals_filter"];
    }
    NSLog(@"1Q:%lu",[self.selectedRadius count] );
    
    if([self.selectedRadius count] > 0){
        int *radius;
        if([self.selectedRadius count] == 2 ){
            radius = 8000;
        } else {
            radius = 1609;
        }
        [filters setValue:[NSString stringWithFormat:@"%i", radius] forKey:@"radius_filter"];
        NSLog(@"QQ:%@",self.selectedRadius );
        
        
    }
    

    
    return filters;
}

-(void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.filtersView indexPathForCell:cell];
    NSLog(@"ZZ %lu", indexPath.section);
    
    switch (indexPath.section) {
        case 0:
            if(value) {
                [self.selectedCategories addObject:self.categories[indexPath.row]];
            } else {
                [self.selectedCategories removeObject:self.categories[indexPath.row]];
            }
            break;
        case 1:
            break;
        case 2:
            offeringDeals = value;
            break;
        case 3:
            switch (indexPath.row) {
                case 1:
                case 2:
                    NSLog(@"in Here%lu", indexPath.row);
                    if(value){
                    [self.selectedRadius addObject:self.radiusItems[indexPath.row]];
                    } else  {
                    [self.selectedRadius removeObject:self.radiusItems[indexPath.row]];
                    }
                    NSLog(@"0Q:%lu",[self.selectedRadius count] );
                    
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
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

-(void)initRadiusItems {
    self.radiusItems = @[@"Auto", @"1 Mile", @"5 Miles"];
}


-(void)initCategories {
    self.categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                        @{@"name" : @"African", @"code": @"african" },
                        @{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"Burgers", @"code": @"burgers" },
                        @{@"name" : @"Burmese", @"code": @"burmese" },
                        @{@"name" : @"Chinese", @"code": @"chinese" },
                        @{@"name" : @"Dumplings", @"code": @"dumplings" },
                        @{@"name" : @"Vietnamese", @"code": @"vietnamese" }];
}

@end
