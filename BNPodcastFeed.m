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

- (NSArray*)items {
  if (self.channel && self.channel[@"item"] && !_items) {
    NSArray* __items;
    
    if ([self.channel[@"item"] isKindOfClass:NSArray.class]) {
      __items = self.channel[@"item"];
    } else if ([self.channel[@"item"] isKindOfClass:NSString.class]) {
      __items = @[ self.channel[@"item"] ];
    }
    
    NSMutableArray* feedItems = [NSMutableArray arrayWithCapacity:__items.count];
    
    for (NSDictionary* itemDict in __items) {
      [feedItems addObject:[[BNPodcastFeedItem alloc] initWithObjects:itemDict.allValues forKeys:itemDict.allKeys]];
    }
    
    _items = feedItems.copy;
  }
  
  return _items;
}

@end
