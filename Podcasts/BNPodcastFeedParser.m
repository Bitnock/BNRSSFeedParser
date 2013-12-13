//
//  BNPodcastFeedParser.m
//  BNRSSFeedParser
//
//  Created by Christopher Kalafarski on 4/2/2013.
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

#import "BNPodcastFeedParser.h"
#import "BNPodcastFeed.h"

NSString *const kXMLReaderTextNodeKey2 = @"_text";

@interface BNPodcastFeedParser ()

@end

@implementation BNPodcastFeedParser

- (id)initWithFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  self = [super init];
  if (self) {
    [self parseFeedURL:feedURL withETag:feedETag untilPubDate:pubDate success:success failure:failure];
  }
  return self;
}

- (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  
  void (^_successBlock)(NSHTTPURLResponse*, BNRSSFeed*) = ^(NSHTTPURLResponse* response, BNRSSFeed* rssFeed){
    if (success) {
      BNPodcastFeed* podcastFeed = (BNPodcastFeed*)rssFeed;
      success(response, podcastFeed);
    }
  };
  
  [super parseFeedURL:feedURL withETag:feedETag untilPubDate:pubDate success:_successBlock failure:failure];
}

- (BNPodcastFeed*)feed {
  BNRSSFeed* rssFeed = [super feed];
  
  return [[BNPodcastFeed alloc] initWithObjects:rssFeed.allValues forKeys:rssFeed.allKeys];
}

@end
