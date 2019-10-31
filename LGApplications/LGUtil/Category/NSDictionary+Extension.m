//
//  UIView+Extension.h
//  FrameWork
//
//  Created by 李刚 on 17/5/9.
//  Copyright (c) 2017年 李刚. All rights reserved.
//


#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
- (NSString*)stringForKey:(NSString*)key
{
    id retObj = @"";

    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)self;
        retObj = [dict valueForKey:key];

        if ([retObj isKindOfClass:[NSNumber class]]) {
            retObj = [retObj stringValue];
        }

        if (![retObj isKindOfClass:[NSString class]]) {
            retObj = [NSString string];
        }
    }
    return retObj;
}

- (int)intForKey:(NSString*)key{
    return [self stringForKey:key].intValue;
}
- (float)floatForKey:(NSString*)key{
    return [self stringForKey:key].floatValue;
}
- (double)doubleForKey:(NSString*)key{
    return [self stringForKey:key].doubleValue;
}


- (NSDictionary *)removeNull{

    // 去除空值
    NSMutableDictionary *dic = self.mutableCopy;
    for (NSString * key in dic.allKeys) {
        id value = [dic valueForKey:key];

        // 字典里包含字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [value removeNull];
            [dic setValue:value forKey:key];
        }

        // 如果是数组
        else if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [value mutableCopy];
            for (int i= 0; i<array.count; i++) {

                // 数组里包含字典
                if ([array[i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = array[i];
                    dic = [dic removeNull];
                    [array replaceObjectAtIndex:i withObject:dic];
                }
                // 如果是空
                else if (array[i] == nil || [array[i] isKindOfClass:[NSNull class]]) {
                    [array replaceObjectAtIndex:i withObject:@""];
                }

            }
            [dic setValue:array forKey:key];
        }

        //
        else if (value == nil || [value isKindOfClass:[NSNull class]]) {
            value = @"";
            [dic setValue:value forKey:key];
        }
    }

    return dic;
}
#if DEBUG

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *desc = [NSMutableString string];
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = (level > 0) ? tabString : @"";
    
    [desc appendString:@"{\n"];
    
    NSArray *allKeys = [self allKeys];
    for (int i = 0; i < allKeys.count; i++)
    {
        id key = allKeys[i];
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]])
        {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
        }
        else if ([obj isKindOfClass:[NSArray class]]
                 || [obj isKindOfClass:[NSDictionary class]]
                 || [obj isKindOfClass:[NSSet class]])
        {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]] :  [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        }
        else if ([obj isKindOfClass:[NSData class]])
        {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil)
            {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]])
                {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, str] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, str];
                }
                else if ([obj isKindOfClass:[NSString class]])
                {
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, result] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, str] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, str];
                    } else {
                        (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                }
            }
        } else {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}

#endif
@end

@implementation NSArray (Extension)
#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *desc = [NSMutableString string];
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = (level > 0) ? tabString : @"";
    
    [desc appendString:@"(\n"];
    
    for (int i = 0; i < self.count; i++)
    {
        id obj = self[i];
        
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]])
        {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, obj] : [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        }
        else if ([obj isKindOfClass:[NSData class]])
        {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil)
            {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]])
                {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
                    
                }
                else if ([obj isKindOfClass:[NSString class]])
                {
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, result] : [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, str] : [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)", tab];
    
    return desc;
}

#endif

@end


@implementation NSSet (Extension)

#if DEBUG

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = (level > 0) ? tabString : @"\t";
    
    [desc appendString:@"{(\n"];
    
    NSArray *tempArray = [self allObjects];
    
    for (int i = 0; i < tempArray.count; i++)
    {
        id obj = tempArray[i];
        
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]])
        {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, obj] : [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        }
        else if ([obj isKindOfClass:[NSData class]])
        {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil)
            {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]])
                {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
                }
                else if ([obj isKindOfClass:[NSString class]])
                {
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, result] : [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, str] : [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)}", tab];
    
    return desc;
}

#endif

@end
