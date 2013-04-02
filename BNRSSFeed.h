//
//  BNRSSFeed.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRSSFeed : NSDictionary

@property (nonatomic, strong, readonly) NSDictionary* channel;

@property (nonatomic, strong, readonly) NSURL* link;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* description;

@property (nonatomic, strong, readonly) NSString* language;
@property (nonatomic, strong, readonly) NSString* copyright;
@property (nonatomic, strong, readonly) NSString* managingEditor;
@property (nonatomic, strong, readonly) NSString* webMaster;
@property (nonatomic, strong, readonly) NSDate* pubDate;
@property (nonatomic, strong, readonly) NSDate* lastBuildDate;
@property (nonatomic, strong, readonly) NSArray* categories;
//@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong, readonly) NSURL* docs;

@property (nonatomic, strong, readonly) NSArray* items;

@end
