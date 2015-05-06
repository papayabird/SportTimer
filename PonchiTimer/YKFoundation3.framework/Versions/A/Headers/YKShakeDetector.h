//
//  YKShakeDetector.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#define ThresholdDefault 0.2
void YKStartDetectingShake(float threshold,NSTimeInterval updateInterval, void(^actionBlock)(float strength));
void YKStopDetectingShake();
