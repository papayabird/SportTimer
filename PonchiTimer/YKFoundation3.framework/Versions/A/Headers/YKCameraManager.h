//
//  YKCameraManager.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef enum {
    YKCameraOutputModeManual = 1, // outputs frame when called outputFrame
    YKCameraOutputModeAuto = 0,    // outputs frame every 10 buffer frames delivered
    YKCameraOutputModeNone = -999    // do not outputs any frame, even when outputFrame called
}YKCameraOutputMode;
@interface YKCameraManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    @private
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *previewLayer;
    void(^actionBlock)(AVCaptureDevicePosition,UIImage *);
    CGSize outputSize;
    YKCameraOutputMode outputMode;
    NSUInteger currentInputDeviceIndex;
    NSArray *inputDevices;
}

// check for authorization status
+(AVAuthorizationStatus)authorizationStatus NS_AVAILABLE_IOS(7_0);

/* 
 you have to manually flip the image when using front camera 
 
 if (AVCaptureDevicePosition == AVCaptureDevicePositionFront) {
     outputImage = [[[UIImage alloc] initWithCGImage:outputImage scale:1.0 orientation:UIImageOrientationUpMirrored] autorelease];
 }
 */
/*
 if previous session exists, close it and reopen, shows a warning NSLog
 */

// (this method calls with session preset AVCaptureSessionPresetMedium for iPhone 3Gs camera supporting)
+(AVCaptureVideoPreviewLayer *)startCapturingWithFrameActionBlock:(void(^)(AVCaptureDevicePosition,UIImage *))block frameSize:(CGSize)size outputMode:(YKCameraOutputMode)mode devicePosition:(AVCaptureDevicePosition)devicePosition;

+(AVCaptureVideoPreviewLayer *)startCapturingWithFrameActionBlock:(void(^)(AVCaptureDevicePosition,UIImage *))block frameSize:(CGSize)size outputMode:(YKCameraOutputMode)mode devicePosition:(AVCaptureDevicePosition)devicePosition sessionPreset:(NSString *)sessionPreset;

// full size, no image cropping
+(AVCaptureVideoPreviewLayer *)startCapturingWithFrameActionBlock:(void(^)(AVCaptureDevicePosition,UIImage *))block outputMode:(YKCameraOutputMode)mode devicePosition:(AVCaptureDevicePosition)devicePosition sessionPreset:(NSString *)sessionPreset;


+(void)stopCapturing;
+(BOOL)hasMultipleCamera;
/*
 switch between back and front camera (or more camera attached to accessory)
 */
+(void)changeCamera;
/*
 make manager call output block on next frame (used when outputMode is YKCameraOutputModeManual)
 */
+(void)outputFrame;
+(AVCaptureDevicePosition)currentOutputPosition;
+(CGSize)cameraSizeForCurrentCameraInput;
@end
