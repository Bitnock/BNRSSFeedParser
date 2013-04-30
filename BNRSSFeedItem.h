//
//  BNRSSFeedItem.h
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

#import <Foundation/Foundation.h>

@class BNRSSFeedItemEnclosure;

@interface BNRSSFeedItem : NSDictionary {
  NSDictionary* _collection;
}

@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* description;

@property (nonatomic, strong, readonly) NSURL* link;
@property (nonatomic, strong, readonly) NSString* author;
@property (nonatomic, strong, readonly) NSDate* pubDate;
//@property (nonatomic, strong, readonly) NSDictionary* source;
@property (nonatomic, strong, readonly) NSArray* categories;
@property (nonatomic, strong, readonly) NSString* guid;
@property (nonatomic, strong, readonly) BNRSSFeedItemEnclosure* enclosure;
@property (nonatomic, strong, readonly) NSURL* comments;

@end
