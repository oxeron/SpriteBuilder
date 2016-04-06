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

//#import <Foundation/Foundation.h>

@interface Welcome : NSWindowController <NSTableViewDelegate, NSTableViewDelegate, NSControlTextEditingDelegate>

@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSSearchField *searchField;
@property (strong) IBOutlet NSTextField *CCBVersion;
@property (strong) IBOutlet NSTextField *CC2dVersion;

@property (assign) IBOutlet NSView *roundedCornerView;
@property (assign) IBOutlet NSView *fixedSubview;
// strong to keep them in memory when switching
@property (strong) IBOutlet NSView *firstView;
@property (strong) IBOutlet NSView *secondView;

@property (assign) IBOutlet NSPopUpButton *saveDlgLanguagePopup;
@property (assign) IBOutlet NSTextFieldCell *saveDlgLanguageHint;
@property (assign) IBOutlet NSPopUpButton *saveDlgOrientationPopup;
@property (assign) IBOutlet NSTextFieldCell *saveDlgProjectName;
@property (assign) IBOutlet NSButton *saveDlgCreateProjectButton;
@property (assign) IBOutlet NSButton *showAtLaunch;

// progress
@property (assign) IBOutlet NSProgressIndicator *progressIndicatorImg;
@property (assign) IBOutlet NSTextField *progressIndicatorLabel;

-(IBAction)newCocosBuilderProject:(id)sender;
-(IBAction)newCocos2dProject:(id)sender;
-(IBAction)openAnotherCocosBuilderProject:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)chooseProjectPath:(id)sender;
-(IBAction)changeShowAtLaunch:(id)sender;

@end

