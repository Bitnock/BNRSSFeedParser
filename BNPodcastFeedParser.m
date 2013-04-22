//
//  BNPodcastFeedParser.m
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNPodcastFeedParser.h"
#import "BNPodcastFeed.h"

#import "AFXMLRequestOperation.h"

NSString *const kXMLReaderTextNodeKey2 = @"_text";

@interface BNPodcastFeedParser () {
  NSMutableArray* _parsedElementStack;
  NSMutableString* _currentElementCharacters;
  NSDate* _abortAtPubDate;
}

@property (nonatomic, strong) NSHTTPURLResponse* operationResponse;

@property (nonatomic, copy) void (^successBlock)(NSHTTPURLResponse*, BNPodcastFeed*);
@property (nonatomic, copy) void (^failureBlock)(NSHTTPURLResponse*, NSError*);

@end

@implementation BNPodcastFeedParser

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
  
  [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/rss+xml"]];
}

- (id)initWithFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  self = [super init];
  if (self) {
    [self parseFeedURL:feedURL withETag:feedETag untilPubDate:pubDate success:success failure:failure];
  }
  return self;
}

- (void)parseFeedURL:(NSURL*)feedURL withETag:(NSString*)feedETag untilPubDate:(NSDate*)pubDate success:(void (^)(NSHTTPURLResponse*, BNPodcastFeed*))success failure:(void (^)(NSHTTPURLResponse*, NSError*))failure {
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:feedURL];
  request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
  [request setValue:feedETag forHTTPHeaderField:@"If-None-Match"];
  
  _abortAtPubDate = pubDate;
  
  AFXMLRequestOperation* operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest* request, NSHTTPURLResponse* response, NSXMLParser* XMLParser) {
    self.operationResponse = response;
    self.successBlock = success;
    
    XMLParser.delegate = self;
    [XMLParser parse];
  } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, NSXMLParser* XMLParser) {
    if (failure) {
      failure(response, error);
    }
  }];
  
  [operation start];
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
  
  // Ignoring pubDate on Channel for now...
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
        [self parserDidEndDocument:parser];
      }
    }
  }
  
  if (_currentElementCharacters && characters.length > 0) {
    if (currentElementDict.allKeys.count == 0 && _parsedElementStack.count >= 2) {
      NSMutableDictionary* parentDict = [_parsedElementStack objectAtIndex:(_parsedElementStack.count - 2)];
      
      parentDict[elementName] = characters;
    } else {
      [currentElementDict setObject:characters forKey:kXMLReaderTextNodeKey2];
    }
    
    _currentElementCharacters = NSMutableString.string;
  }
  
  [_parsedElementStack removeLastObject];
}

- (void)parserDidEndDocument:(NSXMLParser*)parser {
  if (self.successBlock) {
    self.successBlock(self.operationResponse, self.feed);
  }
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
  if (self.failureBlock) {
    self.failureBlock(self.operationResponse, parseError);
  }
}

#pragma mark - Feed constructor

- (BNPodcastFeed*)feed {
  BNPodcastFeed* rssFeed;
  
  if (_parsedElementStack.count > 0) {
    NSDictionary* feedDict = _parsedElementStack[0];
    rssFeed = [[BNPodcastFeed alloc] initWithObjects:feedDict.allValues forKeys:feedDict.allKeys];
  }
  
  return rssFeed;
}

@end
