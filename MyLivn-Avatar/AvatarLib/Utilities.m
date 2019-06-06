//
//  Utilities.m
//  MyLivn-Avatar
//
//  Created by Mohamed Hassan on 6/6/19.
//  Copyright © 2019 MyLivn. All rights reserved.
//

#import "Utilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utilities

+ (NSString *)md5:(NSString *)string
{
  const char * pointer = [string UTF8String];
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
  
  NSMutableString *hashedString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [hashedString appendFormat:@"%02x",md5Buffer[i]];
  
  return hashedString;
}

@end
