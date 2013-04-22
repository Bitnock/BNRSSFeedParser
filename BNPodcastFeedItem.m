//
//  BNPodcastFeedItem.m
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "BNPodcastFeedItem.h"
#import "BNRSSFeedItemEnclosure.h"

@implementation BNPodcastFeedItem

static NSDateFormatter* durationFormatter = nil;

+ (void)initialize {
  if (!durationFormatter) {
    durationFormatter = NSDateFormatter.new;
  }
  
  [super initialize];
}

- (NSString*)itunesAuthor {
  NSString* attr;
  
  if (_collection && _collection[@"itunes:author"] && [_collection[@"itunes:author"] isKindOfClass:NSString.class]) {
    attr = _collection[@"itunes:author"];
  }
  
  return attr;
}

- (NSString*)itunesSubtitle {
  NSString* attr;
  
  if (_collection && _collection[@"itunes:subtitle"] && [_collection[@"itunes:subtitle"] isKindOfClass:NSString.class]) {
    attr = _collection[@"itunes:subtitle"];
  }
  
  return attr;
}

- (NSString*)itunesSummary {
  NSString* attr;
  
  if (_collection && _collection[@"itunes:summary"] && [_collection[@"itunes:summary"] isKindOfClass:NSString.class]) {
    attr = _collection[@"itunes:summary"];
  }
  
  return attr;
}

- (NSString*)itunesDuration {
  NSString* attr;
  
  if (_collection && _collection[@"itunes:duration"] && [_collection[@"itunes:duration"] isKindOfClass:NSString.class]) {
    attr = _collection[@"itunes:duration"];
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

- (NSTimeInterval)duration {
  NSTimeInterval d = -1;
  
  if (self.itunesDuration) {
    NSArray* dParts = [self.itunesDuration componentsSeparatedByString:@":"];
    
    switch (dParts.count) {
      case 1:
        durationFormatter.dateFormat = @"yyyy ZZZ ss";
        break;
      case 2:
        durationFormatter.dateFormat = @"yyyy ZZZ mm:ss";
        break;
      case 3:
        durationFormatter.dateFormat = @"yyyy ZZ HH:mm:ss";
        break;
      default:
        break;
    }
    
    NSString* stringToParse = [@"1970 +0000 " stringByAppendingFormat:@"%@", self.itunesDuration];
    NSDate* _date = [durationFormatter dateFromString:stringToParse];
    
    d = [_date timeIntervalSince1970];
  } else if (self.enclosure.length) {
    int audioBytes = self.enclosure.length.floatValue;
    
    if (audioBytes > 0) {
      int standardByteRate = (128000.0f/8.0f);
      int estimatedDuration = (audioBytes / standardByteRate);
      
      d = estimatedDuration;
    }
  }
  
  return d;
}

@end
