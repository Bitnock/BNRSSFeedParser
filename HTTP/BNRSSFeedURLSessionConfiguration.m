//
//  BNRSSFeedURLSessionConfiguration.m
//  Fili
//
//  Created by Christopher Kalafarski on 6/23/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNRSSFeedURLSessionConfiguration.h"

@implementation BNRSSFeedURLSessionConfiguration

+ (NSURLSessionConfiguration*)defaultSessionConfiguration {
  NSURLSessionConfiguration* configuration = NSURLSessionConfiguration.defaultSessionConfiguration;
  
  configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  
  return configuration;
}

@end
