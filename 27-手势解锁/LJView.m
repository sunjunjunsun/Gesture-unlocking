//
//  LJView.m
//  27-手势解锁
//
//  Created by 鲁军 on 2021/2/20.
//

#import "LJView.h"
#define kButtonCount 9

@interface LJView ()

@property(nonatomic,strong)NSMutableArray *btns;

//所有需要连线的数组
@property(nonatomic,strong)NSMutableArray *lineBtns;


@property(nonatomic,assign)CGPoint currentPoint;

@end

@implementation LJView

//画线
- (void)drawRect:(CGRect)rect{
    //如果没有需要画线的按钮。那么不需要的执行drawrect 方法
    if(!self.lineBtns.count){
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for(int i=0;i<self.lineBtns.count;++i){
        UIButton *btn =self.lineBtns[i];
        if(i==0){
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
        
    }
    
    //连线到手指的位置
    [path addLineToPoint:self.currentPoint];
    
    [[UIColor whiteColor] set];
    [path setLineWidth:10];
    // 设置连接处的样式
    [path setLineJoinStyle:kCGLineJoinRound];
    //设置头尾的样式
    [path setLineCapStyle:kCGLineCapRound];
    [path stroke];
}

- (NSMutableArray *)lineBtns{
    
    if(!_lineBtns){
        _lineBtns = [NSMutableArray array];
    }
    return _lineBtns;
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *t=touches.anyObject;
    
    //获取手指的位置
    CGPoint p=[t locationInView:t.view];
    self.currentPoint = p;
    
    
    //获取btn
    for(int i=0;i<self.btns.count;++i){
        UIButton *btn = self.btns[i];
        if(CGRectContainsPoint(btn.frame, p)){
            btn.selected = YES;
            
            if(![self.lineBtns containsObject:btn]){
                //添加到需要画线的数组当中
                [self.lineBtns addObject:btn];
            }
            
          
        }
        
    }
    
    //重绘
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

    self.currentPoint = [[self.lineBtns lastObject] center];
    
    [self setNeedsDisplay];
    
    NSString *password = @"";
    
    for(int i=0;i<self.lineBtns.count;++i){
        UIButton *btn =self.lineBtns[i];
        btn.selected = NO;
        btn.enabled = NO;
        
        password = [password stringByAppendingFormat:[NSString stringWithFormat:@"%ld",btn.tag]];
        
    }
    NSLog(@"%@",password);
    if(self.passwordBlock){
        if(self.passwordBlock(password)){
            NSLog(@"正确");
        }else{
            NSLog(@"错误");
        }
    }
    
    [self setUserInteractionEnabled:NO];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUserInteractionEnabled:YES];
        [self clear];
    });
    
}

//清空 恢复到最初始状态
-(void)clear{
    
    for(int i=0;i<self.btns.count;++i){
        UIButton *btn = self.btns[i];
        
        btn.selected = NO;
        btn.enabled = YES;
    }
    
    //清空所有线
    
    [self.lineBtns removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *t=touches.anyObject;
    
    //获取手指的位置
    CGPoint p=[t locationInView:t.view];
    
    //获取btn
    for(int i=0;i<self.btns.count;++i){
        UIButton *btn = self.btns[i];
        if(CGRectContainsPoint(btn.frame, p)){
            btn.selected = YES;
            //添加到需要画线的数组当中
            [self.lineBtns addObject:btn];
        }
        
    }
    
}

- (NSMutableArray *)btns{
    if(!_btns){
        _btns =[NSMutableArray array];
        
    }
    return  _btns;
}


- (void)awakeFromNib{
    for(int i=0;i<kButtonCount;++i){
        UIButton *btn = [[UIButton alloc] init];
       // btn.backgroundColor = [UIColor redColor];
        btn.tag = i;
        [btn setUserInteractionEnabled:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error-2"] forState:UIControlStateDisabled];
        
        
        
        [self addSubview:btn];
        [self.btns addObject:btn];
        
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = 74;
    CGFloat h = w;
    int colCount = 3;
    CGFloat margin =(self.frame.size.width - 3 *w)/4;
    
    
    for(int i=0;i<kButtonCount;++i){
        CGFloat x = (i%colCount)*(margin+w)+margin;
        CGFloat y = (i/colCount)*(margin+w)+margin;
        [self.btns[i] setFrame:CGRectMake(x, y, w, h)];
        
    }
}

@end
