//
//  ViewController.m
//  27-手势解锁
//
//  Created by 鲁军 on 2021/2/20.
//

#import "ViewController.h"
#import "LJView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet LJView *passwordView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];

   self.passwordView.passwordBlock = ^(NSString * pwd) {
        if([pwd isEqualToString:@"123"]){
            NSLog(@"输入密码正确");
            return YES;
        }else
        {
            NSLog(@"输入密码错误");
            return NO;
        }
    };
    
}


@end
