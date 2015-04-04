//
//  BNRSSFeed.m
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

#import "BNRSSFeed.h"
#import "BNRSSFeedItem.h"
#import "NSDate+RSS.h"

@interface BNRSSFeed () {
  NSDictionary* _channel;
  NSArray* _items;
}

@property (nonatomic, strong) NSDictionary* collection;

@end

@implementation BNRSSFeed

#pragma mark - Setup

- (id)init {
  self = [super init];
  if (self) {
    self.collection = NSDictionary.dictionary;
  }
  return self;
}

#pragma mark - NSDictionary primative methods

- (id)initWithObjects:(NSArray*)objects forKeys:(NSArray*)keys {
  self = [super init];
  if (self) {
    self.collection = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
  }
  return self;
}

- (NSUInteger)count {
  return self.collection.count;
}

- (id)objectForKey:(id)aKey {
  return [self.collection objectForKey:aKey];
}

- (NSEnumerator*)keyEnumerator {
  return [self.collection keyEnumerator];
}

#pragma mark - RSS feed channel element accessors

- (NSDictionary*)channel {
  if (!_channel && self.collection[@"rss"] && self.collection[@"rss"][@"channel"]) {
    _channel = self.collection[@"rss"][@"channel"];
  }
  
  return _channel;
}

#pragma mark Required elements

- (NSURL*)link {
  NSURL* attr;
  
  if (self.channel && self.channel[@"link"] && [self.channel[@"link"] isKindOfClass:NSString.class]) {
    attr = [NSURL URLWithString:self.channel[@"link"]];
  }
  
  return attr;
}

- (NSString*)title {
  NSString* attr;
  
  if (self.channel && self.channel[@"title"] && [self.channel[@"title"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"title"];
  }
  
  return attr;
}

- (NSString*)description {
  NSString* attr;
  
  if (self.channel && self.channel[@"description"] && [self.channel[@"description"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"description"];
  }
  
  return attr;
}

#pragma mark Optional elements

- (NSString*)language {
  NSString* attr;
  
  if (self.channel && self.channel[@"language"] && [self.channel[@"language"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"language"];
  }
  
  return attr;
}

- (NSString*)copyright {
  NSString* attr;
  
  if (self.channel && self.channel[@"copyright"] && [self.channel[@"copyright"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"copyright"];
  }
  
  return attr;
}

- (NSString*)managingEditor {
  NSString* attr;
  
  if (self.channel && self.channel[@"managingEditor"] && [self.channel[@"managingEditor"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"managingEditor"];
  }
  
  return attr;
}

- (NSString*)webMaster {
  NSString* attr;
  
  if (self.channel && self.channel[@"webMaster"] && [self.channel[@"webMaster"] isKindOfClass:NSString.class]) {
    attr = self.channel[@"webMaster"];
  }
  
  return attr;
}

- (NSDate*)pubDate {
  NSDate* attr;
  
  if (self.channel && self.channel[@"pubDate"] && [self.channel[@"pubDate"] isKindOfClass:NSString.class]) {
    attr = [NSDate dateWithPubDate:self.channel[@"pubDate"]];
  }
  
  return attr;
}

- (NSDate*)lastBuildDate {
  NSDate* attr;
  
  if (self.channel && self.channel[@"lastBuildDate"] && [self.channel[@"lastBuildDate"] isKindOfClass:NSString.class]) {
    attr = [NSDate dateWithPubDate:self.channel[@"lastBuildDate"]];
  }
  
  return attr;
}

- (NSArray*)categories {
  NSArray* attr;
  
  if (self.channel && self.channel[@"category"]) {
    if ([self.channel[@"category"] isKindOfClass:NSArray.class]) {
      attr = self.channel[@"category"];
    } else if ([self.channel[@"category"] isKindOfClass:NSString.class]) {
      attr = @[ self.channel[@"category"] ];
    }
  }
  
  return attr;
}

- (NSURL*)docs {
  NSURL* attr;
  
  if (self.channel && self.channel[@"docs"] && [self.channel[@"docs"] isKindOfClass:NSString.class]) {
    attr = [NSURL URLWithString:self.channel[@"docs"]];
  }
  
  return attr;
}

- (NSArray*)items {  
  if (self.channel && self.channel[@"item"] && !_items) {
    NSArray* __items;
    
    if ([self.channel[@"item"] isKindOfClass:NSArray.class]) {
      __items = self.channel[@"item"];
    } else if ([self.channel[@"item"] isKindOfClass:NSDictionary.class]) {
      __items = @[ self.channel[@"item"] ];
    }
    
    NSMutableArray* feedItems = [NSMutableArray arrayWithCapacity:__items.count];
    
    for (NSDictionary* itemDict in __items) {
      [feedItems addObject:[[BNRSSFeedItem alloc] initWithObjects:itemDict.allValues forKeys:itemDict.allKeys]];
    }
    
    _items = feedItems.copy;
  }
  
  return _items;
}

@end
