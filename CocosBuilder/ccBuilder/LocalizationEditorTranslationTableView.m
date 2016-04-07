//
//  LocalizationEditorTranslationTableView.m
//  CocosBuilder
//
//  Created by Viktor on 8/7/13.
//
//

#import "LocalizationEditorTranslationTableView.h"
#import "AppDelegate.h"
#import "LocalizationEditorHandler.h"
#import "LocalizationEditorWindow.h"

@implementation LocalizationEditorTranslationTableView

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
        [alert setMessageText:@"Are you sure you want to delete the selected translation?"];
        [alert setInformativeText:@"If it is used in interface files translations may be broken."];
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Delete"];
        NSInteger result = [alert runModal];
        
        if (result == NSAlertFirstButtonReturn)
        {
            return;
        }
        
        [[AppDelegate appDelegate].localizationEditorHandler.windowController removeTranslationsAtIndexes:[self selectedRowIndexes]];
        
        return;
    }
    
    [super keyDown:theEvent];
}

@end
