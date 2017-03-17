//
//  CustomTextField.h
//  TextFieldEdit
//
//  Created by YangDan on 16/6/26.
//  Copyright © 2016年 YangDan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,TextFieldType){
    TextFieldTypeDefault,
    TextFieldTypePassword
};

@interface CustomTextField : UIView

- (instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num;

//输入完成回调
@property (nonatomic, copy) void(^EndEditBlcok)(NSString *text);

@property (nonatomic,strong)UIFont *textFont;
@property (nonatomic,strong)UIColor *textColor;

// type type
@property (nonatomic,assign)TextFieldType fieldType;

@end
