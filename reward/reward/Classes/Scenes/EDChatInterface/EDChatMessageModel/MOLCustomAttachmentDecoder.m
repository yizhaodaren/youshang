//
//  MOLCustomAttachmentDecoder.m
//  reward
//
//  Created by moli-2017 on 2018/10/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLCustomAttachmentDecoder.h"
#import "MOLYSHelpMessageModel.h"

@implementation MOLCustomAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict mol_jsonInteger:@"type"];
            NSDictionary *data = [dict mol_jsonDict:@"data"];
            
            switch (type) {
                case 5:
                {
                    MOLYSHelpMessageModel *cusAttachment = [[MOLYSHelpMessageModel alloc] init];
                    cusAttachment.type = [data mol_jsonInteger:@"type"];
                    cusAttachment.typeId = [data mol_jsonString:@"typeId"];
                    cusAttachment.content = [data mol_jsonString:@"content"];
                    attachment = cusAttachment;
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return attachment;
}
@end
