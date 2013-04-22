//
//  BNPodcastFeedParser.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNRSSFeedParser.h"

@class BNPodcastFeed;

@interface BNPodcastFeedParser : BNRSSFeedParser

- (id)initWithFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure;

- (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure;

@end
