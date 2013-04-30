//
//  BNRSSFeedItemEnclosure.m
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

#import "BNRSSFeedItemEnclosure.h"

@interface BNRSSFeedItemEnclosure ()

@property (nonatomic, strong) NSDictionary* collection;

@end

@implementation BNRSSFeedItemEnclosure

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

#pragma mark - Attribute accessors

- (NSURL*)url {
  NSURL* attr;
  
  if (self.collection && self.collection[@"url"] && [self.collection[@"url"] isKindOfClass:NSString.class]) {
    attr = [NSURL URLWithString:self.collection[@"url"]];
  }
  
  return attr;
}

- (NSNumber*)length {
  NSNumber* attr;
  
  if (self.collection && self.collection[@"length"] && [self.collection[@"length"] isKindOfClass:NSString.class]) {
    attr = @([(NSString*)self.collection[@"length"] floatValue]);
  }
  
  return attr;
  
}

- (NSString*)type {
  NSString* attr;
  
  if (self.collection && self.collection[@"type"] && [self.collection[@"type"] isKindOfClass:NSString.class]) {
    attr = self.collection[@"type"];
  }
  
  return attr;
}

@end
