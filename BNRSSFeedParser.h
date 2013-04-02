//
//  BNRSSFeedParser.h
//  Kerto
//
//  Created by Christopher Kalafarski on 3/30/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRSSFeed;

@interface BNRSSFeedParser : NSObject <NSXMLParserDelegate>

- (id)initWithFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNRSSFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure;

- (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNRSSFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure;

@end
