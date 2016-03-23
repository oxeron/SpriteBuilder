//
//  OpenPathsController.m
//  CocosBuilder
//
//  Created by Nicky Weber on 19.11.14.
//
//

#import <Carbon/Carbon.h>
#import "SBOpenPathsController.h"
#import "ProjectSettings.h"
#import "NSAlert+Convenience.h"
#import "MiscConstants.h"
#import "RMPackage.h"
#import "ResourceManager.h"
#import "NotificationNames.h"

static NSString *const KEY_TYPE = @"type";
static NSString *const KEY_PACKAGE = @"package";
static NSString *const KEY_APP = @"app";
static NSString *const KEY_SELECTOR = @"selector";
static NSString *const KEY_TITLE = @"title";
static NSString *const KEYWORD_SEPARATOR = @"Separator";
static NSString *const OPENPATHS_SCRIPT_NAME = @"OpenPaths.scpt";

typedef enum
{
    SBOpenPathTypeProject = 0,
    SBOpenPathTypePublishIOS,
    SBOpenPathTypePublishPackage
} SBOpenPathType;


@interface SBOpenPathsController ()

@property (nonatomic, strong) NSArray *additionalAppsToOpenPaths;
@property (nonatomic, strong) NSMutableArray *packageMenuItems;
@property (nonatomic, strong) NSMutableDictionary *installedApps;
@property (nonatomic, strong) NSMenu *menu;
@property (nonatomic) BOOL userScriptInstalled;

@end


@implementation SBOpenPathsController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.additionalAppsToOpenPaths = @[@"iTerm2"];

        self.packageMenuItems = [NSMutableArray array];
        self.installedApps = [NSMutableDictionary dictionary];
        self.userScriptInstalled = [self isUserScriptInstalled];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenuItemsForPackages) name:RESOURCE_PATHS_CHANGED object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)populateOpenPathsMenuItems
{
    self.menu = [[NSMenu alloc] initWithTitle:@"Open Paths"];

    [self addMenuItemsToOpenPathsMenuWithTitle:@"Project Folder" representedObject:@{KEY_TYPE : @(SBOpenPathTypeProject)}];
    [self addMenuItemsToOpenPathsMenuWithTitle:@"iOS Publish Folder" representedObject:@{KEY_TYPE : @(SBOpenPathTypePublishIOS)}];
    [self addSeparator];
    [self updateMenuItemsForPackages];

    [_openPathsMenuItem setSubmenu:_menu];
}

- (void)addSeparator
{
    NSMenuItem *item = [NSMenuItem separatorItem];
    [_menu addItem:item];
}

- (void)updateMenuItemsForPackages
{
    [self removeAllPackageSubmenus];

    [self addPackagesSubmenus];
}

- (void)addPackagesSubmenus
{
    for (RMPackage *package in [[ResourceManager sharedManager] allPackages])
    {
        NSMenuItem *item2 = [self addMenuItemsToOpenPathsMenuWithTitle:package.name
                                                     representedObject:@{KEY_TYPE : @(SBOpenPathTypePublishPackage), KEY_PACKAGE : package}];

        [_packageMenuItems addObject:item2];
    }
}

- (void)removeAllPackageSubmenus
{
    for (NSMenuItem *packageSubmenu in _packageMenuItems)
    {
        NSInteger index = [_menu indexOfItem:packageSubmenu];
        if (index != -1)
        {
            [_menu removeItem:packageSubmenu];
        }
    }
}

- (NSMenuItem *)addMenuItemsToOpenPathsMenuWithTitle:(NSString *)title representedObject:(NSDictionary *)representedObject
{
    NSMenuItem *folderItem = [[NSMenuItem alloc] init];
    folderItem.title = title;

    NSMenu *menu = [[NSMenu alloc] initWithTitle:title];
    [folderItem setSubmenu:menu];

    [_menu addItem:folderItem];

    NSArray *titleSelectorPairs = [self createMenuEntryDataList];

    for (NSDictionary *entry in titleSelectorPairs)
    {
        NSMenuItem *item;
        if ([entry[KEY_TITLE] isEqualToString:KEYWORD_SEPARATOR])
        {
            item = [NSMenuItem separatorItem];
        }
        else
        {
            item = [[NSMenuItem alloc] initWithTitle:entry[KEY_TITLE]
                                              action:NSSelectorFromString(entry[KEY_SELECTOR])
                                       keyEquivalent:@""];

            NSMutableDictionary *representeObjectCopy = [representedObject mutableCopy];

            if (entry[KEY_APP])
            {
                representeObjectCopy[KEY_APP] = entry[KEY_APP];
            }

            item.representedObject = representeObjectCopy;
            item.target = self;
        }

        [menu addItem:item];
    }

    return folderItem;
}

- (NSArray *)createMenuEntryDataList
{
    NSMutableArray *result = [@[
        @{KEY_TITLE : @"Copy to Clipboard", KEY_SELECTOR : @"copyToClipboard:"},
        @{KEY_TITLE : KEYWORD_SEPARATOR},
        @{KEY_TITLE : @"Open in Finder", KEY_SELECTOR : @"openInFinder:"},
        @{KEY_TITLE : @"Open in Terminal", KEY_SELECTOR : @"openPathInApp:", KEY_APP : @"Terminal"}
    ] mutableCopy];

    for (NSString *appToAddToList in _additionalAppsToOpenPaths)
    {
        [self addAppWithNameIfInstalled:appToAddToList toList:result];
    }

    return result;
}

- (void)addAppWithNameIfInstalled:(NSString *)appName toList:(NSMutableArray *)list
{
    if ([self isAppWithNameInApplicationFolder:appName])
    {
        [list addObject:@{
            KEY_TITLE : [NSString stringWithFormat:@"Open in %@", appName],
            KEY_SELECTOR : @"openPathInApp:",
            KEY_APP : appName
        }];
    }
}

- (BOOL)isAppWithNameInApplicationFolder:(NSString *)applicationName
{
    NSNumber *isInstalled = _installedApps[applicationName];
    if (isInstalled)
    {
        return [isInstalled boolValue];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationPathLocalDomain = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSLocalDomainMask, YES) firstObject];

    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:applicationPathLocalDomain error:&error];
    for (NSString *filename in contents)
    {
        if ([[applicationName stringByAppendingPathExtension:@"app"] isEqualToString:filename])
        {
            _installedApps[applicationName] = @YES;
            return YES;
        }
    }

    _installedApps[applicationName] = @NO;
    return NO;
}

- (NSString *)pathForOpenPathType:(id)representedObject
{
    SBOpenPathType type = (SBOpenPathType) [representedObject[KEY_TYPE] integerValue];
    switch (type)
    {
        case SBOpenPathTypeProject:
            return _projectSettings.projectPathDir;

        case SBOpenPathTypePublishIOS:
            return [_projectSettings.projectPathDir stringByAppendingPathComponent:_projectSettings.publishDirectory];

        case SBOpenPathTypePublishPackage:
        {
            RMPackage *package = representedObject[KEY_PACKAGE];
            return package.fullPath;
        }
    }
    return nil;
}

- (void)copyToClipboard:(id)sender
{
    NSString *path = [self pathForOpenPathType:[sender representedObject]];
    if (!path)
    {
        return;
    }

    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:path  forType:NSStringPboardType];
}

- (void)openPathInApp:(id)sender
{
    NSString *path = [self pathForOpenPathType:[sender representedObject]];
    if (!path)
    {
        return;
    }

    if (!_userScriptInstalled)
    {
        [self installScript];
    }

    [self openPath:path withApplication:[sender representedObject][KEY_APP]];
}

- (void)openInFinder:(id)sender
{
    NSString *path = [self pathForOpenPathType:[sender representedObject]];
    if (!path)
    {
        return;
    }

    [[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:@""];
}

- (BOOL)isUserScriptInstalled
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:[self openPathsScriptURL].path];
}

- (void)installScript
{
    NSURL *destinationURL = [self openPathsScriptURL];
     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *sourceURL = [[NSBundle mainBundle] URLForResource:OPENPATHS_SCRIPT_NAME withExtension:nil];
    NSError *error2;
    BOOL success = [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error2];
    if (success)
    {
         self.userScriptInstalled = YES;
    }
    else
    {
         [NSAlert showModalDialogWithTitle:@"Error" message:[NSString stringWithFormat:@"An error occured installing the script. Trying again. Error: %@", error2]];
         if ([error2 code] != NSFileWriteFileExistsError)
         {
             [self performSelector:@selector(installScript) withObject:nil afterDelay:0.0];
         }
    }
}

- (void)openPath:(NSString *)path withApplication:(NSString *)applicationName
{
    NSUserAppleScriptTask *scriptTask = [self scriptTask];
    if (scriptTask)
    {
        NSAppleEventDescriptor *event = [self eventDescriptorForToOpenPath:path withApplicationName:applicationName];
        [scriptTask executeWithAppleEvent:event completionHandler:^(NSAppleEventDescriptor *resultEventDescriptor, NSError *error)
        {
            if (!resultEventDescriptor)
            {
                [NSAlert showModalDialogWithTitle:@"Error" message:[NSString stringWithFormat:@"An error occured opening the path: %@", error]];
            }
        }];
    }
}

- (NSAppleEventDescriptor *)eventDescriptorForToOpenPath:(NSString *)pathToOpen withApplicationName:(NSString *)applicationName
{
    // parameter
    NSAppleEventDescriptor *parameterPath = [NSAppleEventDescriptor descriptorWithString:pathToOpen];
    NSAppleEventDescriptor *parameterApplication = [NSAppleEventDescriptor descriptorWithString:applicationName];
    NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
    [parameters insertDescriptor:parameterApplication atIndex:1];
    [parameters insertDescriptor:parameterPath atIndex:2];

    // target
    ProcessSerialNumber psn = {0, kCurrentProcess};
    NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:&psn length:sizeof(ProcessSerialNumber)];

    // function
    NSAppleEventDescriptor *function = [NSAppleEventDescriptor descriptorWithString:@"openPathInApplication"];

    // event
    NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                             eventID:kASSubroutineEvent
                                                                    targetDescriptor:target
                                                                            returnID:kAutoGenerateReturnID
                                                                       transactionID:kAnyTransactionID];

    [event setParamDescriptor:function forKeyword:keyASSubroutineName];
    [event setParamDescriptor:parameters forKeyword:keyDirectObject];

    return event;
}

- (NSUserAppleScriptTask *)scriptTask
{
    NSUserAppleScriptTask *result = nil;

    NSURL *directoryURL = [self applicationScriptDirectoryURL];
    NSError *error;
    if (directoryURL)
    {
        result = [[NSUserAppleScriptTask alloc] initWithURL:[self openPathsScriptURL] error:&error];
        if (!result)
        {
            if (![self isUserScriptInstalled])
            {
                self.userScriptInstalled = NO;
                [self installScript];
                return nil;
            }
          
            [NSAlert showModalDialogWithTitle:@"Error" message:@"The path could not be opened. Make sure the script has not been altered."];
        }
    }
    else
    {
        [NSAlert showModalDialogWithTitle:@"Error" message:@"No application script folder found. Is CocosBuilder running sandboxed?"];
    }

    return result;
}

- (NSURL *)applicationScriptDirectoryURL
{
    NSError *error;
    NSURL *directoryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory
                                                                 inDomain:NSUserDomainMask
                                                        appropriateForURL:nil
                                                                   create:YES
                                                                    error:&error];

    if (!directoryURL)
    {
        NSLog(@"Error retrieving application script directory: %@", error);
    }

    return directoryURL;
}

- (NSURL *)openPathsScriptURL
{
    return [[self applicationScriptDirectoryURL] URLByAppendingPathComponent:OPENPATHS_SCRIPT_NAME];
}

@end
