//
//  BNPodcastFeed.m
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
