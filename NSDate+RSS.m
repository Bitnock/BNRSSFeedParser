//
//  NSDate+RSS.m
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
