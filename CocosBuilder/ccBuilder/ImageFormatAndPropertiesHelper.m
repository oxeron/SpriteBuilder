#import "ImageFormatAndPropertiesHelper.h"

@implementation ImageFormatAndPropertiesHelper

+ (BOOL)isValueAPowerOfTwo:(NSInteger)value
{
    double result = log((double) value)/log(2.0);

    return 1 << (int)result == value;
}

+ (BOOL)supportsCompress:(kFCImageFormat)format osType:(CCBPublisherOSType)osType
{
    NSArray *formatsSupportingComress;

    if (osType ==  kCCBPublisherOSTypeIOS || osType ==  kCCBPublisherOSTypeTVOS)
    {
        formatsSupportingComress = @[
                @(kFCImageFormatPVR_RGBA8888),
                @(kFCImageFormatPVR_RGBA4444),
                @(kFCImageFormatPVR_RGB565),
                @(kFCImageFormatPVRTC_2BPP),
                @(kFCImageFormatPVRTC_4BPP)
        ];
    }

    return [formatsSupportingComress containsObject:@(format)];
}

+ (BOOL)supportsDither:(kFCImageFormat)format osType:(CCBPublisherOSType)osType;
{
    NSArray *formatsSupportingDither;

    if (osType ==  kCCBPublisherOSTypeIOS || osType ==  kCCBPublisherOSTypeTVOS)
    {
        formatsSupportingDither = @[
                @(kFCImageFormatPNG_8BIT),
                @(kFCImageFormatPVR_RGBA4444),
                @(kFCImageFormatPVR_RGB565)
        ];
    }

    return [formatsSupportingDither containsObject:@(format)];
}

@end