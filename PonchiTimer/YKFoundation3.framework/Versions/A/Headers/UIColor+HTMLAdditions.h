//
//  UIColor+HTMLAdditions.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

@interface UIColor (HTMLAdditions)
/*根據 Hex 字串來設定顏色*/
+ (UIColor *)colorWithHexString:(NSString *)hex;

/*根據 HTML 顏色的名字來設定顏色*/
+ (UIColor *)colorWithHTMLName:(NSString *)name;

//依據傳入的色彩單元，再回傳 R G B 的 CGFloat 數值
enum {
    kFNCColorComponetRed = 0,
    kFNCColorComponetGreen,
    kFNCColorComponetBlue
};
typedef NSInteger FNCColorComponet;
//Claass method 猜解 UIColor 成為 color compoment R G B
+(CGFloat)colorComponetFromColor:(UIColor*)aColor inType:(FNCColorComponet)componet;
@end
