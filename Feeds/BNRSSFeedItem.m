//
//  BNRSSFeedItem.m
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

#import "BNRSSFeedItem.h"
#import "BNRSSFeedItemEnclosure.h"
#import "NSDate+RSS.h"

@interface BNRSSFeedItem ()

@property (nonatomic, strong) NSDictionary* collection;

@end

@implementation BNRSSFeedItem

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

#pragma mark Required elements

- (NSString*)title {
  NSString* attr;
  
  if (self.collection && self.collection[@"title"] && [self.collection[@"title"] isKindOfClass:NSString.class]) {
    attr = self.collection[@"title"];
  }
  
  return attr;
}

- (NSString*)description {
  NSString* attr;
  
  if (self.collection && self.collection[@"description"] && [self.collection[@"description"] isKindOfClass:NSString.class]) {
    attr = self.collection[@"description"];
  }
  
  return attr;
}

#pragma mark Optional elements

- (NSURL*)link {
  NSURL* attr;
  
  if (self.collection && self.collection[@"link"] && [self.collection[@"link"] isKindOfClass:NSString.class]) {
    attr = [NSURL URLWithString:self.collection[@"link"]];
  }
  
  return attr;
}

- (NSString*)author {
  NSString* attr;
  
  if (self.collection && self.collection[@"author"] && [self.collection[@"author"] isKindOfClass:NSString.class]) {
    attr = self.collection[@"author"];
  }
  
  return attr;
}

- (NSDate*)pubDate {
  NSDate* attr;
  
  if (self.collection && self.collection[@"pubDate"] && [self.collection[@"pubDate"] isKindOfClass:NSString.class]) {
    attr = [NSDate dateWithPubDate:self.collection[@"pubDate"]];
  }
  
  return attr;
}

- (NSArray*)categories {
  NSArray* attr;
  
  if (self.collection && self.collection[@"category"]) {
    if ([self.collection[@"category"] isKindOfClass:NSArray.class]) {
      attr = self.collection[@"category"];
    } else if ([self.collection[@"category"] isKindOfClass:NSString.class]) {
      attr = @[ self.collection[@"category"] ];
    }
  }
  
  return attr;
}

- (NSString*)guid {
  NSString* attr;
  
  if (self.collection && self.collection[@"guid"] && [self.collection[@"guid"] isKindOfClass:NSString.class]) {
    attr = self.collection[@"guid"];
  }
  
  return attr;
}

- (BNRSSFeedItemEnclosure*)enclosure {
  BNRSSFeedItemEnclosure* enc;
  
  if (self.collection && self.collection[@"enclosure"] && [self.collection[@"enclosure"] isKindOfClass:NSDictionary.class]) {
    NSDictionary* dict = (NSDictionary*)self.collection[@"enclosure"];
    enc = [[BNRSSFeedItemEnclosure alloc] initWithObjects:dict.allValues forKeys:dict.allKeys];
  } else if (self.collection && self.collection[@"enclosure"] && [self.collection[@"enclosure"] isKindOfClass:NSArray.class]) {
    NSDictionary* dict = [(NSArray*)self.collection[@"enclosure"] objectAtIndex:0];
    enc = [[BNRSSFeedItemEnclosure alloc] initWithObjects:dict.allValues forKeys:dict.allKeys];
  }
  
  return enc;
}

- (NSURL*)comments {
  NSURL* attr;
  
  if (self.collection && self.collection[@"comments"] && [self.collection[@"comments"] isKindOfClass:NSString.class]) {
    attr = [NSURL URLWithString:self.collection[@"comments"]];
  }
  
  return attr;
}

@end
