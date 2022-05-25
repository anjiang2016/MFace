//
//  Fc.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Layer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Fc : Layer
@property int _out_channel;
@property int _in_channel;
@property float * _filter;
@property float * _bias;
@property NSString * scope;
-(void)init_weights;
-(void)load_weights:(float *)farray :(NSDictionary *)dict;
-(Fc *) torch_fc:(int)inChannel :(int)outChannel :(NSString *)in_scope :(int)index;
-(Matrix *) torch_forward:(Matrix *)input;

@end

NS_ASSUME_NONNULL_END
