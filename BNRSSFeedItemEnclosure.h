//
//  BNRSSFeedItemEnclosure.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRSSFeedItemEnclosure : NSDictionary

@property (nonatomic, strong, readonly) NSURL* url;
@property (nonatomic, strong, readonly) NSNumber* length;
@property (nonatomic, strong, readonly) NSString* type;

@end
