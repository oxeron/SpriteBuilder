#import <Foundation/Foundation.h>

@class ProjectSettings;

@interface SpriteBuilderMigrator : NSObject

- (id)initWithProjectSettings:(ProjectSettings *)settings;

- (BOOL)migrate;

@end