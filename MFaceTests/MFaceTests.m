//
//  MFaceTests.m
//  MFaceTests
//
//  Created by 赵明明 on 2022/5/25.
//

#import <XCTest/XCTest.h>
#import "Net.h"

@interface MFaceTests : XCTestCase

@end

@implementation MFaceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    int width=1;
    int height=1;
    int channel=10;
    int len=width*height*channel;
    Matrix * input = [[Matrix new] init:(float*)malloc(sizeof(float)*len) :width :height :channel];
    NSLog(@"%f",input.buff[0]);
    [[Layer new] random_set:input.buff :len ];
    [[Layer new] norm:input.buff :len :len];
    float sum=[[Layer new] sum:input.buff :len];
    
    XCTAssert(sum==1,@"sum of norm must be 1");

    //input.buff=memset(input.buff,3.0,10*sizeof(float));
    for(int i=0;i<len;i++){
        input.buff[i]=0.5;
    }
    sum=0;
    [input add:input];
    sum=[[Layer new] sum:input.buff :len];
    XCTAssert(sum==len,@"sum=%f of norm must be %d",sum,len);
    
    NSString *model_path=[NSString stringWithFormat:@"model_resnet18_triplet_epoch_586.txt"];
    NSString *path = [[NSBundle mainBundle] pathForResource:model_path ofType:nil];
    NSLog(@"path = %@,%s", path,__FILE__);
    
    NSArray *fileData;
    NSError *error;
        
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    fileData = [[NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error]
                    componentsSeparatedByString:@" "]; // 分割符为空格
        
    //NSLog(@"fileData = %@", fileData);
    // fileData.count();
    unsigned long  count = [fileData count];
    // 因为文件还有最后一行，所以这里把行数减1
    count = count -1;
    for(int i=0;i<count;i++)
    {
        //farray[i]=[[fileData objectAtIndex:i] floatValue];
        NSString *tmp = [fileData objectAtIndex:i];
        NSLog([fileData objectAtIndex:i]);
        NSLog(@"%d",[[fileData objectAtIndex:i+1] intValue]);
        i=i+1+[[fileData objectAtIndex:i+1] floatValue];
        //[[fileData objectAtIndex:i] floatValue];
        //NSLog(@"farray[%d]=%@",i,[fileData objectAtIndex:i]);
    }
    //[NSDictionary dictionaryWithObjects

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        Net *net=[[Net new] torch_init];
        int len=200*200*3;
        Matrix * input = [[Matrix new] init:(float*)malloc(sizeof(float)*len) :200 :200 :3];
        [net passlayer:input];
    }];
}

@end
