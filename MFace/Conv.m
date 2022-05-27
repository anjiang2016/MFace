//
//  Conv.m
//  MFace
//
//  Created by 赵明明 on 2022/5/24.
//

#import "Conv.h"
#import "Matrix.h"
#import "ImageProcess.h"

@implementation Conv
@synthesize _kernel_size;
@synthesize _stride;
@synthesize _filter;
@synthesize _bias;
@synthesize _padding;
@synthesize _in_channel;
@synthesize _out_channel;
@synthesize _input;
@synthesize _output;
@synthesize scope;

- (void) forward{
//- (void) conv4:(float*)filter :(float)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel

    //[ [ImageProcess new] conv4:self._filter :self._bias :self._input.buff :self._output.buff :self._kernel_size :self._kernel_size :self._input.width :self._input.height :self._input.channel :self._output.channel ];
    [[ImageProcess new] torch_conv2d:_filter:_kernel_size:_padding:_stride:_bias:_input.buff :_input.width:_input.height:_input.channel:_output.buff :_output.channel];
}
-(Conv *)init:(int)kernel :(int)stride{
    self._kernel_size = kernel;
    self._stride = stride;
    //random init filter
    int len_filter = self._output.channel*self._input.channel*self._kernel_size*self._kernel_size;
    self._filter = malloc(len_filter*sizeof(float));
    [self random_set:self._filter :len_filter];
    // evevy kernel_size*kernel_size norm,
    [self norm:self._filter :len_filter :self._kernel_size*self._kernel_size];
    
    //random init bias
    self._bias = malloc(self._output.channel*sizeof(float));
    [self random_set:self._bias :self._output.channel];
    return self;
}
-(void )init_weights{
    //random init filter
    int len_filter = self._out_channel*self._in_channel*self._kernel_size*self._kernel_size;
    self._filter = malloc(len_filter*sizeof(float));
    [self random_set:self._filter :len_filter];
    // evevy kernel_size*kernel_size norm,
    [self norm:self._filter :len_filter :self._kernel_size*self._kernel_size];
    
    //random init bias
    self._bias = malloc(self._out_channel*sizeof(float));
    [self zero_set:self._bias :self._out_channel];
}
-(void)load_weights:(float *)farray :(NSDictionary *)dict{
    //net.conv1._filter=farray+[dict[@"model.conv1.weight"] intValue];
    _filter=farray+[dict[[NSString stringWithFormat:@"%@.weight",scope]] intValue];
    //_bias=farray+[dict[[NSString stringWithFormat:@"%@.bias",scope]] intValue];
}
//Conv2d(in_channels, out_channels, kernel_size, stride=1, padding=0, dilation=1, groups=1, bias=True, padding_mode='zeros', device=None, dtype=None)
-(Conv *) torch_Conv2d:(int)inChannel :(int)outChannel :(int)kernel_size :(int)stride :(int)padding :(int)dilation :(int)groups :(NSString*)in_scope :(int)index{
    self._out_channel=outChannel;
    self._in_channel=inChannel;
    self._padding = padding;
    _stride = stride;
    _padding = padding;
    _kernel_size=kernel_size;
    
    if([in_scope containsString:@"downsample"]){
        self.scope = [NSString stringWithFormat:@"%@.%d",in_scope,index];
    }else{
        self.scope = [NSString stringWithFormat:@"%@.conv%d",in_scope,index];
    }
    [self init_weights];
    return self;
}
- (Matrix *) torch_forward:(Matrix *)input{
//- (void) conv4:(float*)filter :(float)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel
    int out_width = (input.width+2*self._padding-self._kernel_size)/self._stride + 1 ;
    int out_height = (input.height+2*self._padding-self._kernel_size)/self._stride + 1 ;
    int out_pixel_number = out_width * out_height * self._out_channel;
    self._output = [[Matrix  new] init:malloc(sizeof(float)*out_pixel_number) :out_width :out_height :self._out_channel ];
    self._input = input;
    
                         
    //[ [ImageProcess new] conv4:self._filter :self._bias :input.buff :self._output.buff :self._kernel_size :self._kernel_size :self._input.width :self._input.height :self._input.channel :self._output.channel ];
    [[ImageProcess new] torch_conv2d:_filter:_kernel_size:_padding:_stride:_bias:_input.buff :_input.width:_input.height:_input.channel:_output.buff :_output.channel];

    return self._output;
}
-(void)free{
    free(self._filter);
    free(self._bias);
    [self._output free];
    
}
@end
