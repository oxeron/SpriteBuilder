#import <Foundation/Foundation.h>

@interface NSString (Packages)

- (BOOL)hasPackageSuffix;
- (BOOL)hasSpriteBuilderPackageSuffix;
- (NSString *)stringByAppendingPackageSuffix;
@end