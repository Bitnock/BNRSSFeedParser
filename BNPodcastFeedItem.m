//
//  BNPodcastFeedItem.m
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
