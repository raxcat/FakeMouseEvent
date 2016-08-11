//
//  ViewController.m
//  FakeMouseEvent_Example
//
//  Created by brianliu on 2016/8/1.
//  Copyright © 2016年 raxcat. All rights reserved.
//

#import "ViewController.h"
@import FakeMouseEvent;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)testMove:(id)sender {
    for(int i = 0; i< 100 ; i++){
        [FakeMouse postRelativeMouseMove:NSMakePoint(1, 1)];
    }
    
}
- (IBAction)testDrag:(id)sender {
}

@end
