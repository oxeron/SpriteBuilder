#import "ProjectSettings+Convenience.h"
#import "FCFormatConverter.h"
#import "CCBWarnings.h"
#import "NSString+RelativePath.h"
#import "MiscConstants.h"
#import "ResourcePropertyKeys.h"


@implementation ProjectSettings (Convenience)

- (BOOL)isPublishEnvironmentRelease
{
    return self.publishEnvironment == kCCBPublishEnvironmentRelease;
}

- (BOOL)isPublishEnvironmentDebug
{
    return self.publishEnvironment == kCCBPublishEnvironmentDevelop;
}

- (NSInteger)soundQualityForRelPath:(NSString *)relPath osType:(CCBPublisherOSType)osType
{
    NSString *key = osType == kCCBPublisherOSTypeIOS
        ? RESOURCE_PROPERTY_IOS_SOUND_QUALITY
        : RESOURCE_PROPERTY_TVOS_SOUND_QUALITY;

    int result = [[self propertyForRelPath:relPath andKey:key] intValue];
    if (!result)
    {
        return NSNotFound;
    }
    return result;
}

- (int)soundFormatForRelPath:(NSString *)relPath osType:(CCBPublisherOSType)osType
{
    NSString *key;
    NSDictionary *map;
    if (osType == kCCBPublisherOSTypeIOS)
    {
        key = RESOURCE_PROPERTY_IOS_SOUND;
        map = @{@(0):@(kFCSoundFormatCAF),
                @(1):@(kFCSoundFormatMP4)};
    }
    else if (osType == kCCBPublisherOSTypeTVOS)
    {
        key = RESOURCE_PROPERTY_TVOS_SOUND;
        map = @{@(0):@(kFCSoundFormatCAF),
                @(1):@(kFCSoundFormatMP4)};
    }
    else
    {
        return 0;
    }

    int formatRaw = [[self propertyForRelPath:relPath andKey:key] intValue];

    NSNumber *result = map[@(formatRaw)];

    return result
           ? [result intValue]
           : -1;
}

- (NSArray *)publishingResolutionsForOSType:(CCBPublisherOSType)osType;
{
    if (osType == kCCBPublisherOSTypeIOS)
    {
        return [self publishingResolutionsForIOS];
    }
    if (osType == kCCBPublisherOSTypeTVOS)
    {
        return [self publishingResolutionsForTVOS];
    }
    return nil;
}

- (NSArray *)publishingResolutionsForIOS
{
    NSMutableArray *result = [NSMutableArray array];

    if (self.publishResolution_ios_phone)
    {
        [result addObject:RESOLUTION_PHONE];
    }
    if (self.publishResolution_ios_phonehd)
    {
        [result addObject:RESOLUTION_PHONE_HD];
    }
    if (self.publishResolution_ios_tablet)
    {
        [result addObject:RESOLUTION_TABLET];
    }
    if (self.publishResolution_ios_tablethd)
    {
        [result addObject:RESOLUTION_TABLET_HD];
    }
    return result;
}

- (NSArray *)publishingResolutionsForTVOS
{
    NSMutableArray *result = [NSMutableArray array];
    
    if (self.publishResolution_tvos_phone)
    {
        [result addObject:RESOLUTION_PHONE];
    }
    if (self.publishResolution_tvos_phonehd)
    {
        [result addObject:RESOLUTION_PHONE_HD];
    }
    if (self.publishResolution_tvos_tablet)
    {
        [result addObject:RESOLUTION_TABLET];
    }
    if (self.publishResolution_tvos_tablethd)
    {
        [result addObject:RESOLUTION_TABLET_HD];
    }
    return result;
}

- (NSString *)publishDirForOSType:(CCBPublisherOSType)osType
{
    NSString *result;

    if (osType == kCCBPublisherOSTypeIOS)
    {
        result = [self publishDirectory];
    }
    if (osType == kCCBPublisherOSTypeTVOS)
    {
        result = [self publishDirectoryAppleTV];
    }
    if (!result)
    {
        NSLog(@"Error: unknown target type: %d", osType);
        return nil;
    }

    return [result absolutePathFromBaseDirPath:[self.projectPath stringByDeletingLastPathComponent]];
}

- (BOOL)publishEnabledForOSType:(CCBPublisherOSType)osType
{
    if (osType == kCCBPublisherOSTypeIOS)
    {
        return self.publishEnabledIOS;
    }
    if (osType == kCCBPublisherOSTypeTVOS)
    {
        return self.publishEnabledTVOS;
    }
    return NO;
}


- (NSInteger)audioQualityForOsType:(CCBPublisherOSType)osType
{
    if (osType == kCCBPublisherOSTypeIOS)
    {
        return self.publishAudioQuality_ios;
    }
    if (osType == kCCBPublisherOSTypeTVOS)
    {
        return self.publishAudioQuality_tvos;
    }
    return DEFAULT_AUDIO_QUALITY;
}

@end