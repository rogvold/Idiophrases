//
//  ObjectLoader.h
//  Template1
//
//  Created by igor on 10/28/10.
//  (С) Impact Factors, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ObjectLoader : NSObject 
{
	id object;
}

@property(retain) IBOutlet id object;

+(id)objectFromNibNamed:(NSString *)name;

@end

// zimin addition (use only with sole cell xibs)
@interface UITableViewCell(NIBLoading) 

+(id)cellFromNib:(NSString *)nibName;

@end