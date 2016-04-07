#import <MacTypes.h>
#import "ResourceExportPackageCommand.h"

#import "RMPackage.h"
#import "PackageExporter.h"
#import "ProjectSettings.h"


@implementation ResourceExportPackageCommand

- (void)execute
{
    NSAssert(_windowForModals != nil, @"windowForModals must no be nil, modal sheet can't be attached.");

    id firstResource = _resources.firstObject;

    // Export supports only one package at a time, sorry
    if ([firstResource isKindOfClass:[RMPackage class]])
    {
        NSOpenPanel *openPanel = [self exportPanel];

        [openPanel beginSheetModalForWindow:_windowForModals
                          completionHandler:^(NSInteger result)
        {
            if (result == NSFileHandlingPanelOKButton)
            {
                [self tryToExportPackage:firstResource toPath:openPanel.directoryURL.path];
            }
        }];
    }
}

- (void)tryToExportPackage:(RMPackage *)package toPath:(NSString *)path
{
    PackageExporter *packageExporter = [[PackageExporter alloc] init];
    NSString *fullExportPath = [packageExporter exportPathForPackage:package toDirectoryPath:path];

    if (![self shouldExportPackageIfExistsAtPath:fullExportPath])
    {
        return;
    }

    NSError *error;
    if (![packageExporter exportPackage:package toDirectoryPath:path error:&error])
    {
        [self showAlertWithError:error];
    }
}

- (BOOL)shouldExportPackageIfExistsAtPath:(NSString *)fullExportPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:fullExportPath])
    {
        if ([self askUserToOverwritePackageIfExistAtPath:fullExportPath])
        {
            if (![fileManager removeItemAtPath:fullExportPath error:&error])
            {
                [self showAlertWithError:error];
                return NO;
            }
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void)showAlertWithError:(NSError *)error
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Error"];
    [alert setInformativeText:error.localizedDescription];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (BOOL)askUserToOverwritePackageIfExistAtPath:(NSString *)fullPath
{

    NSAlert *overwriteAlert = [[NSAlert alloc] init];
    [overwriteAlert setMessageText:@"Package Export"];
    [overwriteAlert setInformativeText:@"Package already exists at path, overwrite?"];
    [overwriteAlert addButtonWithTitle:@"No"];
    [overwriteAlert addButtonWithTitle:@"Yes"];

    NSInteger result = [overwriteAlert runModal];

    return result == NSAlertSecondButtonReturn;
}

- (NSOpenPanel *)exportPanel
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];

    [openPanel setCanCreateDirectories:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"Export"];

    return openPanel;
}


#pragma mark - ResourceCommandContextMenuProtocol

+ (NSString *)nameForResources:(NSArray *)resources
{
    return @"Export Package...";
}

+ (BOOL)isValidForSelectedResources:(NSArray *)resources
{
    return ([resources.firstObject isKindOfClass:[RMPackage class]]);
}

@end