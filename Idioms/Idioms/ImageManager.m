//
//  ImageManager.m
//  Sarule AppComune
//
//  Created by Igor Zaliskyj on 11/20/14.
//  Copyright (c) 2014 Igor Zaliskyj. All rights reserved.
//


#import "ImageManager.h"

static NSString *imageDirectoryPath = nil;

@implementation ImageManager


+ (void)getImageWithURL:(NSURL *)url delegate:(id)delegate completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    [self createImageDirectoryPath];
    NSString *imageNamePath = [[url absoluteString] lastPathComponent];
    NSString *imageDevicePath =  [imageDirectoryPath stringByAppendingPathComponent:imageNamePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:imageDevicePath];
    if (success)
    {
        completionBlock (YES, [UIImage imageWithContentsOfFile:imageDevicePath]);
    }
    else
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (delegate!=nil)
                                   {
                                       if ( !error )
                                       {
                                           [self writeData:data atPath:imageDevicePath];
                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                           completionBlock(YES,image);
                                           
                                       } else{
                                           completionBlock(NO,nil);
                                       }
                                   }
                               }];
    }
}

+(void)cancelALlRequests
{
    [[NSOperationQueue mainQueue] cancelAllOperations];
}


+ (BOOL)writeData:(NSData *)data atPath:(NSString *)writePath
{
    BOOL success = [data writeToFile:writePath atomically:NO];
    return success;
}

+ (void)createImageDirectoryPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    imageDirectoryPath = [[path objectAtIndex:0] stringByAppendingPathComponent:@"previews"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    NSError *error = nil;
    
    BOOL folderExists = ([fileManager fileExistsAtPath:imageDirectoryPath
                                           isDirectory:&isDirectory] && isDirectory);
    
    if (NO == folderExists)
    {
        BOOL isCreated = [fileManager createDirectoryAtPath:imageDirectoryPath
                                withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (!isCreated)
        {
            NSLog(@"Failed to create folder \"%@\", reason - %@", imageDirectoryPath,
                 [error localizedDescription]);
        }
    }
}

@end
