//
//  BNRSSFeedURLSessionManager.m
//  Fili
//
//  Created by Christopher Kalafarski on 6/23/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNRSSFeedURLSessionManager.h"
#import "BNRSSFeedURLSessionConfiguration.h"

@implementation BNRSSFeedURLSessionManager

static BNRSSFeedURLSessionManager* sharedManager;

+ (BNRSSFeedURLSessionManager*)sharedManager {
  @synchronized(self) {
    if (sharedManager == nil) {
      sharedManager = self.new;
    }
  }
  
  return sharedManager;
}

- (id)init {
  self = [super init];
  if (self) {
    self.session = [NSURLSession sessionWithConfiguration:BNRSSFeedURLSessionConfiguration.defaultSessionConfiguration
                                                 delegate:self
                                            delegateQueue:NSOperationQueue.mainQueue];
  }
  return self;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didCompleteWithError:(NSError*)error {
  NSLog(@"=== TASK DID COMPLETE");
}

@end
