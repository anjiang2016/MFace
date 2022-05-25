//
//  Layers.m
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Layers.h"

@implementation Layers
@synthesize b0;
@synthesize b1;
@synthesize scope;

-(Layers *)torch_layers:(int)in_channel :(int)out_channel :(NSString *)in_scope :(int)index{
//torch_block:(int)in_channel :(int)out_channel
    scope=[NSString stringWithFormat:@"%@.layer%d",in_scope,index];
    self.b0= [[Block new] torch_block:in_channel :out_channel :scope :0 ];
    self.b1= [[Block new] torch_block:out_channel :out_channel :scope :1 ];
    return self;
}
-(void)load_weights:(float *)farray :(NSDictionary *)dict{
    [b0 load_weights:farray :dict];
    [b1 load_weights:farray :dict];
    
}
-(Matrix *)torch_forward:(Matrix *)input{
    Matrix * x;
    x = [self.b0 torch_forward:input];
    x = [self.b1 torch_forward:x];
    return x;
}
-(void)free{
    [self.b0 free];
    [self.b1 free];
}
@end
