//
//  BNRSSFeedParser.m
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

#import "BNRSSFeedParser.h"
#import "BNPodcastFeed.h"

#import "BNRSSFeedItem.h"
#import "BNRSSFeedItemEnclosure.h"

#import "BNRSSFeedURLSessionManager.h"

NSString *const kXMLReaderTextNodeKey = @"__text__";

@interface BNRSSFeedParser () {
  NSMutableArray* _parsedElementStack;
  NSMutableString* _currentElementCharacters;
  NSDate* _abortAtPubDate;
}

@property (nonatomic, strong) NSHTTPURLResponse* operationResponse;

@property (nonatomic, copy) void (^successBlock)(NSHTTPURLResponse*, BNRSSFeed*);
@property (nonatomic, copy) void (^failureBlock)(NSHTTPURLResponse*, NSError*);

@end

@implementation BNRSSFeedParser

static NSDateFormatter* dateFormatter = nil;
static NSDateFormatter* dateFormatterAlt = nil;

+ (void)initialize {
  [super initialize];
  
  if (!dateFormatter) {
    dateFormatter = NSDateFormatter.new;
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
    // ex. Tue, 02 Oct 2012 19:56:51 +0000
    
    dateFormatterAlt = NSDateFormatter.new;
    dateFormatterAlt.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
    // ex. Tue, 02 Oct 2012 19:56:51 EDT
  }
}

- (id)initWithFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNRSSFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  self = [super init];
  if (self) {
    [self parseFeedURL:feedURL withETag:feedETag untilPubDate:pubDate success:success failure:failure];
  }
  return self;
}

- (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNRSSFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:feedURL];
  [request setValue:feedETag forHTTPHeaderField:@"If-None-Match"];
  
  _abortAtPubDate = pubDate;

  NSURLSessionDataTask* task = [BNRSSFeedURLSessionManager.sharedManager.session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
      self.operationResponse = (NSHTTPURLResponse*)response;
      
      if (error && failure) {
        failure(self.operationResponse, error);
      } else if (self.operationResponse.statusCode == 304 && success) {
        failure(self.operationResponse, error);
      } else if (data) {
        self.successBlock = success;
        self.failureBlock = failure;
        
        NSXMLParser* XMLParser = [[NSXMLParser alloc] initWithData:data];
        XMLParser.delegate = self;
        [XMLParser parse];
      } else {
        failure(self.operationResponse, error);
      }
    } else {
      if (failure) {
        failure(nil, error);
      }
    }
  }];
  
  [task resume];
}

#pragma mark - XML parser delegate

- (void)parserDidStartDocument:(NSXMLParser*)parser {
  _parsedElementStack = [NSMutableArray arrayWithObject:NSMutableDictionary.dictionary];
  _currentElementCharacters = NSMutableString.string;
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict {

  NSMutableDictionary* parentElementDict = _parsedElementStack.lastObject;
  
  // Create the child dictionary for the new element, and initilaize it with the attributes
  NSMutableDictionary* currentElementDict = NSMutableDictionary.dictionary;
  [currentElementDict addEntriesFromDictionary:attributeDict];
  
  // If there’s already an item for this key, it means we need to create an array
  id existingValue = parentElementDict[elementName];
  
  if (existingValue) {
    NSMutableArray* array = nil;
    
    if ([existingValue isKindOfClass:NSMutableArray.class]) {
      array = (NSMutableArray*)existingValue;
    } else {
      array = NSMutableArray.array;
      [array addObject:existingValue];
      
      parentElementDict[elementName] = array;
    }
    
    [array addObject:currentElementDict];
  } else {
    parentElementDict[elementName] = currentElementDict;
  }
  
  [_parsedElementStack addObject:currentElementDict];
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
  [_currentElementCharacters appendString:string];
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
  
  NSMutableDictionary* currentElementDict = _parsedElementStack.lastObject;
  
  NSString* characters = [_currentElementCharacters stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
  
  if ([elementName isEqualToString:@"pubDate"] && _parsedElementStack.count > 4) {
    NSDate* pubDate = [dateFormatter dateFromString:characters];
    
    if (!pubDate) {
      pubDate = [dateFormatterAlt dateFromString:characters];
    }
    
    if (pubDate && _abortAtPubDate) {
      if ([pubDate timeIntervalSinceDate:_abortAtPubDate] <= 0) {
        
        id item = _parsedElementStack[0][@"rss"][@"channel"][@"item"];
        
        if ([item isKindOfClass:NSMutableDictionary.class]) {
          NSMutableDictionary* channelDict = _parsedElementStack[0][@"rss"][@"channel"];
          [channelDict removeObjectForKey:@"item"];
        } else if ([item isKindOfClass:NSMutableArray.class]) {
          NSMutableArray* _item = (NSMutableArray*)item;
          [_item removeLastObject];
        }

        [parser abortParsing];
      }
    }
  }
  
  if (_currentElementCharacters && characters.length > 0) {
    if (currentElementDict.allKeys.count == 0 && _parsedElementStack.count >= 2) {
      NSMutableDictionary* parentDict = [_parsedElementStack objectAtIndex:(_parsedElementStack.count - 2)];
      
      parentDict[elementName] = characters;
    } else {
      [currentElementDict setObject:characters forKey:kXMLReaderTextNodeKey];
    }
    
    _currentElementCharacters = NSMutableString.string;
  }
  
  [_parsedElementStack removeLastObject];
}

- (void)parserDidEndDocument:(NSXMLParser*)parser {
  if (self.successBlock) {
    self.successBlock(self.operationResponse, self.feed);
    self.successBlock = nil;
  }
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
  if (parseError.code == NSXMLParserDelegateAbortedParseError) {
    if (self.successBlock) {
      self.successBlock(self.operationResponse, self.feed);
      self.successBlock = nil;
    }
    
    return;
  }
  
  if (self.failureBlock) {
    self.failureBlock(self.operationResponse, parseError);
    self.failureBlock = nil;
  }
}

#pragma mark - Feed constructor

- (BNRSSFeed*)feed {
  BNRSSFeed* rssFeed;
  
  if (_parsedElementStack.count > 0) {
    NSDictionary* feedDict = _parsedElementStack[0];
    rssFeed = [[BNRSSFeed alloc] initWithObjects:feedDict.allValues forKeys:feedDict.allKeys];
  }
  
  return rssFeed;
}

@end
