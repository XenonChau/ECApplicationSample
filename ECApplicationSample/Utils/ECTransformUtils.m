//
//  ECTransformUtils.m
//  ECApplicationSample
//
//  Created by Xenon Chau on 15/8/3.
//  Copyright (c) 2015年 EasyCoding & Play4Fun. All rights reserved.
//

#import "ECTransformUtils.h"

@implementation ECTransformUtils

+ (NSString *)chineseCapitalForNumber:(NSNumber *)number {
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithDouble:[number doubleValue]];
    NSDecimal decimal = [decimalNumber decimalValue];
    NSDecimal resultDecimal;
    NSDecimalRound(&resultDecimal, &decimal, 2, NSRoundPlain);
    NSDecimalNumber *resultNumber = [[NSDecimalNumber alloc] initWithDecimal:resultDecimal];
    
    NSString *tempString;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"]];
    numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
    tempString = [numberFormatter stringFromNumber:resultNumber];
    
    //大写对照表
    NSDictionary *capitalUntils = @{@"〇": @"零",
                                    @"一": @"壹",
                                    @"二": @"贰",
                                    @"三": @"叁",
                                    @"四": @"肆",
                                    @"五": @"伍",
                                    @"六": @"陆",
                                    @"七": @"柒",
                                    @"八": @"捌",
                                    @"九": @"玖",
                                    @"十": @"拾",
                                    @"百": @"佰",
                                    @"千": @"仟",
                                    @"万": @"万",
                                    @"亿": @"亿",
                                    @"兆": @"兆",
                                    @"京": @"京",
                                    };
    
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < [tempString length]; i++) {
        NSString *digital = [tempString substringWithRange:NSMakeRange(i, 1)];
        if ([digital isEqualToString:@"点"]) {
            [resultString appendString:@"元"];
        }else{
            NSString *capitalDigital = capitalUntils[digital];
            if (![self isNullString:capitalDigital]) {
                [resultString appendString:capitalDigital];
            }else{
                [resultString appendString:digital];
            }
        }
    }
    
    //小数点之后的零头：读法是否要加零？
    if (!([resultString rangeOfString:@"元"].length > 0)) {
        [resultString appendString:@"元整"];
    }else{
        NSArray *tempArray = [resultString componentsSeparatedByString:@"元"];
        NSString *firstString = tempArray[0];
        NSString *secondString = tempArray[1];
        
        NSMutableString *tempString = [NSMutableString string];
        if (![self isNullString:firstString] && ![firstString isEqualToString:@"零"]) {
            [tempString appendFormat:@"%@元",firstString];
        }
        if (![self isNullString:secondString]) {
            if ([secondString length] == 1) {
                [tempString appendFormat:@"%@角",secondString];
            }else if ([secondString length] == 2){
                if ([[secondString substringToIndex:1] isEqualToString:@"零"]) {
                    [tempString appendFormat:@"零%@分",[secondString substringFromIndex:1]];
                }else{
                    [tempString appendFormat:@"%@角",[secondString substringToIndex:1]];
                    [tempString appendFormat:@"%@分",[secondString substringFromIndex:1]];
                }
            }
        }
        resultString = tempString;
    }
    return resultString;
    
}

+ (BOOL)isNullString:(NSString *)string {
    BOOL isNull = [string isKindOfClass:[NSString class]] && ([string length] > 0);
    return !isNull;
}

+ (BOOL)isValidBankCardNumber:(NSString *)cardNumber
{
    /**
     *  银行卡号Luhm校验
     *  Luhm校验规则：16位银行卡号（19位通用）:
     *  1.将未带校验位的 15（或18）位卡号从右依次编号 1 到 15（18），位于奇数位号上的数字乘以 2。
     *  2.将奇位乘积的个十位全部相加，再加上所有偶数位上的数字。
     *  3.将加法和加上校验位能被 10 整除。
     */
    if ([cardNumber length] == 0) {
        return NO;
    }
    //取出最后一个字符
    NSString *lastCharacter = [cardNumber substringFromIndex:[cardNumber length] - 1];
    //取出前15/18个字符
    NSString *preStr = [cardNumber substringToIndex:[cardNumber length] - 1];
    //将前15/18个字符反序加进数组
    NSMutableArray *reverseArr = [NSMutableArray array];
    for (NSUInteger index = [preStr length]; index > 0; index--) {
        [reverseArr addObject:[preStr substringWithRange:NSMakeRange(index - 1, 1)]];
    }
    //奇数位*2的乘积 < 9
    NSMutableArray *evenNumberLessThanNineArray = [NSMutableArray array];
    //奇数位*2的乘积 > 9
    NSMutableArray *evenNumberGreaterThanNineArray = [NSMutableArray array];
    
    //偶数位数组
    NSMutableArray *oddNumberArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [reverseArr count]; index++) {
        if ((index + 1) % 2 == 1) {
            //奇数位
            NSUInteger evenNum = [[reverseArr objectAtIndex:index] integerValue];
            if (evenNum * 2 < 9) {
                [evenNumberLessThanNineArray addObject:[NSString stringWithFormat:@"%ld",(long)(evenNum * 2)]];
            } else {
                [evenNumberGreaterThanNineArray addObject:[NSString stringWithFormat:@"%ld",(long)(evenNum * 2)]];
            }
        } else {
            //偶数位
            [oddNumberArray addObject:[reverseArr objectAtIndex:index]];
        }
    }
    
    // ones-place number in evenNumberGreaterThanNineArray
    NSMutableArray *onesPlaceNumArray = [NSMutableArray array];
    
    // tens-place number in evenNumberGreaterThanNineArray
    NSMutableArray *tensPlaceNumArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [evenNumberGreaterThanNineArray count]; index++) {
        @autoreleasepool {
            NSString *onesPlaceStr = [NSString stringWithFormat:@"%ld",(long)[[evenNumberGreaterThanNineArray objectAtIndex:index] integerValue] % 10];
            NSString *tensPlaceStr = [NSString stringWithFormat:@"%ld",(long)[[evenNumberGreaterThanNineArray objectAtIndex:index] integerValue] / 10];
            [onesPlaceNumArray addObject:onesPlaceStr];
            [tensPlaceNumArray addObject:tensPlaceStr];
        }
    }
    
    NSUInteger sumEvenNum = 0;
    NSUInteger sumOddNum = 0;
    NSUInteger sumOnesPlaceNum = 0;
    NSUInteger sumTensPlaceNum = 0;
    NSUInteger totalAmount = 0;
    
    for (NSUInteger index = 0; index < [evenNumberLessThanNineArray count]; index++) {
        //奇数位*2 < 9数组之和
        sumEvenNum += [[evenNumberLessThanNineArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [oddNumberArray count]; index++) {
        //偶数位之和
        sumOddNum += [[oddNumberArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [onesPlaceNumArray count]; index++) {
        //奇数位*2 > 9数组 个位数之和
        sumOnesPlaceNum += [[onesPlaceNumArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [tensPlaceNumArray count]; index++) {
        //奇数位*2 > 9数组 十位数之和
        sumTensPlaceNum += [[tensPlaceNumArray objectAtIndex:index] integerValue];
    }
    
    //计算总和
    totalAmount = sumEvenNum + sumOddNum + sumOnesPlaceNum + sumTensPlaceNum;
    
    //计算Luhm值
    NSUInteger luhm = totalAmount % 10 == 0 ? 10 : totalAmount % 10;
    
    NSUInteger result = 10 - luhm;
    
    return [lastCharacter integerValue] == result;
}


@end
