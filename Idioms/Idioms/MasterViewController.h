//
//  MasterViewController.h
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;


@end

