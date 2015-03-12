//
//  BlogCell.h
//  Template1
//
//  Created by Igor Zaliskyj on 7/25/12.
//  (С) Impact Factors, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Idiom;

@interface IdiomCell : UITableViewCell

@property (nonatomic, retain) Idiom *idiom;
@property (nonatomic, assign) id delegate;

+ (IdiomCell *)cell;

@end
