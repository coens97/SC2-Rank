//
//  RankModal.h
//  Starcraft 2 Rank
//
//  Created by Coen on 19/04/14.
//
//

#import <Foundation/Foundation.h>

@interface RankModal : NSObject{
    NSURLConnection *currentConnection;
}
- (void) update;
@property (retain, nonatomic) NSMutableData *data;
@end
