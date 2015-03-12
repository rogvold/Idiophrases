//
//  DetailViewController.h
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Idiom.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) Idiom *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITableView *idiomDescription;
@property (nonatomic, strong) NSMutableArray *idiomsArray;
@end

