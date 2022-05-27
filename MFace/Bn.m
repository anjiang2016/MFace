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
@synthesize scope;
-(Bn * )init:(int)channel{
    self.weight = malloc(sizeof(float)*channel);
    self.bias = malloc(sizeof(float)*channel);
    [self random_set:self.weight :channel];
    [self random_set:self.bias :channel];
    return self;
}
-(void)load_weights:(float *)farray :(NSDictionary *)dict{
    //net.conv1._filter=farray+[dict[@"model.conv1.weight"] intValue];
    weight=farray+[dict[[NSString stringWithFormat:@"%@.weight",scope]] intValue];
    bias=farray+[dict[[NSString stringWithFormat:@"%@.bias",scope]] intValue];
    running_var=farray+ [ dict[[NSString stringWithFormat:@"%@.running_var",scope]] intValue];
    running_mean=farray+[ dict[[NSString stringWithFormat:@"%@.running_mean",scope]] intValue];
}
-(Bn * )torch_bn:(int)bn_channel :(NSString*)in_scope :(int)index{
    //scope = [NSString stringWithFormat:@"%@.bn%d",in_scope,index];
    if([in_scope containsString:@"downsample"]){
        self.scope = [NSString stringWithFormat:@"%@.%d",in_scope,index];
    }else{
        self.scope = [NSString stringWithFormat:@"%@.bn%d",in_scope,index];
    }
    return [self init:bn_channel];
}
//https://pytorch.org/docs/stable/generated/torch.nn.BatchNorm2d.html#torch.nn.BatchNorm2d
-(Matrix * )torch_forward:(Matrix *)input{
    for(int c=0;c<input.channel;c++){
        for(int i=0;i<input.width*input.height;i++)
        {
            float tmp=input.buff[i+c*input.width*input.width];
            tmp =(tmp-running_mean[c])/sqrt(running_var[c]);
            input.buff[i+c*input.width*input.width]=tmp*weight[c]+bias[c];
        }
    }
    return input;
}
@end
