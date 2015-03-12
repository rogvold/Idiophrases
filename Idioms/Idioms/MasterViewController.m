//
//  MasterViewController.m
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Idiom.h"
#import "IdiomCell.h"

@interface MasterViewController ()
{
    BOOL search;
}
@property (nonatomic, strong) NSMutableArray *idiomModels;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.detailViewController = (DetailViewController *)[sb instantiateViewControllerWithIdentifier:@"DetailView"];
    
    UIButton *settingsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 26, 26)];
    [settingsBtn setImage:[UIImage imageNamed:@"settings_ico"] forState:UIControlStateNormal];
    [settingsBtn addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self readJSON];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    {
        if (self.searchBar.text.length>0)
        {
            search = YES;
            [self searchBar:self.searchBar textDidChange:self.searchBar.text];
        }
    }
}

-(void)showSettings
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select language" message:@"" delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert setValue:[self customAlertView] forKey:@"accessoryView"];
    [alert show];
}

-(UIView*)customAlertView
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 220, 50)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 0.0, 30.0, 30.0)];
    [btn setImage:[UIImage imageNamed:@"radio_btn_unchecked"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"radio_btn_checked"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"radio_btn_checked"] forState:UIControlStateSelected];
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [btn addTarget:self action:@selector(selectLabguage:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if ([language isEqualToString:@"ru"])btn.selected = YES;
    
    [v addSubview:btn];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 170, 30.0)];
    lbl.text =@"Русский (Russian)";
    [v addSubview:lbl];
    return v;
}

-(void)selectLabguage:(UIButton*)btn
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if ([language isEqualToString:@"ru"])
    {
        btn.selected = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"language"];
    }
    else
    {
        btn.selected = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:@"language"];
    }
    [self.tableView reloadData];
}

- (void)readJSON
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"iosJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray *idiomsArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingMutableContainers
                                                            error:NULL];
    self.idiomModels = [[NSMutableArray alloc] init];
    for (NSDictionary* idiomDict in idiomsArray)
    {
        Idiom *idiom = [[Idiom alloc] initWithDictionary:idiomDict];
        [self.idiomModels addObject:idiom];
    }
    self.detailViewController.detailItem = [self.idiomModels firstObject];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//[[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:@"language"];

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  (search)?self.searchResults.count:self.idiomModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IdiomCell";
    Idiom *idiom =(search)?[self.searchResults objectAtIndex:indexPath.row]:[self.idiomModels objectAtIndex:indexPath.row];
    IdiomCell *itemCell = (IdiomCell *)[tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == itemCell)
    {
        itemCell = [IdiomCell cell];
        itemCell.delegate = self;
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        itemCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    itemCell.idiom = idiom;
    
    return itemCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Idiom *idiom =(search)?[self.searchResults objectAtIndex:indexPath.row]:[self.idiomModels objectAtIndex:indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *controller = [sb instantiateViewControllerWithIdentifier:@"DetailView"];
    controller.detailItem = idiom;
    controller.idiomsArray = (search)?[self.searchResults mutableCopy]:[self.idiomModels mutableCopy];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    search = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0)
    {
    if (!self.searchResults)self.searchResults = [[NSMutableArray alloc] init];
    [self.searchResults removeAllObjects];
    for (Idiom *ideom in self.idiomModels)
    {
        NSRange range = [[ideom.title lowercaseString] rangeOfString:[searchText lowercaseString]];
        if (range.location!=NSNotFound&&range.length==searchText.length)
        {
            [self.searchResults addObject:ideom];
        }
    }
    }
    else self.searchResults = [self.idiomModels mutableCopy];
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    search = NO;
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [self searchBarTextDidEndEditing:searchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}



@end
