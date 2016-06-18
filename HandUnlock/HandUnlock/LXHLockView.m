//
//  LXHLockView.m
//  day6-手势完成解锁功能
//
//  Created by moxuyou on 16/5/19.
//  Copyright © 2016年 moxuyou. All rights reserved.
//

#import "LXHLockView.h"

@interface LXHLockView ()

/** 开始按钮 */
@property (nonatomic , assign)CGPoint startPoint;
/** 手指当前按钮的点 */
@property (nonatomic , assign)CGPoint curPoint;
/** 存储选中按钮数组 */
@property (nonatomic , strong)NSMutableArray *btnArray;

@end
@implementation LXHLockView

- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

//画线
- (void)drawRect:(CGRect)rect {
    if (self.btnArray.count > 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i=0; i<self.btnArray.count; i++) {
            UIButton *btn = self.btnArray[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                [path addLineToPoint:btn.center];
            }        }
        path.lineWidth = 10;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [path addLineToPoint:self.curPoint];
        [[UIColor redColor] set];
        [path stroke];
    }
    
}

//添加手势
- (void)panding:(UIPanGestureRecognizer *)pan
{
    CGPoint panP = [pan locationInView:self];
    self.curPoint = panP;
    //记录开始点.
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = CGPointMake(panP.x, panP.y);
    //记录移动时候经过的btn
    }else if (pan.state == UIGestureRecognizerStateChanged){
        for (UIButton *btn in self.subviews) {
            if (CGRectContainsPoint(btn.frame, panP)) {
                btn.selected = YES;
                if (![self.btnArray containsObject:btn]) {
                    [self.btnArray addObject:btn];
                }
            }
        }
        [self setNeedsDisplay];
    //松开手指的时候还原屏幕
    }else if (pan.state == UIGestureRecognizerStateEnded){
        NSMutableString *str = [NSMutableString string];
        for (UIButton *btn in self.btnArray) {
            [str appendString:[NSString stringWithFormat:@"%ld", btn.tag]];
        }

#warning 此处用于获取用户名密码匹配
        //此处用于获取用户名密码匹配
        if ([str isEqualToString:@"012543"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSucces" object:self];
            
        }
        
        [self.btnArray removeAllObjects];
        for (UIButton *btn in self.subviews) {
            btn.selected = NO;
        }
        [self setNeedsDisplay];
    }
}

//无论是通过Xib还是代码创建都调用初始化方法
- (void)awakeFromNib
{
    [self setUP];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUP];
    }
    return self;
}

- (void)setUP
{
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        btn.frame = [self nineCellWithCol:3 viewWigth:74 viewHeigth:74 space:10 index:i view:self];
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        [self addSubview:btn];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panding:)];
    [self addGestureRecognizer:pan];
    
}


- (CGRect)nineCellWithCol:(NSInteger)col viewWigth:(CGFloat)viewW viewHeigth:(CGFloat)viewH space:(CGFloat)space index:(NSInteger)index view:(UIView *)view
{
    CGFloat jianJuC = (view.frame.size.width - col * viewW) / (col + 1);
    CGFloat jianJuR = jianJuC;
    CGFloat X = (index % col) * (jianJuC + viewW) + jianJuC;
    CGFloat Y = (index / col) * (jianJuR + viewH) + jianJuR;
    
    return CGRectMake(X, Y, viewW, viewH);
}

@end
