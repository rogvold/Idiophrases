//
//  BlogCell.m
//  Template1
//
//  Created by Igor Zaliskyj on 7/25/12.
//  (С) Impact Factors, LLC. All rights reserved.
//

#import "IdiomCell.h"
#import "ObjectLoader.h"
#import "Idiom.h"

@interface IdiomCell ()

@property (nonatomic, strong) IBOutlet UILabel	*titleLabel;
@property (nonatomic, strong) IBOutlet UILabel	*descrLabel;
@property (nonatomic, strong) IBOutlet UIImageView	*previewView;
@property (nonatomic, strong) IBOutlet UILabel	*countLabel;

@end

@implementation IdiomCell

+ (IdiomCell *)cell
{
	IdiomCell *cell = [ObjectLoader objectFromNibNamed:@"IdiomCell"];
	return cell;
}


- (void)setIdiom:(Idiom *)aidiom
{
	if (aidiom != _idiom)
	{
        _idiom = aidiom;
	}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImage) name:@"PreviewDidLoadNotification" object:nil];
	if (aidiom != nil)
	{
        self.titleLabel.text = aidiom.title;
        NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
        self.descrLabel.text = ([lang isEqualToString:@"ru"])?[NSString stringWithFormat:@"%@\n%@",aidiom.desc,aidiom.ruDesc]:aidiom.desc;
        self.previewView.image = aidiom.preview;
        self.countLabel.text = [NSString stringWithFormat:@"%li",(long)aidiom.count];
	}
}

-(void)reloadImage
{
    if (self.idiom.preview)self.previewView.image = self.idiom.preview;
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PreviewDidLoadNotification" object:nil];
}

@end
