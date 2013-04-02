//
//  NSDate+RSS.h
//  Kerto
//
//  Created by Christopher Kalafarski on 4/2/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RSS)

+ (id)dateWithPubDate:(NSString*)pubDate;

@end
