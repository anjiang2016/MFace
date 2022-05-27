//
//  relu.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "RELU.h"

@implementation RELU

- (void) forward{
    int i=0;
    int input_len=self._input.width*self._input.height*self._input.channel;
    for(i=0;i<input_len;i++){
        if(self._input.buff[i]>0){
            self._output.buff[i]=self._input.buff[i];
        }
        else{
            self._output.buff[i]=0;
        }
    }
}
- (Matrix *) torch_forward:(Matrix *) input{
    int i=0;
    int input_len=input.width*input.height*input.channel;
    for(i=0;i<input_len;i++){
        if(input.buff[i]<0){
            input.buff[i]=0;
        }
    }
    return input;
}

@end
