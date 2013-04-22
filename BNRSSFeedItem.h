//
//  BNRSSFeedItem.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRSSFeedItemEnclosure;

@interface BNRSSFeedItem : NSDictionary {
  NSDictionary* _collection;
}

@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* description;

@property (nonatomic, strong, readonly) NSURL* link;
@property (nonatomic, strong, readonly) NSString* author;
@property (nonatomic, strong, readonly) NSDate* pubDate;
//@property (nonatomic, strong, readonly) NSDictionary* source;
@property (nonatomic, strong, readonly) NSArray* categories;
@property (nonatomic, strong, readonly) NSString* guid;
@property (nonatomic, strong, readonly) BNRSSFeedItemEnclosure* enclosure;
@property (nonatomic, strong, readonly) NSURL* comments;

@end
