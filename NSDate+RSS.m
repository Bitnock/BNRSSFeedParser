//
//  NSDate+RSS.m
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import "NSDate+RSS.h"

@implementation NSDate (RSS)

static NSDateFormatter* pubDateFormatterTZOffset = nil;
static NSDateFormatter* pubDateFormatterTZAbbreviation = nil;

+ (void)initialize {
  if (!pubDateFormatterTZOffset) {
    // ex. Tue, 02 Oct 2012 19:56:51 +0000
    pubDateFormatterTZOffset = NSDateFormatter.new;
    pubDateFormatterTZOffset.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
    
    // ex. Tue, 02 Oct 2012 19:56:51 EDT
    pubDateFormatterTZAbbreviation = NSDateFormatter.new;
    pubDateFormatterTZAbbreviation.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss zzz";
  }
  
  [super initialize];
}

+ (id)dateWithPubDate:(NSString*)pubDate {
  NSDate* date;
  
  date = [pubDateFormatterTZOffset dateFromString:pubDate];
  
  if (!date) {
    date = [pubDateFormatterTZAbbreviation dateFromString:pubDate];
  }
  
  return date;
}

@end
