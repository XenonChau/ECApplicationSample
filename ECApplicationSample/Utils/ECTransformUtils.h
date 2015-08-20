//
//  ECTransformUtils.h
//  ECApplicationSample
//
//  Created by Xenon Chau on 15/8/3.
//  Copyright (c) 2015年 EasyCoding & Play4Fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECTransformUtils : NSObject

+ (NSString *)chineseCapitalForNumber:(NSNumber *)number;

+ (BOOL)isNullString:(NSString *)string;

+ (BOOL)isValidBankCardNumber:(NSString *)cardNumber;


@end
