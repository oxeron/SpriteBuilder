#import "ProjectMigrator.h"

#import "ProjectSettings.h"
#import "PackageMigrationController.h"
#import "ResourcePropertiesMigrator.h"
#import "SpriteBuilderMigrator.h"

@interface ProjectMigrator ()

@property (nonatomic, weak) ProjectSettings *projectSettings;

@end


@implementation ProjectMigrator

- (instancetype)initWithProjectSettings:(ProjectSettings *)projectSettings
{
    self = [super init];
    if (self)
    {
        self.projectSettings = projectSettings;
    }

    return self;
}

/**
 *  Different migrations for project
 *
 *  @return NO if migration has occured
 */
- (BOOL)migrate
{
    BOOL result = YES;

    PackageMigrationController *packageMigrationController = [[PackageMigrationController alloc] initWithProjectSettings:_projectSettings];

    ResourcePropertiesMigrator *resourcePropertiesMigrator = [[ResourcePropertiesMigrator alloc] initWithProjectSettings:_projectSettings];
    
    SpriteBuilderMigrator *spriteBuilderMigrator = [[SpriteBuilderMigrator alloc] initWithProjectSettings:_projectSettings];
    
    result = result && [spriteBuilderMigrator migrate];
    // if we migrated from SB, don't need to to the other migrations
    if (!result)
        return NO;
    
    result = result && [packageMigrationController migrate];
    result = result && [resourcePropertiesMigrator migrate];

    return result;
}

@end