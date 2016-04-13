//
//  ImagePropertiesHelper_Tests.m
//  CocosBuilder
//
//  Created by Nicky Weber on 25.08.14.
//
//

#import <XCTest/XCTest.h>
#import "ImageFormatAndPropertiesHelper.h"

@interface ImageFormatAndPropertiesHelper_Tests : XCTestCase

@end


@implementation ImageFormatAndPropertiesHelper_Tests

- (void)testIsValueAPowerOfTwo
{
    XCTAssertTrue([ImageFormatAndPropertiesHelper isValueAPowerOfTwo:4096]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper isValueAPowerOfTwo:256]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper isValueAPowerOfTwo:2]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper isValueAPowerOfTwo:3]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper isValueAPowerOfTwo:255]);
}

- (void)testSupportsCompress
{
    // iOS
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGBA4444 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGB565 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVRTC_2BPP osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVRTC_4BPP osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPNG osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPNG_8BIT osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_High osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_Medium osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_Low osType:kCCBPublisherOSTypeIOS]);
    // tvOS
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGBA4444 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVR_RGB565 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVRTC_2BPP osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPVRTC_4BPP osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPNG osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatPNG_8BIT osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_High osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_Medium osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsCompress:kFCImageFormatJPG_Low osType:kCCBPublisherOSTypeTVOS]);
}

- (void)testSupportsDither
{
    // iOS
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPNG_8BIT osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA4444 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGB565 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVRTC_2BPP osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVRTC_4BPP osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPNG osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_High osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_Medium osType:kCCBPublisherOSTypeIOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_Low osType:kCCBPublisherOSTypeIOS]);
    // tvOS
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPNG_8BIT osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA4444 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertTrue([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGB565 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVRTC_2BPP osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVRTC_4BPP osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPVR_RGBA8888 osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatPNG osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_High osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_Medium osType:kCCBPublisherOSTypeTVOS]);
    XCTAssertFalse([ImageFormatAndPropertiesHelper supportsDither:kFCImageFormatJPG_Low osType:kCCBPublisherOSTypeTVOS]);
}

@end
