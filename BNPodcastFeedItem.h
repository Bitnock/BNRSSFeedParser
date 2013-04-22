//
//  BNPodcastFeedItem.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNRSSFeedItem.h"

@interface BNPodcastFeedItem : BNRSSFeedItem

@property (nonatomic, strong, readonly) NSString* itunesAuthor;
@property (nonatomic, strong, readonly) NSString* itunesSubtitle;
@property (nonatomic, strong, readonly) NSString* itunesSummary;
@property (nonatomic, strong, readonly) NSString* itunesDuration;

@property (nonatomic, strong, readonly) NSString* author;
@property (nonatomic, strong, readonly) NSString* subtitle;
@property (nonatomic, strong, readonly) NSString* summary;
@property (nonatomic, readonly) NSTimeInterval duration;

@end
