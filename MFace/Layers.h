//
//  Layers.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "Block.h"

NS_ASSUME_NONNULL_BEGIN

@interface Layers : NSObject
@property Block * b0;
@property Block * b1;
@property NSString * scope;
-(Layers *)torch_layers:(int)in_channel :(int)out_channel :(NSString *)scope :(int)index;
-(Matrix *)torch_forward:(Matrix *)input;
-(void)free;
-(void)load_weights:(float *)farray :(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
