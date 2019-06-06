//
//  MyLivnCachManager.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/4/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "MyLivnCachManager.h"
#import "Utilities.h"

#define CACH_PATH @"/cach"

@implementation MyLivnCachManager

+ (instancetype)sharedInstance
{
  static MyLivnCachManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MyLivnCachManager alloc] init];
  });
  return sharedInstance;
}

- (NSString *)cachFolderPath
{
  NSError *error;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths.firstObject;
  NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:CACH_PATH];
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
   [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
  }
  return dataPath;
}

- (void)cachData:(NSData *)data forURL:(NSString *)url
{
  if ([self savingConstraintsReachedByAddingData:data]) {
    return;
  }
  
  [[NSFileManager defaultManager] createFileAtPath:[self.cachFolderPath stringByAppendingPathComponent:[self cachedFileNameForUrl:url]]
                                          contents:data
                                        attributes:nil];
}

- (NSString *)cachedFileNameForUrl:(NSString *)urlString
{
  NSString *ext = [NSURL URLWithString:urlString].pathExtension;
  NSString *fileName = [Utilities md5:urlString];
  return [fileName stringByAppendingString:[NSString stringWithFormat:@".%@",ext]];
}

- (NSArray *)cachedFiles
{
  NSError *error;
  return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cachFolderPath error:&error];
}

- (BOOL)savingConstraintsReachedByAddingData:(NSData *)data
{
  NSArray *cachedFiles = self.cachedFiles;
  if(self.maximumNumberOfObjects && cachedFiles.count >= self.maximumNumberOfObjects.integerValue) {
    return YES;
  }
  
  //Total size of savedFiles
  long totalSize = 0;
  for(NSString *fileName in cachedFiles)
  {
    NSString *filePath = [self.cachFolderPath stringByAppendingPathComponent:fileName];
    totalSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
  }
  totalSize += data.length;
  if (self.maximumStorageSpace && totalSize >= self.maximumStorageSpace.longValue) {
    return YES;
  }
  return NO;
}

- (NSData *)cachedDataForUrl:(NSString *)url
{
  NSData* data;
  NSString *fileName = [self cachedFileNameForUrl:url];
  NSString *fullPath = [self.cachFolderPath stringByAppendingPathComponent:fileName];
  if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
    NSError* error = nil;
    data = [NSData dataWithContentsOfFile:fullPath  options:0 error:&error];
  }
  return data;
}

@end
