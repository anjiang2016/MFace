//
//  convTests.m
//  MFaceTests
//
//  Created by 赵明明 on 2022/5/26.
//

#import <XCTest/XCTest.h>
#import "ImageProcess.h"

@interface convTests : XCTestCase

@end

@implementation convTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float * arr=malloc(9*sizeof(float));
    for(int i=0;i<9;i++){
        arr[i]=6;
    }
    int w=3;
    int h=3;
    //0 1 2
    //3 4 5
    //6 7 8
    
    //[1,2]
    //[x,y]
    int x=0;
    int y=2;
    XCTAssert(arr[w*y+x]==6,@"arr[%d,%d]must be 6,but now is %f",x,y,arr[w*y+x]);
    //torch_conv2d:(float*)filter :(int)kernel :(int)padding :(int)stride :(float*)bias :(float*)input :(int)in_width :(int)in_height :(int)in_channel :(float*)output :(int)out_channel
    int padding=2;
    int stride = 2;
    int kernel=3;
    int in_width=4;
    int in_height=4;
    int in_channel=2;
    int in_len = in_width*in_height*in_channel;
    float *input = malloc(in_len*sizeof(float));
    input=memset(input,1,in_len*sizeof(float));
    for(int i=0;i<in_len;i++){
        input[i]=1.0;
    }
    
    
    int out_width = (in_width-kernel+2*padding)/stride +1;
    int out_height = (in_height-kernel+2*padding)/stride +1;
    int out_channel=2;
    
    int kernel_len=kernel*kernel*in_channel*out_channel;
    float *weight=malloc(sizeof(float)*kernel_len);
    for(int i=0;i<kernel_len;i++){
        weight[i]=1.0;
    }
    float *bias = malloc(out_channel*sizeof(float));
    for(int i=0;i<out_channel;i++){
        bias[i]=(i+1)/10.0;
    }
    
    
    float *output = malloc((out_width*out_height*out_channel)*sizeof(float));
    [[ImageProcess new] torch_conv2d:weight:kernel:padding:stride:bias:input:in_width:in_height:in_channel:output:out_channel];
    XCTAssert(output[out_width*2+2]==4.5,@"out[2,2] must is 8,but out[2,2] = %f",output[out_width*2+2]);
    XCTAssert(output[out_width*out_height*1+ out_width*2+2]==4.5,@"out[2,2,1] must is 4.5,but out[2,2,1] = %f",output[out_width*out_height*1+out_width*2+2]);
    XCTAssert(output[out_width*1+2]==12,@"out[2,1] must is 12,but out[2,1] = %f",output[out_width*1+2]);
    XCTAssert(output[out_width*0+0]==2,@"out[0,0] must is 2,but out[0,0] = %f",output[out_width*0+0]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
