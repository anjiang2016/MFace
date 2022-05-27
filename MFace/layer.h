//
//  layer.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"
NS_ASSUME_NONNULL_BEGIN

@interface Layer : NSObject

- (void) forward;
-(void)random_set:(float*)buff :(int)bufflen;
-(void)zero_set:(float*)buff :(int)bufflen;
-(void)free;
-(float)sum:(float*)buff :(int)bufflen;
-(void)norm:(float*)buff :(int)bufflen :(int)kernel;
-(void)min_max_norm:(float*)buff :(int)bufflen :(int)norm_len;
-(void)divice_max:(float*)buff :(int)bufflen;
-(void)load_weights:(float *)farray :(NSDictionary *)dict;
-(void)l2_norm:(float*)buff :(int)bufflen;
@property Matrix* _input;
@property Matrix* _output;
@property NSString * scope;
@end

NS_ASSUME_NONNULL_END
