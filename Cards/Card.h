//
//  Card.h
//  Cards
//
//  Created by Buffalo Hird on 8/20/12.
//  Copyright (c) 2012 Buffalo Hird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject


@property (nonatomic, strong) NSString *suit;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIImage *image;

@end
