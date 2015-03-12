//
//  DetailViewController.m
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    NSString *transcriptKey;
    NSString *meaningValue;
    UIBarButtonItem *nextBarItem;
    UIBarButtonItem *prevBarItem;
    UIView *exampleView;
}
@end

@implementation DetailViewController
@synthesize idiomDescription;

#pragma mark - Managing the detail item

- (void)setDetailItem:(Idiom*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self.idiomDescription reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.detailItem.title;
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 21, 21)];
    [nextBtn setImage:[UIImage imageNamed:@"next_ico"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(changeIdiom:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tag = 1;
    nextBarItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    UIButton *prevBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 21, 21)];
    [prevBtn setImage:[UIImage imageNamed:@"prev_ico"] forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(changeIdiom:) forControlEvents:UIControlEventTouchUpInside];
    prevBarItem = [[UIBarButtonItem alloc] initWithCustomView:prevBtn];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextBarItem,prevBarItem, nil];
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    transcriptKey =([lang isEqualToString:@"ru"])?@"ruTranscript":@"transcript";
    meaningValue = ([lang isEqualToString:@"ru"])?[NSString stringWithFormat:@"%@\n\n%@",self.detailItem.desc,self.detailItem.ruDesc]:self.detailItem.desc;
    self.idiomDescription.frame = CGRectMake(20.0, 0.0, [self getWidth], [UIScreen mainScreen].bounds.size.height);
    self.idiomDescription.center = CGPointMake(self.view.center.x, self.idiomDescription.center.y);
    [self performSelector:@selector(updatechangeIdiomButtons) withObject:nil afterDelay:0.1];
}

-(void)updatechangeIdiomButtons
{
    NSInteger currentIndex = [self.idiomsArray indexOfObject:self.detailItem];
    nextBarItem.enabled = (self.idiomsArray.count>currentIndex+1)?YES:NO;
    prevBarItem.enabled = (currentIndex>0)?YES:NO;
}

-(void)changeIdiom:(UIButton*)btn
{
    NSInteger currentIndex = [self.idiomsArray indexOfObject:self.detailItem];
    if (btn.tag==1)
    {
        currentIndex = currentIndex+1;
        prevBarItem.enabled = YES;
        nextBarItem.enabled = (self.idiomsArray.count>currentIndex+1)?YES:NO;
    }
    else
    {
        currentIndex = currentIndex-1;
        nextBarItem.enabled = YES;
        prevBarItem.enabled = (currentIndex-1>0)?YES:NO;
    }
    
    if (exampleView.superview!=nil)
    {
        [exampleView removeFromSuperview];
        exampleView = nil;
    }
    [self.idiomDescription setContentOffset:CGPointMake(0.0, -64.0) animated:NO];
    self.detailItem = [self.idiomsArray objectAtIndex:currentIndex];
    self.title = self.detailItem.title;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row%2==0)?30.0:[self heightForRowAtIndexPath:indexPath];
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self textForRowAtIndexPath:indexPath];
    
    
    CGRect r = [text boundingRectWithSize:CGSizeMake([self getWidth], 0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:16]}
                                  context:nil];
    
    return (indexPath.row==5)?[self exampleViewHeight]:r.size.height+20;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0)cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    else cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = (indexPath.row==0)?@"Idiom":(indexPath.row==2)?@"Meaning":(indexPath.row==4)?@"Examples":[self textForRowAtIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    if (indexPath.row==5)
    {
        exampleView = [self generateExampleView];
        [cell.contentView addSubview:exampleView];
    }
    return cell;
}

-(NSString*)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==1)?self.detailItem.title:(indexPath.row==3)?meaningValue:@"";
}

-(CGFloat)getWidth
{
    CGFloat vw = ([UIScreen mainScreen].bounds.size.height==667)?355:([UIScreen mainScreen].bounds.size.height==736)?374:([UIScreen mainScreen].bounds.size.height==1024)?728:280;
    return vw;
}

-(UIView*)generateExampleView
{
    CGFloat iframeWidth = [self getWidth]-20;
    CGFloat offsetY = 0.0;
    exampleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self getWidth], [self exampleViewHeight])];
    for (NSInteger i=0; i<self.detailItem.idioms.count; i++)
    {
        NSDictionary *example =[self.detailItem.idioms objectAtIndex:i];
        
        NSString *embedHTML = [NSString stringWithFormat:@"<iframe src=\"https://player.vimeo.com/video/%@?title=0&byline=0&portrait=0\" width=\"%f\" height=\"%f\"></iframe>",[example objectForKey:@"vimeoId"],iframeWidth,0.88*iframeWidth];
        
        UIWebView *wV = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, offsetY, [self getWidth], 0.88*iframeWidth)];
        wV.delegate = self;
        wV.tag = i;
        [wV loadHTMLString:embedHTML baseURL:nil];
        wV.scrollView.scrollEnabled = NO;
        [exampleView addSubview:wV];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = wV.center;
        indicator.tag = i;
        [wV addSubview:indicator];
        [indicator startAnimating];
        
        offsetY = offsetY + 0.88*iframeWidth;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, offsetY, [self getWidth], [self textHeight:[self transcriptTextForExample:example]])];
        lbl.text = [self transcriptTextForExample:example];
        lbl.numberOfLines = 0.0;
        lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        [exampleView addSubview:lbl];
        
        offsetY = offsetY + lbl.frame.size.height;
    }
    return exampleView;
}

-(NSString *)transcriptTextForExample:(NSDictionary*)example
{
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *transcriptTetx =([lang isEqualToString:@"ru"])?[NSString stringWithFormat:@"%@\n\n%@",[example objectForKey:@"transcript"],[example objectForKey:@"ruTranscript"]]:[example objectForKey:@"transcript"];
    return transcriptTetx;
}

-(CGFloat)textHeight:(NSString*)text
{
    CGRect r = [text boundingRectWithSize:CGSizeMake([self getWidth], 0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:16]}
                                  context:nil];
    return r.size.height+30;
}


-(CGFloat)exampleViewHeight
{
    CGFloat iframeWidth = [self getWidth]-20;
    CGFloat h = 0.0;
    for (NSInteger i=0; i<self.detailItem.idioms.count; i++)
    {
        NSDictionary *example =[self.detailItem.idioms objectAtIndex:i];
        h = h + 0.88*iframeWidth+[self textHeight:[self transcriptTextForExample:example]];
    }
    return h;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    for (id subview in webView.subviews)
    {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]])
        {
            [(UIActivityIndicatorView*) subview stopAnimating];
        }
    }
}



@end
