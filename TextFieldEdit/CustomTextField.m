//
//  CustomTextField.m
//  TextFieldEdit
//
//  Created by YangDan on 16/6/26.
//  Copyright © 2016年 YangDan. All rights reserved.
//

#import "CustomTextField.h"

#define Space 7

//下标线距离底部高度
#define LineBottomHeight 5
#define LineHeight 2

//密码风格 圆点半径
#define RADIUS 5


@interface NSString (CustomTextField)

@end

@implementation NSString (CustomTextField)

- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size {
    //段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    //字体大小，换行模式
    NSDictionary *attributes = @{NSFontAttributeName : font , NSParagraphStyleAttributeName : style};
    CGSize resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return resultSize;
}

@end

@interface CustomTextField ()
{
    NSObject *observer;  //添加监听对象
}
@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)NSMutableArray *textArray;
@property (nonatomic,assign)NSInteger num;

@property (nonatomic,assign)NSInteger defaultX;
@property (nonatomic,strong)NSMutableArray *defaultViews;

@property (nonatomic,assign)NSInteger width;


@end


@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        self.num = num;
        self.width = self.frame.size.height;
        self.textArray = [NSMutableArray arrayWithCapacity:num];
        self.defaultX = (frame.size.width - (num - 1) * Space - num * self.width) / 2 ;
        
        //单击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
        [self addGestureRecognizer:tapGesture];
        
        [self addDefaultView];
        
    }
    return self;
}


- (void)addDefaultView {
    
    for (NSInteger i = 0; i < self.num; i ++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        line.fillColor = [UIColor clearColor].CGColor;
        line.strokeColor = ( i == 0?[UIColor blueColor].CGColor:[UIColor grayColor].CGColor);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.defaultX + Space * i + _width * i, 0, _width, _width) cornerRadius:4];
        line.path = path.CGPath;
        line.hidden = NO;
        [self.layer addSublayer:line];
        [self.defaultViews addObject:line];
    }
}



- (void)beginEdit {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.hidden = YES;
        [self addSubview:_textField];
    }
    
    [self addNotification];
    [self.textField becomeFirstResponder];      //弹出键盘
    
}

- (void)addNotification {
    
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        NSInteger length = _textField.text.length;
        if (length == _num && self.EndEditBlcok) {
            self.EndEditBlcok(_textField.text);
            [self endEdit];
        }
        
        if (length <= _num) {
            if (length > _textArray.count) {
                [_textArray addObject:[_textField.text substringWithRange:NSMakeRange(length - 1, 1)]];
            } else {
                [_textArray removeLastObject];
            }
            //标记为需要重绘
            [self setNeedsDisplay];
        }

        if (_defaultViews.count > 0) {
            //判断底部的view隐藏还是显示
            for (NSInteger i = 0; i < _num; i ++) {
                CAShapeLayer *obj = [_defaultViews objectAtIndex:i];
                if (i < _textArray.count) {
                    obj.strokeColor = [UIColor grayColor].CGColor;
                }
                else if (i == _textArray.count) {
                    obj.strokeColor = [UIColor blueColor].CGColor;
                }
                else if (i > _textArray.count) {
                    obj.strokeColor = [UIColor grayColor].CGColor;
                }
            }
        }

        
        
    }];
    
    
}

- (void)endEdit {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    [self.textField resignFirstResponder];
}


- (void)drawRect:(CGRect)rect {
    
    switch (_fieldType) {
            
        case TextFieldTypeDefault:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < _textArray.count; i ++) {
                NSString *num = _textArray[i];
                CGFloat wordWidth = [num stringSizeWithFont:_textFont Size:CGSizeMake(MAXFLOAT, _textFont.lineHeight)].width;
                //起点
                CGFloat startX = self.defaultX + Space * i + _width * i + (_width - wordWidth)/2;
                
                [num drawInRect:CGRectMake(startX, (self.frame.size.height - _textFont.lineHeight - LineBottomHeight - LineHeight)/2, wordWidth,  _textFont.lineHeight + 5) withAttributes:@{NSFontAttributeName:_textFont,NSForegroundColorAttributeName:[UIColor blackColor]}];
            }
            
            CGContextDrawPath(context, kCGPathFill);
            
            
        }
            break;
        case TextFieldTypePassword:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < _textArray.count; i ++) {
                //圆点
                CGFloat pointX = _defaultX + (_width + Space) * i + _width / 2 ; //self.frame.size.width/_num/2 * (2 * i + 1);
                CGFloat pointY = self.frame.size.height/2;
                CGContextAddArc(context, pointX, pointY, RADIUS, 0, 2*M_PI, 0);//添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
            }
            CGContextDrawPath(context, kCGPathFill);
            
        }
            break;
        default:
            break;
    }
    

    
}




- (NSMutableArray *)textArray {
	if(_textArray == nil) {
		_textArray = [[NSMutableArray alloc] init];
	}
	return _textArray;
}

- (NSMutableArray *)defaultViews {
	if(_defaultViews == nil) {
		_defaultViews = [[NSMutableArray alloc] init];
	}
	return _defaultViews;
}

@end
