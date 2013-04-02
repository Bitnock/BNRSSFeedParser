//
//  BNRSSFeedItemEnclosure.m
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
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
