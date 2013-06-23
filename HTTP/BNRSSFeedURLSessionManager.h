//
//  BNRSSFeedURLSessionManager.h
//  Fili
//
//  Created by Christopher Kalafarski on 6/23/13.
//  Copyright (c) 2013 Bitnock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRSSFeedURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>

+ (BNRSSFeedURLSessionManager*)sharedManager;

@property (nonatomic, strong) NSURLSession* session;

@end
