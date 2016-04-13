@class ProjectSettings;
@class CCBWarnings;
@class CCBPublisher;

typedef void (^PublisherFinishBlock)(CCBPublisher *publisher, CCBWarnings *warnings);

typedef enum {
    kCCBPublisherOSTypeHTML5 = 0,
    kCCBPublisherOSTypeIOS = 1,
    kCCBPublisherOSTypeTVOS = 2,
    kCCBPublisherOSTypeNone = 1000,
} CCBPublisherOSType;

typedef enum
{
    kCCBPublishEnvironmentDevelop = 0,
    kCCBPublishEnvironmentRelease = 1,
} CCBPublishEnvironment;

enum {
    kCCBPublishFormatSound_ios_caf = 0,
    kCCBPublishFormatSound_ios_mp4 = 1,
} typedef CCBPublishFormatSound_ios;


enum {
    kCCBPublishFormatSound_tvos_caf = 0,
    kCCBPublishFormatSound_tvos_mp4 = 1
} typedef CCBPublishFormatSound_tvos;