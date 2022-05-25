//
//  Block.m
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Block.h"

@implementation Block
@synthesize  conv1;
@synthesize  bn1;
@synthesize  conv2;
@synthesize  bn2;
@synthesize  downsample1;
@synthesize  scope;
-(Block *)torch_block:(int)in_channel :(int)out_channel :(NSString *)in_scope :(int)index{
    scope = [NSString stringWithFormat:@"%@.%d",in_scope,index];
    //torch_Conv2d:(int)inChannel :(int)outChannel :(int)kernel_size :(int)stride :(int)padding :(int)dilation :(int)groups
    self.conv1 = [[Conv new] torch_Conv2d:in_channel:out_channel:3:1:1:0:1:scope:1];
    self.bn1 = [[Bn new] torch_bn:out_channel:scope:1];
    self.conv2 = [[Conv new] torch_Conv2d:out_channel:out_channel:3:1:1:0:1:scope:2];
    self.bn2 = [[Bn new] torch_bn:out_channel:scope:2];
    if(in_channel != out_channel){
        downsample1 = [[Downsample new] torch_downsample:in_channel :out_channel:scope:0];
    }
    return self;
}
-(void)load_weights:(float *)farray :(NSDictionary *)dict{
    [conv1 load_weights:farray :dict];
    [bn1 load_weights:farray :dict];
    [conv2 load_weights:farray :dict];
    [bn2 load_weights:farray :dict];
    [downsample1 load_weights:farray :dict];
}
-(Matrix *)torch_forward:(Matrix *)input{
    Matrix * x;
    Matrix * identity=input;
    x=[self.conv1 torch_forward:input];
    x=[self.bn1 torch_forward:x];
    
    x=[self.conv2 torch_forward:x];
    x=[self.bn2 torch_forward:x];
    if(input.channel != x.channel){
        identity=[downsample1 torch_forward:input];
    }
    return [x add:identity];
}
-(void)free{
    [self.conv1 free];
    [self.conv2 free];
}
@end
