//
//  MOLWeakScriptMessageHandler.h
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol MOLScriptMessageHandler <NSObject>

@optional
- (void)ja_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface MOLWeakScriptMessageHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<MOLScriptMessageHandler> ja_handler;
- (instancetype)initWithHandler:(id<MOLScriptMessageHandler>)ja_handler;
@end
