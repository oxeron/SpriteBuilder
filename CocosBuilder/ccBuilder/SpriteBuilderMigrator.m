#import <MacTypes.h>
#import "SpriteBuilderMigrator.h"
#import "ProjectSettings.h"
#import "NSString+Packages.h"
#import "NSAlert+Convenience.h"
#import "MoveFileCommand.h"

typedef enum
{
    MigrationActionNothingToDo = 0,
    MigrationActionMigrate,
    MigrationActionDontAskAgain,
} MigrationAction;

NSString *const SPRITEBUILDER_LOG_HASHTAG = @"#SpriteBuilderMigration";
static NSString *const BASE_SPRITEBUILDER_BACKUP_NAME = @"cocosbuilderBackup";

@interface SpriteBuilderMigrator ()

@property (nonatomic, strong) ProjectSettings *projectSettings;
@property (nonatomic, copy) NSString *backupFolderPath;

@end

@implementation SpriteBuilderMigrator

- (instancetype)initWithProjectSettings:(ProjectSettings *)projectSettings
{
    NSAssert(projectSettings != nil, @"ProjectSettings must be set");

    self = [super init];
    if (self)
    {
        self.projectSettings = projectSettings;
        self.backupFolderPath = [self projectBackupFolderPath:_projectSettings.projectPathDir];
    }

    return self;
}

- (BOOL)migrate
{
    if (_projectSettings.excludedFromSpriteBuilderMigration
        || [self needsMigration])
    {
        return YES;
    }

    MigrationAction action = [self showPreMigrationDialog];
    if (action == MigrationActionNothingToDo)
    {
        return YES;
    }
    
    if (action == MigrationActionNothingToDo)
    {
        return YES;
    }
    if (action == MigrationActionDontAskAgain)
    {
        _projectSettings.excludedFromSpriteBuilderMigration = YES;
        return YES;
    }
    
    [self logMigrationStep:@"Starting..."];
    
    return [self tryToMigrate];
}

- (BOOL)needsMigration
{
    for (NSMutableDictionary *dict in _projectSettings.resourcePaths)
    {
        NSString *fullPath = [_projectSettings fullPathForResourcePathDict:dict];
        NSLog(@"Check if %@ has SB suffix",fullPath);
        if ([fullPath hasSpriteBuilderPackageSuffix])
        {
            return NO;
        }
    }
    return YES;
}

- (MigrationAction)showPreMigrationDialog
{
    NSString *text = @"You are opening a SpriteBuilder project.\nCocosBuilder can try to migrate your current project.\nHere is a list of what will be done:\n"
    "- backup your current project\n"
    "- rename .sbpack files to .ccbpack\n"
    "- rename .ccbLang files to .ccblang\n"
    "- move libs/cocos2d-iphone to libs/cocos2d-objc\n"
    "- modify cocos2d path in your XCode project to libs/cocos2d-objc\n"
    "- move project.spritebuilder to project.cocosbuilder\n\n"
    "If you choose to upgrade your cocos2d version, you'll have to make some modifications in your XCode project, CocosBuilder won't do this step for you.";
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"SpriteBuilder Project Migration"];
    [alert setInformativeText:text];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert addButtonWithTitle:@"No, don't ask again"];
    
    NSInteger returnValue = [alert runModal];
    switch (returnValue)
    {
        case NSAlertFirstButtonReturn: return MigrationActionMigrate;
        case NSAlertSecondButtonReturn: return MigrationActionNothingToDo;
        case NSAlertThirdButtonReturn: return MigrationActionDontAskAgain;
        default: return MigrationActionNothingToDo;
    }
}

#pragma mark -
#pragma mark File management

- (BOOL)tryToMigrate
{
    NSError *error;
    
    // 0. backup
    if (![self copyProjectToBackupFolder:&error])
    {
        [self alertIfErrorOccured:error rollback:NO];
        return YES;
    }
    
    // 1. rename .sbpack files to .ccbpack
    for (NSMutableDictionary *dict in _projectSettings.resourcePaths)
    {
        //fullPath	@"/Volumes/ExtRaid1/CocosBuilder/SpriteBuilder migration/SB.spritebuilder/Packages/SpriteBuilder Resources.sbpack"
        NSString *fullPath = [_projectSettings fullPathForResourcePathDict:dict];
        NSString *newPath = [[fullPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"ccbpack"];
        [self moveFileAtPath:fullPath toPath:newPath error:&error];
        
        [_projectSettings removeResourcePath:fullPath error:&error];
        [self alertIfErrorOccured:error rollback:YES];
        
        [_projectSettings addResourcePath:newPath error:&error];
        [self alertIfErrorOccured:error rollback:YES];
        
        // 2. rename .ccbLang files to .ccblang in this ccbpack if exists
        NSString* oldLangFile = [newPath stringByAppendingPathComponent:@"Strings.ccbLang"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:oldLangFile])
        {
            NSString* newLangFile = [newPath stringByAppendingPathComponent:@"Strings.ccblang"];
            [self moveFileAtPath:oldLangFile toPath:newLangFile error:&error];
        }
    }
    [_projectSettings store];
    
    // 3. rename libs/cocos2d-iphone to libs/cocos2d-objc
    NSString* oldCocos2dPath = [_projectSettings.projectPathDir stringByAppendingPathComponent:@"Source/libs/cocos2d-iphone"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldCocos2dPath])
    {
        NSString* newCocos2dPath = [_projectSettings.projectPathDir stringByAppendingPathComponent:@"Source/libs/cocos2d-objc"];
        [self moveFileAtPath:oldCocos2dPath toPath:newCocos2dPath error:&error];
    }
    else
    {
        [self logMigrationStep:@"#Cocos2d directory not found in directory %@", oldCocos2dPath];
    }
    
    // 4. modify cocos2d path in your XCode project to libs/cocos2d-objc
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *directoryURL = [[NSURL alloc] initFileURLWithPath:_projectSettings.projectPathDir];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             [self logMigrationStep:@"#NSFileManager error %@", error.localizedDescription];
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    
    for (NSURL *url in enumerator) {
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // only log error, can still go on
            [self logMigrationStep:@"#NSFileManager error %@", error.localizedDescription];
        }
        else if (![isDirectory boolValue]) {
            // No error and it’s not a directory; replace in file
            [self setName:@"libs/cocos2d-objc" inFile:url.path search:@"libs/cocos2d-iphone"];
        }
    }
    
    // 5. rename project.spritebuilder to project.cocosbuilder
    NSString *newProjectPath = [[_projectSettings.projectPathDir stringByDeletingPathExtension] stringByAppendingPathExtension:@"ccbuilder"];
    [self moveFileAtPath:_projectSettings.projectPathDir toPath:newProjectPath error:&error];
    
    if (error)
    {
        //[NSAlert showModalDialogWithTitle:@"Error migrating" htmlBodyText:error.localizedDescription];
        return YES;
    }
    
    [self logMigrationStep:@"Finished"];
        
    // don't remove backup if user wants to revert
    
    // warn user
    NSAlert *alert = [[NSAlert alloc] init];
    alert.informativeText = [NSString stringWithFormat:@"Your project has been successfully imported. CocosBuilder will now reload your project and may ask you to upgrade your cocos2d version.\nIf you do, you will have to modify your XCode propject.\nYou can delete the backup folder %@ if you want.",[[_projectSettings.projectPathDir stringByAppendingPathExtension:BASE_SPRITEBUILDER_BACKUP_NAME] lastPathComponent]];
    alert.messageText = @"SpriteBuilder Project Migration ";
    [alert addButtonWithTitle:@"Reload project"];
    [alert runModal];
    
    return NO;
}

- (BOOL)moveFileAtPath:(NSString *)fromPath toPath:(NSString *)toPath error:(NSError**)error
{
    MoveFileCommand *moveFileCommand = [[MoveFileCommand alloc] initWithFromPath:fromPath toPath:toPath];
    
    [self logMigrationStep:@"#Filesystem %@", [moveFileCommand description]];
    
    BOOL success = [moveFileCommand execute:error];
    if (!success)
    {
        [self logMigrationStep:@"#error %@ - %@", [moveFileCommand description], *error];
    }
    
    [self alertIfErrorOccured:*error rollback:YES];
    
    return success;
}

- (void) setName:(NSString*)name inFile:(NSString*)fileName search:(NSString*)searchStr
{
    NSMutableData *fileData = [NSMutableData dataWithContentsOfFile:fileName];
    NSData *search = [searchStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *replacement = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSRange found;
    do {
        found = [fileData rangeOfData:search options:0 range:NSMakeRange(0, [fileData length])];
        if (found.location != NSNotFound)
        {
            [fileData replaceBytesInRange:found withBytes:[replacement bytes] length:[replacement length]];
        }
    } while (found.location != NSNotFound && found.length > 0);
    [fileData writeToFile:fileName atomically:YES];
}

#pragma mark -
#pragma mark Backup

/**
 *  Returns project backup name, alert and quit if folder already exists
 *
 *  @param projectPath
 *
 *  @return
 */
- (NSString *)projectBackupFolderPath:(NSString *)projectPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *result = [projectPath stringByAppendingPathExtension:BASE_SPRITEBUILDER_BACKUP_NAME];
    
    if ([fileManager fileExistsAtPath:result])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.informativeText = [NSString stringWithFormat:@"Directory %@ already exists.\nPlease remove it and relaunch CocosBuilder.", result];
        alert.messageText = @"Backup directory already exists";
        [alert addButtonWithTitle:@"Quit"];
        NSInteger returnValue = [alert runModal];
        
        switch (returnValue)
        {
            default: [NSApp terminate: nil];
        }
    }
    return result;
}

/**
 *  Copy project.spritebuilder to project.spritebuilder.cocosBuilderBackup
 *
 *  @param error
 *
 *  @return NO if an error occurs during the copy, YES if copy is made
 */
- (BOOL)copyProjectToBackupFolder:(NSError **)error
{
    [self logMigrationStep:@"#Filesystem copying project from \"%@\" to \"%@\"",_projectSettings.projectPathDir, self.backupFolderPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager copyItemAtPath:_projectSettings.projectPathDir
                                       toPath:self.backupFolderPath
                                        error:error];
    if (!result)
    {
        [self logMigrationStep:@"#error could not copy project error: %@",*error];
    }
    return result;
}

/**
 *  Check if an error occured and revert to backup if necessary
 *
 *  @param error
 *  @param rollback
 */
-(void) alertIfErrorOccured:(NSError*) error rollback:(BOOL) rollback
{
    if (error)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.informativeText = [NSString stringWithFormat:@"CocosBuilder encountered an error while migrating your SpriteBuilder project : %@\nCocosBuilder will restore your project from backup", error.localizedDescription];
        alert.messageText = @"Error during SpriteBuilder migration";
        [alert addButtonWithTitle:@"Restore project and Quit"];
        NSInteger returnValue = [alert runModal];
        switch (returnValue)
        {
            default: if (rollback) [self rollBack]; [NSApp terminate: nil];
        }
    }
}

/**
 *  Restore project.spritebuilder.cocosBuilderBackup to original project folder name
 */
- (void)rollBack
{
    [self logMigrationStep:@"#rollback"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.backupFolderPath])
    {
        return;
    }
    
    if ([fileManager fileExistsAtPath:_projectSettings.projectPathDir])
    {
        [fileManager removeItemAtPath:_projectSettings.projectPathDir error:nil];
    }
    
    [fileManager moveItemAtPath:self.backupFolderPath toPath:_projectSettings.projectPathDir error:nil];
}

#pragma mark -
# pragma mark Log

- (void)logMigrationStep:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
#ifndef TESTING
    NSLogv([NSString stringWithFormat:@"%@ %@", SPRITEBUILDER_LOG_HASHTAG, format], args);
#endif
    va_end(args);
}

@end