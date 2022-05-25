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
-(Block *)torch_block:(int)in_channel :(int)out_channel{
    //torch_Conv2d:(int)inChannel :(int)outChannel :(int)kernel_size :(int)stride :(int)padding :(int)dilation :(int)groups
    self.conv1 = [[Conv new] torch_Conv2d:in_channel:out_channel:3:1:1:0:1];
    self.bn1 = [[Bn new] torch_bn:out_channel];
    self.conv2 = [[Conv new] torch_Conv2d:out_channel:out_channel:3:1:1:0:1];
    self.bn2 = [[Bn new] torch_bn:out_channel];
    if(in_channel != out_channel){
        downsample1 = [[Downsample new] torch_downsample:in_channel :out_channel];
    }
    return self;
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
