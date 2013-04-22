//
//  BNPodcastFeed.m
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNPodcastFeed.h"
#import "BNPodcastFeedItem.h"

@interface BNPodcastFeed () {
  NSArray* _items;
}

@end

@implementation BNPodcastFeed

#pragma mark - BNRSSFeed

- (NSArray*)items {
  if (!_items) {
    NSMutableArray* __items = [NSMutableArray arrayWithCapacity:super.items.count];
    
    for (BNRSSFeedItem* item in super.items) {
      [__items addObject:[[BNPodcastFeedItem alloc] initWithObjects:item.allValues forKeys:item.allKeys]];
    }
    
    _items = __items.copy;
  }
  
  return _items;
}

#pragma mark - iTunes extensions

- (NSString*)itunesAuthor {
  NSString* attr;
  
  if (self.channel && self.channel[@"itunes:author"] && [self.channel[@"itunes:author"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"itunes:author"];
  }
  
  return attr;
}

- (NSString*)itunesSubtitle {
  NSString* attr;
  
  if (self.channel && self.channel[@"itunes:subtitle"] && [self.channel[@"itunes:subtitle"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"itunes:subtitle"];
  }
  
  return attr;
}

- (NSString*)itunesSummary {
  NSString* attr;
  
  if (self.channel && self.channel[@"itunes:summary"] && [self.channel[@"itunes:summary"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"itunes:summary"];
  }
  
  return attr;
}

#pragma mark Helpers

- (NSString*)author {
  return self.itunesAuthor;
}

- (NSString*)subtitle {
  return self.itunesSubtitle;
}

- (NSString*)summary {
  return self.itunesSummary;
}

@end
