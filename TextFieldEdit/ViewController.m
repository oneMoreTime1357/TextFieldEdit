//
//  ViewController.m
//  TextFieldEdit
//
//  Created by YangDan on 16/6/26.
//  Copyright © 2016年 YangDan. All rights reserved.
//

#import "ViewController.h"
#import "CustomTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
//    CustomTextField *customField = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 45) withNum:4];
//    customField.textFont = [UIFont systemFontOfSize:15];
//    customField.textColor = [UIColor redColor];
//    customField.fieldType = TextFieldTypePassword;
//    [self.view addSubview:customField];
    
    
    CustomTextField *custom2 = [[CustomTextField alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 50) withNum:6];
    custom2.textFont = [UIFont systemFontOfSize:17];
    custom2.fieldType = TextFieldTypeDefault;
    [self.view addSubview:custom2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
