//
//  LocalizationEditorLanguageTableView.m
//  CocosBuilder
//
//  Created by Viktor on 8/7/13.
//
//

#import "LocalizationEditorLanguageTableView.h"
#import "AppDelegate.h"
#import "LocalizationEditorHandler.h"
#import "LocalizationEditorWindow.h"

@implementation LocalizationEditorLanguageTableView

- (void) keyDown:(NSEvent *)theEvent
{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter)
    {
        if([self selectedRowIndexes].count == 0)
        {
            NSBeep();
            return;
        }
        
        // Confirm remove of items
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Are you sure you want to delete the selected languages?"];
        [alert setInformativeText:@"You cannot undo this operation, and translations may be lost."];
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Delete"];
        NSInteger result = [alert runModal];
        
        if (result == NSAlertFirstButtonReturn)
        {
            return;
        }
        
        [[AppDelegate appDelegate].localizationEditorHandler.windowController removeLanguagesAtIndexes:[self selectedRowIndexes]];
        
        return;
    }
    
    [super keyDown:theEvent];
}

@end
