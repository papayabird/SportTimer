//
//  YKWaitForLocationUpdate.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
void YKWaitForLocationUpdate(NSTimeInterval interval,void (^succeedBlock)(CLLocation *location) ,void (^timeoutBlock)(void) );

