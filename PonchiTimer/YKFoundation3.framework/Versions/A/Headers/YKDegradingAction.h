//
//  YKDegradingAction.h
//  inthouse
//
//  Created by John Hsu on 2014/6/19.
//  Copyright (c) 2014年 grasea. All rights reserved.
//

#import <Foundation/Foundation.h>

// you can define customized degrading timing function by yourself
void dispatch_async_repeated(dispatch_time_t firstPopTime, dispatch_time_t(^timingFunction)(dispatch_time_t lastFiringTime), dispatch_queue_t queue, void(^work)(BOOL *shouldStop));

// simple degrading timing function power by 2
void dispatch_async_repeated_degrading(dispatch_queue_t queue, void(^work)(BOOL *shouldStop), NSTimeInterval maxWaitingInterval);

