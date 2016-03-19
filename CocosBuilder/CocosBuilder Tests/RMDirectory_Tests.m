//
//  RMDirectory_Tests.m
//  CocosBuilder
//
//  Created by Nicky Weber on 02.09.14.
//
//

#import <XCTest/XCTest.h>
#import "RMDirectory.h"
#import "FileSystemTestCase.h"
#import "ProjectSettings.h"
#import "RMResource.h"
#import "ResourceTypes.h"
#import "ResourceManager.h"

@interface RMDirectory_Tests : FileSystemTestCase

@property (nonatomic, strong) RMDirectory *directory;
@property (nonatomic, strong) ProjectSettings *projectSettings;
@property (nonatomic, strong) ResourceManager *resourceManager;

@end


@implementation RMDirectory_Tests

- (void)setUp
{
    [super setUp];

    self.projectSettings = [[ProjectSettings alloc] init];

    self.directory = [[RMDirectory alloc] init];
    _directory.dirPath = [self fullPathForFile:@"foo.ccbuilder/packages/baa.ccbpack/folder"];
    _directory.projectSettings = _projectSettings;

    self.resourceManager = [ResourceManager sharedManager];
    [_resourceManager setActiveDirectoriesWithFullReset:@[
            [self fullPathForFile:@"foo.ccbuilder/packages/baa.ccbpack"],
    ]];
}

- (void)testIsDynamicSpriteSheet
{
    RMResource *spriteSheet = [[RMResource alloc] initWithFilePath:[self fullPathForFile:@"foo.ccbuilder/packages/baa.ccbpack/folder"]];
    spriteSheet.type = kCCBResTypeDirectory;
    spriteSheet.data = _directory;

    [_projectSettings addResourcePath:[self fullPathForFile:@"foo.ccbuilder/packages/baa.ccbpack"] error:nil];
    [_projectSettings makeSmartSpriteSheet:spriteSheet];

    XCTAssertTrue([_directory isDynamicSpriteSheet]);
}

@end
