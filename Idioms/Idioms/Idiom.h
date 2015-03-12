//
//  Idiom.h
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Idiom : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ruDesc;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *previewUrl;
@property (nonatomic, strong) UIImage *preview;
@property (nonatomic, strong) NSArray *idioms;

- (id)initWithDictionary:(NSDictionary *)aDict;
@end
