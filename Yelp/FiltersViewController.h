//
//  FiltersViewController.h
//  Yelp
//
//  Created by Vinit Patwa on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void) FiltersViewController:(FiltersViewController *)
FiltersViewController didchangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController
@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
