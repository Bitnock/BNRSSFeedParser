//
//  BNPodcastFeed.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNRSSFeed.h"

@interface BNPodcastFeed : BNRSSFeed

@property (nonatomic, strong, readonly) NSString* itunesAuthor;
@property (nonatomic, strong, readonly) NSString* itunesSubtitle;
@property (nonatomic, strong, readonly) NSString* itunesExplicit;

@property (nonatomic, strong, readonly) NSString* subtitle;
@property (nonatomic, readonly) BOOL isExplicit;

@end
