//
//  Downsample.m
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Downsample.h"

@implementation Downsample
@synthesize  conv1;
@synthesize  bn1;
-(Downsample *)torch_downsample:(int)in_channel:(int)out_channel{
    conv1 = [[Conv new] torch_Conv2d:in_channel:out_channel:1:2:0:0:1];
    bn1 = [[Bn new] torch_bn:out_channel];
    return self;
}
-(Matrix *)torch_forward:(Matrix *)input{
    Matrix * x;
    x=[conv1 torch_forward:input];
    x=[bn1 torch_forward:x];
    return x;
}
-(void)free{
    [conv1 free];
    [bn1 free];
}

@end
