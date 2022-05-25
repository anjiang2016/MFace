//
//  Downsample.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "Conv.h"
#import "Bn.h"

NS_ASSUME_NONNULL_BEGIN

@interface Downsample : NSObject
@property Conv* conv1;
@property Bn* bn1;
@property NSString * scope;
-(Downsample *)torch_downsample:(int)in_channel_ds:(int)out_channel_ds :(NSString*)in_scope :(int)index;
-(Matrix *)torch_forward:(Matrix *)input;
-(void)free;
-(void)load_weights:(float *)farray :(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
