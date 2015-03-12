//
//  ObjectLoader.m
//  Template1
//
//  Created by igor on 10/28/10.
//  (С) Impact Factors, LLC. All rights reserved.
//

#import "ObjectLoader.h"


@implementation ObjectLoader

@synthesize object;


+ (id)objectFromNibNamed:(NSString *)name
{
	ObjectLoader *loader = [ObjectLoader new];
	[[NSBundle mainBundle] loadNibNamed:name owner:loader options:nil];
	
	id obj = loader.object;	
	return obj;
}

@end

// zimin addition
@implementation UITableViewCell(NIBLoading) 

+(id)cellFromNib:(NSString *)nibName {
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
}

@end