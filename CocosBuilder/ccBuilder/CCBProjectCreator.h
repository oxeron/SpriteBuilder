//
//  CCBProjectCreator.h
//  CocosBuilder
//
//  Created by Viktor on 10/11/13.
//
//

#import "ProjectSettings.h"

@interface CCBProjectCreator : NSObject

- (BOOL) createDefaultProjectAtPath:(NSString*)fileName engine:(CCBTargetEngine)engine programmingLanguage:(CCBProgrammingLanguage)language orientation:(CCBOrientation)orientation;

@end
