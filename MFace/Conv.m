//
//  Conv.m
//  MFace
//
//  Created by 赵明明 on 2022/5/24.
//

#import "Conv.h"
#import "ImageProcess.h"

@implementation Conv
@synthesize _kernel_size;
@synthesize _stride;
@synthesize _filter;
@synthesize _bias;
- (void) forward{
//- (void) conv4:(float*)filter :(float)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel

    [ [ImageProcess new] conv4:self._filter :self._bias :self._input.buff :self._output.buff :self._kernel_size :self._kernel_size :self._input.width :self._input.height :self._input.channel :self._output.channel ];
   
}
-(Conv *)init:(int)kernel :(int)stride{
    self._kernel_size = kernel;
    self._stride = stride;
    //random init filter
    int len_filter = self._output.channel*self._input.channel*self._kernel_size*self._kernel_size;
    self._filter = malloc(len_filter*sizeof(float));
    [self random_set:self._filter :len_filter];
    
    //random init bias
    self._bias = malloc(self._output.channel*sizeof(float));
    [self random_set:self._bias :self._output.channel];
    return self;
}
-(void)free{
    free(self._filter);
    free(self._bias);
}
@end
