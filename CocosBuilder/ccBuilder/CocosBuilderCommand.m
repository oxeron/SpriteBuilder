//
//  ScriptingBridge.m
//  CocosBuilder
//
//  Created by Oleg Osin on 2/27/14.
//
//

#import "CocosBuilderCommand.h"
#import "AppDelegate.h"

@implementation CocosBuilderCommand

- (id)initWithCommandDescription:(NSScriptCommandDescription *)commandDef
{
    return [super initWithCommandDescription:commandDef];
}

- (id)performDefaultImplementation
{
    [[AppDelegate appDelegate] checkForDirtyDocumentAndPublishAsync:NO];
    return [NSNumber numberWithBool:YES];
}

@end
