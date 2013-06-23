//
//  BNRSSFeedURLSessionManager.m
//  Fili
//
//  Created by Christopher Kalafarski on 6/23/13.
//  Copyright (c) 2013 Bitnock.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
