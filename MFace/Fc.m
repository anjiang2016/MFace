//
//  Fc.m
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Fc.h"

@implementation Fc
@synthesize  _out_channel;
@synthesize  _in_channel;
@synthesize  _filter;
@synthesize  _bias;
@synthesize  scope;
-(void)init_weights{
    //random init filter
    int len_filter = self._out_channel*self._in_channel;
    self._filter = malloc(len_filter*sizeof(float));
    [self random_set:self._filter :len_filter];
    // evevy kernel_size*kernel_size norm,
    [self norm:self._filter :len_filter :self._in_channel];
    
    //random init bias
    self._bias = malloc(self._out_channel*sizeof(float));
    [self random_set:self._bias :self._out_channel];
}
-(void)load_weights:(float *)farray :(NSDictionary *)dict{
    //net.conv1._filter=farray+[dict[@"model.conv1.weight"] intValue];
    _filter=farray+[dict[[NSString stringWithFormat:@"%@.weight",scope]] intValue];
    _bias=farray+[dict[[NSString stringWithFormat:@"%@.bias",scope]] intValue];
}
-(Fc *) torch_fc:(int)inChannel :(int)outChannel :(NSString *)in_scope :(int)index{
    scope = [NSString stringWithFormat:@"%@.fc",in_scope];
    self._in_channel=inChannel;
    self._out_channel=outChannel;
    [self init_weights];
    return self;
}
-(Matrix *) torch_forward:(Matrix *)input{
    self._output = [[Matrix  new] init:malloc(sizeof(float)*self._out_channel) :1 :1 :self._out_channel];
    for(int oc=0;oc<self._out_channel;oc++){
        self._output.buff[oc]=0;
        for(int ic=0;ic<self._in_channel;ic++){
            self._output.buff[oc]+=input.buff[ic]*self._filter[ic+oc*self._in_channel];
        }
        self._output.buff[oc]+=self._bias[oc];
        
    }
    [self divice_max:self._output.buff:self._out_channel];
    return self._output;
}
-(void)free{
    free(self._filter);
    free(self._bias);
    [self._output free];
}

@end
