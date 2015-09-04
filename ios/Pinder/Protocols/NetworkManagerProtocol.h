//
//  NetworkManagerProtocol.h
//  Pinder
//
//  Created by Henri La on 04/09/15.
//  Copyright (c) 2015 OpenData. All rights reserved.
//

@protocol NetworkManagerProtocol <NSObject>
@required
-(void)didRetrieveResponse:(id)response forRequest:(int)request;
-(void)didFailRetrievingResponse:(NSString *)response forRequest:(int)request;
@end