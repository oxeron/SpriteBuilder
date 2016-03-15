//
//  CCNodeTests
//
//  Created by Andy Korth on December 12th, 2013.
//
//

#import <XCTest/XCTest.h>
#import "cocos2d.h"
#import "CCNodeTag.h"

@interface CCNodeTests : XCTestCase

@end


@implementation CCNodeTests


-(void)testGetChildByTag
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 tag:100];
    
    XCTAssertTrue(first == [scene getChildByTag:100 recursively:NO], @"");
    XCTAssertTrue(nil == [scene getChildByTag:200 recursively:NO], @"");
    XCTAssertFalse(first == [first getChildByTag:100 recursively:NO], @"Should not find itself!");
}

-(void)testGetChildByTagRecursive
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 tag:100];
    
    CCNode *second = [CCNode node];
    [first addChild:second z:0 tag:200];
    
    XCTAssertTrue(first == [scene getChildByTag:100 recursively:YES], @"");
    XCTAssertTrue(second == [scene getChildByTag:200 recursively:YES], @"");
    XCTAssertTrue(second == [first getChildByTag:200 recursively:YES], @"");
}


-(void)testGetChildByTagNonRecursive
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 tag:100];
    
    CCNode *second = [CCNode node];
    [first addChild:second z:0 tag:200];
    
    XCTAssertTrue(nil == [scene getChildByTag:200 recursively:NO], @"");
    XCTAssertTrue(second == [first getChildByTag:200 recursively:NO], @"");
}

-(void)testGetChildByName
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 name:@"first"];
    
    XCTAssertTrue(first == [scene getChildByName:@"first" recursively:NO], @"");
    XCTAssertTrue(nil == [scene getChildByName:@"nothing" recursively:NO], @"");
    XCTAssertFalse(first == [first getChildByName:@"first" recursively:NO], @"Should not find itself!");
}

-(void)testGetChildByNameRecursive
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 name:@"first"];
    
    CCNode *second = [CCNode node];
    [first addChild:second z:0 name:@"second"];
    
    XCTAssertTrue(first == [scene getChildByName:@"first" recursively:YES], @"");
    XCTAssertTrue(second == [scene getChildByName:@"second" recursively:YES], @"");
    XCTAssertTrue(second == [first getChildByName:@"second" recursively:YES], @"");
}


-(void)testGetChildByNameNonRecursive
{
    CCScene *scene = [CCScene node];
    
    CCNode *first = [CCNode node];
    [scene addChild:first z:0 name:@"first"];
    
    CCNode *second = [CCNode node];
    [first addChild:second z:0 name:@"second"];
    
    XCTAssertTrue(nil == [scene getChildByName:@"second" recursively:NO], @"");
    XCTAssertTrue(second == [first getChildByName:@"second" recursively:NO], @"");
}

@end