//
//  LJView.h
//  27-手势解锁
//
//  Created by 鲁军 on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJView : UIView

@property(nonatomic,copy) BOOL (^passwordBlock)(NSString *);


@end

NS_ASSUME_NONNULL_END
