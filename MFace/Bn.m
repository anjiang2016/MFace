//
//  Bn.m
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Bn.h"

@implementation Bn
@synthesize weight;
@synthesize bias;
@synthesize running_mean;
@synthesize running_var;
@synthesize num_batches_tracked;
-(Bn * )init:(int)channel{
    self.weight = malloc(sizeof(float)*channel);
    self.bias = malloc(sizeof(float)*channel);
    [self random_set:self.weight :channel];
    [self random_set:self.bias :channel];
    return self;
}
-(Bn * )torch_bn:(int)channel{
    return [self init:channel];
}
-(Matrix * )torch_forward:(Matrix *)input{
    for(int c=0;c<input.channel;c++){
        for(int i=0;i<input.width*input.height;i++)
        {
            float tmp=input.buff[i+c*input.width*input.width];
            input.buff[i+c*input.width*input.width]=tmp*self.weight[c]+self.bias[c];
        }
    }
    return input;
}
@end
