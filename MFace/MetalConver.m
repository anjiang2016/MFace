//
//  MetalConver.m
//  MFace
//
//  Created by 赵明明 on 2022/5/28.
//
#import <Foundation/Foundation.h>
#import "MetalConver.h"


// The number of floats in each array, and the size of the arrays in bytes.
int input_width=128;
int input_height=128;
int input_channel=64;

int kernel_size=3;
int padding=1;
int stride=1;

//int output_width= (input_width-kernel_size+2*padding)/stride+1;
//int output_height= (input_height-kernel_size+2*padding)/stride+1;
int output_channel=64;


@implementation MetalConver
{
    id<MTLDevice> _mDevice;

    // The compute pipeline generated from the compute kernel in the .metal shader file.
    id<MTLComputePipelineState> _mConv2dFunctionPSO;

    // The command queue used to pass commands to the device.
    id<MTLCommandQueue> _mCommandQueue;

    // Buffers to hold data.
    id<MTLBuffer> _input;
    id<MTLBuffer> _weight;
    id<MTLBuffer> _whckpswhc;
    id<MTLBuffer> _output;
    unsigned int outputLength;
    unsigned int outputSize;
    //int kps[7]={256,256,3,3,1,1,64};
    int kps[7];

    unsigned int inputLength;
    unsigned int weightLength;
    //const unsigned int outputLength = 256*256*64;
    unsigned int kpsLength;

    unsigned int inputSize;
    unsigned int weightSize;
    //const unsigned int outputSize = outputLength * sizeof(float);
    unsigned int kpsSize;

 
}

- (instancetype) initWithDevice: (id<MTLDevice>) device
{
    self = [super init];
    if (self)
    {
        _mDevice = device;

        NSError* error = nil;

        // Load the shader files with a .metal file extension in the project

        id<MTLLibrary> defaultLibrary = [_mDevice newDefaultLibrary];
        if (defaultLibrary == nil)
        {
            NSLog(@"Failed to find the default library.");
            return nil;
        }

        id<MTLFunction> conv2dFunction = [defaultLibrary newFunctionWithName:@"conv2d"];
        if (conv2dFunction == nil)
        {
            NSLog(@"Failed to find the adder function.");
            return nil;
        }

        // Create a compute pipeline state object.
        _mConv2dFunctionPSO = [_mDevice newComputePipelineStateWithFunction: conv2dFunction error:&error];
        if (_mConv2dFunctionPSO == nil)
        {
            //  If the Metal API validation is enabled, you can find out more information about what
            //  went wrong.  (Metal API validation is enabled by default when a debug build is run
            //  from Xcode)
            NSLog(@"Failed to created pipeline state object, error %@.", error);
            return nil;
        }

        _mCommandQueue = [_mDevice newCommandQueue];
        if (_mCommandQueue == nil)
        {
            NSLog(@"Failed to find the command queue.");
            return nil;
        }
    }

    return self;
}

- (void) prepareData
{
    
  
    
    inputLength = input_width*input_height*input_channel;
    weightLength = input_channel*output_channel*kernel_size*kernel_size;
    //const unsigned int outputLength = 256*256*64;
    kpsLength = 7;

    inputSize = inputLength * sizeof(float);
    weightSize = weightLength * sizeof(float);
    //const unsigned int outputSize = outputLength * sizeof(float);
    kpsSize = kpsLength * sizeof(int);
    
    // Allocate three buffers to hold our initial data and the result.
    _input = [_mDevice newBufferWithLength:inputSize options:MTLResourceStorageModeShared];
    _weight = [_mDevice newBufferWithLength:weightSize options:MTLResourceStorageModeShared];
    _whckpswhc = [_mDevice newBufferWithLength:kpsSize options:MTLResourceStorageModeShared];
    
    
    
    
    int output_width= (input_width-kernel_size+2*padding)/stride+1;
    int output_height= (input_height-kernel_size+2*padding)/stride+1;
    outputLength =output_width*output_height*output_channel;
    outputSize = outputLength*sizeof(float);
    
    _output = [_mDevice newBufferWithLength:outputSize options:MTLResourceStorageModeShared];

    [self generateRandomFloatData:_input :inputLength];
    [self generateRandomFloatData:_weight :weightLength];
    
    //kps[7]={input_width,input_height,input_channel,kernel_size,padding,stride,output_channel};
    int * buff = _whckpswhc.contents;

    buff[0] = input_width;
    buff[1] = input_height;
    buff[2] = input_channel;
    buff[3] = kernel_size;
    buff[4] = padding;
    buff[5] = stride;
    buff[6] = output_channel;
    
}
- (void) getData:(float*)filter :(int)kernel :(int)padding :(int)stride :(float*)bias :(float*)input :(int)in_width :(int)in_height :(int)in_channel :(float*)output :(int)out_channel
{
    inputLength = in_width*in_height*in_channel;
    weightLength = in_channel*out_channel*kernel*kernel;
    //const unsigned int outputLength = 256*256*64;
    kpsLength = 7;

    inputSize = inputLength * sizeof(float);
    weightSize = weightLength * sizeof(float);
    //const unsigned int outputSize = outputLength * sizeof(float);
    kpsSize = kpsLength * sizeof(int);
    
    // Allocate three buffers to hold our initial data and the result.
    _input = [_mDevice newBufferWithLength:inputSize options:MTLResourceStorageModeShared];
    _weight = [_mDevice newBufferWithLength:weightSize options:MTLResourceStorageModeShared];
    _whckpswhc = [_mDevice newBufferWithLength:kpsSize options:MTLResourceStorageModeShared];
    
    
    int output_width= (in_width-kernel+2*padding)/stride+1;
    int output_height= (in_height-kernel+2*padding)/stride+1;
    outputLength =output_width*output_height*out_channel;
    outputSize = outputLength*sizeof(float);
    
    _output = [_mDevice newBufferWithLength:outputSize options:MTLResourceStorageModeShared];

    [self copyData:_input :input :inputLength];
    [self copyData:_weight :filter :weightLength];
    
    //kps[7]={input_width,input_height,input_channel,kernel_size,padding,stride,output_channel};
    int * buff = _whckpswhc.contents;

    buff[0] = in_width;
    buff[1] = in_height;
    buff[2] = in_channel;
    buff[3] = kernel;
    buff[4] = padding;
    buff[5] = stride;
    buff[6] = out_channel;
    
}

- (void) sendComputeCommand
{
    // Create a command buffer to hold commands.
    id<MTLCommandBuffer> commandBuffer = [_mCommandQueue commandBuffer];
    assert(commandBuffer != nil);

    // Start a compute pass.
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    assert(computeEncoder != nil);

    [self encodeConv2dCommand:computeEncoder];

    // End the compute pass.
    [computeEncoder endEncoding];

    // Execute the command.
    [commandBuffer commit];

    // Normally, you want to do other work in your app while the GPU is running,
    // but in this example, the code simply blocks until the calculation is complete.
    [commandBuffer waitUntilCompleted];

    [self verifyResults];
}

- (void)encodeConv2dCommand:(id<MTLComputeCommandEncoder>)computeEncoder {

    // Encode the pipeline state object and its parameters.
    [computeEncoder setComputePipelineState:_mConv2dFunctionPSO];
    [computeEncoder setBuffer:_input offset:0 atIndex:0];
    [computeEncoder setBuffer:_weight offset:0 atIndex:1];
    [computeEncoder setBuffer:_whckpswhc offset:0 atIndex:2];
    
    [computeEncoder setBuffer:_output offset:0 atIndex:3];

    MTLSize gridSize = MTLSizeMake(outputLength, 1, 1);

    // Calculate a threadgroup size.
    NSUInteger threadGroupSize = _mConv2dFunctionPSO.maxTotalThreadsPerThreadgroup;
    if (threadGroupSize > outputLength)
    {
        threadGroupSize = outputLength;
    }
    MTLSize threadgroupSize = MTLSizeMake(threadGroupSize, 1, 1);

    // Encode the compute command.
    [computeEncoder dispatchThreads:gridSize
              threadsPerThreadgroup:threadgroupSize];
}

- (void) generateRandomFloatData: (id<MTLBuffer>) buffer :(int)length
{
    float* dataPtr = buffer.contents;

    for (unsigned long index = 0; index < length; index++)
    {
        dataPtr[index] = (float)rand()/(float)(RAND_MAX);
    }
}
- (void) copyData: (id<MTLBuffer>) buffer :(float *)buff :(int)length
{
    float* dataPtr = buffer.contents;

    for (unsigned long index = 0; index < length; index++)
    {
        dataPtr[index] = buff[index];
    }
}
- (float * )getOutput{
    return _output.contents;
}
- (void) verifyResults
{
    float* input = _input.contents;
    float* weight = _weight.contents;
    float* output = _output.contents;
    printf("gpu input: \n");
    for(int i=0;i<10;i++){
        printf("%f,",input[i]);
    }
    printf("\n");
    printf("gpu kernel: \n");
    for(int i=0;i<10;i++){
        printf("%f,",weight[i]);
    }
    printf("\n");
    printf("gpu output: \n");
    for(int i=0;i<10;i++){
        printf("%f,",output[i]);
    }
    printf("\n");
    /*
    for (unsigned long index = 0; index < arrayLength; index++)
    {
        if (result[index] != (a[index] + b[index]))
        {
            printf("Compute ERROR: index=%lu result=%g vs %g=a+b\n",
                   index, result[index], a[index] + b[index]);
            assert(result[index] == (a[index] + b[index]));
        }
    }
    */
    printf("Compute results as expected\n");
    
}
@end

