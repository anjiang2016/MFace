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

-(Layers *)torch_layers:(int)in_channel :(int)out_channel{
//torch_block:(int)in_channel :(int)out_channel
    self.b0= [[Block new] torch_block:in_channel :out_channel ];
    self.b1= [[Block new] torch_block:out_channel :out_channel ];
    return self;
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
