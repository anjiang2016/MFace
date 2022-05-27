//
//  loadtxtTests.m
//  MFaceTests
//
//  Created by 赵明明 on 2022/5/26.
//

#import <XCTest/XCTest.h>
#import "model.h"
#import "Net.h"

@interface loadtxtTests : XCTestCase

@end

@implementation loadtxtTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    Net * net = [[Net new] torch_init];
    [net load_weights];
    float * rgbFloatBuf1 = (float*)malloc(256*256*3*sizeof(float));
    rgbFloatBuf1= [[model new] pth2fload:rgbFloatBuf1:[NSString stringWithFormat:@"anc_img.txt"]];
    Matrix * input = [[Matrix alloc] init:rgbFloatBuf1 :256 :256 :3];
    
    // forward the net
    //Matrix * result = [self passlayer:input];
    Matrix * result = [net torch_passlayer:input];
    XCTAssert(result.buff[0]==0.3,@"result[0] must be 0.3,but now is %f",result.buff[0]);
    Matrix * x = net.middle_result[@"faceID"];
    
    XCTAssert(x.buff[0]==0,@" faceid[0] must be 0, but now is %f",x.buff[0]);
    //free(rgbFloatBuf1);
    //[net free];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        Net * net = [[Net new] torch_init];
        [net load_weights];
        float * rgbFloatBuf1 = (float*)malloc(256*256*3*sizeof(float));
        rgbFloatBuf1= [[model new] pth2fload:rgbFloatBuf1:[NSString stringWithFormat:@"anc_img.txt"]];
        Matrix * input = [[Matrix alloc] init:rgbFloatBuf1 :256 :256 :3];
        Matrix * result = [net torch_passlayer:input];
    }];
}

@end
