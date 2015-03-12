//
//  ImageManager.h
//  Sarule AppComune
//
//  Created by Igor Zaliskyj on 11/20/14.
//  Copyright (c) 2014 Igor Zaliskyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageManager : NSObject
+ (void)getImageWithURL:(NSURL *)url delegate:(id)delegate completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
+(void)cancelALlRequests;
@end
