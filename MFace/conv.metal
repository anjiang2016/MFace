//
//  conv.metal
//  MFace
//
//  Created by 赵明明 on 2022/5/28.
//


#include <metal_stdlib>
using namespace metal;
/// This is a Metal Shading Language (MSL) function equivalent to the conv2d() C function, used to perform the calculation on a GPU.
kernel void conv2d(device const float* input,
                       device const float* weight,
                       device const int * whckpsc,
                       device float* output,
                       uint index [[thread_position_in_grid]])
{
    // the for-loop is replaced with a collection of threads, each of which
    // calls this function.
    //result[index] = input[index] + inB[index];
    int input_width=whckpsc[0];
    int input_height=whckpsc[1];
    int input_channel=whckpsc[2];
    int kernel_size=whckpsc[3];
    int padding=whckpsc[4];
    int stride=whckpsc[5];
    // 中心点对应法： 先根据线程号：index，以及输出图片的宽度，计算出当前线程所计算的像素的坐标output_x,output_y
    // 再根据卷积的计算过程，推导出对应的input的坐标：input_x,input_y
    // 以input_x,input_y为中心点，计算卷积
    int output_width=(input_width-kernel_size+2*padding)/stride+1;
    int output_height = (input_height-kernel_size+2*padding)/stride+1;
    int output_channel=whckpsc[6];
    
    int output_current_channel = index/(output_width*output_height);
    int offset_c = index%(output_width*output_height);
    int output_x=offset_c%output_width;
    int output_y=offset_c/output_width;
    int input_x = output_x*stride+kernel_size/2-padding;
    int input_y = output_y*stride+kernel_size/2-padding;
    
    int radus = kernel_size/2;
    output[index]=0.0;
    for(int c=0;c<input_channel;c++){
        for(int i=-radus;i<=radus;i++){
            for(int j=-radus;j<=radus;j++){
                float input_tmp=0;
                if(input_x+i>= 0 && input_y+j>=0 && input_x+i<input_width && input_y+j<input_height ){
                    int input_index =c*(input_width*input_height)+(input_y+j)*input_width + input_x+i;
                    input_tmp = input[input_index];
                }
                output[index]+=input_tmp*weight[ output_current_channel*(input_channel*kernel_size*kernel_size) + c*(kernel_size*kernel_size)+ (j+radus)*kernel_size+i+radus];
            }
        }
    }
}
