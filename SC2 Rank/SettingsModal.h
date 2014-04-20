//
//  SettingsModal.h
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import <Foundation/Foundation.h>

@interface SettingsModal : NSObject
- (NSString*) getUrl;
- (NSInteger) getUpdateTime;

- (void)setUrl:(NSString*)value;
- (void)setUpdateTime:(NSInteger)value;
@end
