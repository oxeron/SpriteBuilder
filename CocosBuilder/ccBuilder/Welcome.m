/*
 * CocosBuilder: http://www.cocosbuilder.org
 *
 * Copyright (c) 2016 Olivier Pierre
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "Welcome.h"
#import "WelcomeProjectCell.h"
#import "SBUserDefaultsKeys.h"
#import "MainWindow.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MiscConstants.h"

static NSString *const SEARCH_PREDICATE_FORMAT = @"(projectName contains[cd] %@)";

@interface WelcomeProject : NSObject

@property (strong, nonatomic) NSString *projectName;
@property (strong, nonatomic) NSString *projectPath;
@property (strong, nonatomic) NSImage *projectIcon;

@end

@implementation WelcomeProject

@end


@implementation Welcome
{
    NSArray *recentProjects;
    NSArray *recentProjectsSort;
    NSView *activeView;
}

-(void) windowWillLoad
{
    [self reloadProjectList];
}

-(void)windowDidLoad
{
    [super windowDidLoad];

    [self.window makeKeyAndOrderFront:self];
    
    // Languages
    [self.saveDlgLanguagePopup removeAllItems];
    [self.saveDlgLanguagePopup addItemsWithTitles:@[@"Objective-C", @"Swift"]];
    ((NSMenuItem*)self.saveDlgLanguagePopup.itemArray.firstObject).tag = CCBProgrammingLanguageObjectiveC;
    ((NSMenuItem*)self.saveDlgLanguagePopup.itemArray.lastObject).tag = CCBProgrammingLanguageSwift;
    [self updateLanguageHint];
    
    // Orientation
    [self.saveDlgOrientationPopup removeAllItems];
    [self.saveDlgOrientationPopup addItemsWithTitles:@[@"Landscape", @"Portrait"]];
    ((NSMenuItem*)self.saveDlgOrientationPopup.itemArray.firstObject).tag = kCCBOrientationLandscape;
    ((NSMenuItem*)self.saveDlgOrientationPopup.itemArray.lastObject).tag = kCCBOrientationPortrait;
    
    // add target for language nspopupbutton
    [self.saveDlgLanguagePopup setTarget:self];
    self.saveDlgLanguagePopup.action = @selector(updateLanguageHint);

    // add target for project name
    [self.saveDlgProjectName setTarget:self];
    
    // display first view
    [self.fixedSubview addSubview:self.firstView positioned:NSWindowAbove relativeTo:nil];
    activeView = self.firstView;
    
    // styled window
    self.window.opaque = NO;
    self.window.backgroundColor = [NSColor clearColor];
    
    // table delegate
    //self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(tableViewDoubleClick:);
    
    // select first project in list
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    
    // Add close window button to fixed roundedCornerView
    NSButton* closeButton = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:NSTitledWindowMask];
    [closeButton setFrameOrigin:NSMakePoint(5, self.window.frame.size.height - 20)];
    [closeButton setTarget:[AppDelegate appDelegate]];
    [closeButton setAction:@selector(closeWelcomeModal:)];
    [self.roundedCornerView addSubview:closeButton];
}

-(void) reloadProjectList
{
    recentProjects = [[[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PROJECTS] mutableCopy];
    
    if (recentProjects == nil)
    {
        NSLog(@"No RECENT_PROJECTS in NSUserDefaults");
    }

    NSMutableArray *recentProjectsArr = [NSMutableArray array];
    NSMutableArray *recentProjectsThatStillExist = [NSMutableArray array];
    
    for (NSArray *projectAtRow in recentProjects)
    {
        WelcomeProject *welcomeProject = [[WelcomeProject alloc] init];
        welcomeProject.projectName = projectAtRow[0];
        
        NSString *path = projectAtRow[1];
        
        // check if file still exists
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            continue;
        }
        
        // project still exists, add to list
        [recentProjectsThatStillExist addObject:projectAtRow];
        
        welcomeProject.projectPath = path;
        welcomeProject.projectIcon=[NSImage imageNamed:@"ccbproj"];
        [recentProjectsArr addObject:welcomeProject];
    }
    
    // save recent project that still exist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:recentProjectsThatStillExist forKey:RECENT_PROJECTS];
    
    // apply filter
    NSString *searchText = self.searchField.stringValue;
    NSMutableArray* predicates = [[NSMutableArray alloc] initWithCapacity:3];
    if (searchText.length > 0) {
        [predicates addObject:[NSPredicate predicateWithFormat:SEARCH_PREDICATE_FORMAT, searchText, searchText]];
    }
    recentProjectsSort = [recentProjectsArr filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
    
    // let's reverse order to display most recent projects first
    recentProjectsSort = [[recentProjectsSort reverseObjectEnumerator] allObjects];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return recentProjectsSort.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    WelcomeProjectCell *cell =  [tableView makeViewWithIdentifier:@"NameCellID" owner:self];
    WelcomeProject *welcomeProject = recentProjectsSort[row];
    cell.projectName = welcomeProject.projectName;
    cell.projectPath = welcomeProject.projectPath;
    cell.projectIcon = welcomeProject.projectIcon;

    return cell;
}

// TODO: change selected row color
/*
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    NSTableRowView *row= [aTableView rowViewAtRow:rowIndex makeIfNecessary:NO];
    row.backgroundColor = [NSColor lightGrayColor];
    return YES;
}
*/

#pragma mark - Actions

-(void) tableViewDoubleClick:(id)sender
{
    // get clicked row index
    int rowIndex = [self.tableView clickedRow];
    
    // get project path
    WelcomeProject *welcomeProject = [recentProjectsSort objectAtIndex:rowIndex];
    [[AppDelegate appDelegate] openProject:welcomeProject.projectPath];
    
    // TODO: check if project opened before closing modal
    [[AppDelegate appDelegate] closeWelcomeModalAndDisplayEditor:sender];
}

-(IBAction)newCocosBuilderProject:(id)sender
{
    [self switchView:self.secondView direction:kCATransitionFromRight];
}

-(void) switchView:(NSView*) view direction:(NSString*) transitionDirection
{
    // set direction
    CATransition *animation = [CATransition animation];
    [animation setDuration: 0.3];
    [animation setType: kCATransitionPush];
    [animation setSubtype: transitionDirection];
    [animation setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.fixedSubview layer] addAnimation: animation forKey:kCATransition];
    
    // switch view
    [self.fixedSubview setHidden: NO];
    activeView.hidden = YES;
    view.hidden = NO;
    [self.fixedSubview  addSubview:view];
    activeView = view;
}

-(IBAction)cancel:(id)sender
{
    [self switchView:self.firstView direction:kCATransitionFromLeft];
}

-(IBAction)openAnotherCocosBuilderProject:(id)sender
{
    // Create the File Open Dialog
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    
    NSArray *allowedFileTypes = @[FOLDER_NAME_SUFFIX, PACKAGE_NAME_SUFFIX, PROJECT_NAME_SUFFIX];
    [openDlg setAllowedFileTypes:allowedFileTypes];
    [openDlg setAllowsMultipleSelection:NO];
    
    [openDlg beginSheetModalForWindow:self.window completionHandler:^(NSInteger result)
     {
         if (result == NSModalResponseOK)
         {
             NSArray* files = [openDlg URLs];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^
                            {
                                NSString *fileName = [[files objectAtIndex:0] path];
                                
                                [[AppDelegate appDelegate] openProject:fileName];
                                // close modal screen and display main window
                                [[AppDelegate appDelegate] closeWelcomeModalAndDisplayEditor:nil];
                            });
         }
     }];
    
}

-(IBAction)newCocos2dProject:(id)sender
{
    NSLog(@"openNewCocos2dProject");
}

- (IBAction)chooseProjectPath:(id)sender
{
    // Accepted create document, prompt for place for file
    NSSavePanel* saveDlg = [NSSavePanel savePanel];
    [saveDlg setNameFieldStringValue:self.saveDlgProjectName.title];
    [saveDlg setAllowedFileTypes:[NSArray arrayWithObject:FOLDER_NAME_SUFFIX]];
    
    [saveDlg beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            // loading
            [self.progressIndicatorImg startAnimation:self];
            [self.progressIndicatorImg setHidden:NO];
            [self.progressIndicatorLabel setHidden:NO];
            
            // disable create project button
            self.saveDlgCreateProjectButton.enabled = NO;
             
            // TODO: connect cancel to removeProject
            // TODO: error messages should display in this modal
            // or reset some fields here (loading , etc...)
            
            [[AppDelegate appDelegate] createProjectFromPath:[[saveDlg URL] path] withOrientation:self.saveDlgOrientationPopup.selectedItem.tag andLanguage:self.saveDlgLanguagePopup.selectedItem.tag];
            
        }
    }];
    
}

#pragma mark - NSControlTextEditingDelegate

BOOL hasPressedCommandF(NSEvent *event) {
    return ([event modifierFlags] & NSCommandKeyMask) && [[event characters] characterAtIndex:0] == 'f';
}

- (void)keyDown:(NSEvent *)event {
    if (hasPressedCommandF(event))
        [self.window makeFirstResponder:self.searchField];
    else
        [super keyDown:event];
}

/*
 // search delegate
- (void)controlTextDidChange:(NSNotification *)note {
    [self reloadProjectList];
    [self.tableView reloadData];
}
*/

#pragma mark - Project options

-(void)updateLanguageHint
{
    switch (self.saveDlgLanguagePopup.selectedItem.tag)
    {
        case CCBProgrammingLanguageObjectiveC:
            self.saveDlgLanguageHint.title = @"All supported platforms";
            break;
        case CCBProgrammingLanguageSwift:
            self.saveDlgLanguageHint.title = @"iOS7+ and OSX 10.10+ only";
            break;
        default:
            NSAssert(false, @"Unknown programming language");
            self.saveDlgLanguageHint.title = @"";  // NOTREACHED
            break;
    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    self.saveDlgCreateProjectButton.enabled = ([self.saveDlgProjectName.title length] != 0);
}

@end
