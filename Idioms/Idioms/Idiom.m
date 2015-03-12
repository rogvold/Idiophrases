//
//  Idiom.m
//  Idioms
//
//  Created by Igor Zaliskyj on 3/11/15.
//  Copyright (c) 2015 Igor Zaliskyj. All rights reserved.
//

#import "Idiom.h"
#import "ImageManager.h"

@implementation Idiom
- (id)initWithDictionary:(NSDictionary *)aDict
{
    self = [super init];
    if (nil != self)
    {
        self.title = [aDict objectForKey:@"title"];
        self.desc = [aDict objectForKey:@"description"];
        self.ruDesc = [aDict objectForKey:@"ruDescription"];
        self.count = [[aDict objectForKey:@"idioms"] count];
        self.previewUrl = [[[aDict objectForKey:@"idioms"] firstObject] objectForKey:@"imgSrc"];
        self.idioms = [aDict objectForKey:@"idioms"];
        
        if (nil == self.preview && self.previewUrl!=nil)
        {
            [ImageManager getImageWithURL:[NSURL URLWithString:self.previewUrl]
                                 delegate:self
                          completionBlock:^(BOOL succeeded, UIImage *image) {
                             if (succeeded)
                             {
                                 self.preview = image;
                                 [self notifyReloadCellWithModel];
                             }
                          }];
        }
    }
    return self;
}

- (void)notifyReloadCellWithModel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PreviewDidLoadNotification"
                                                        object:nil userInfo:nil];
}

@end
