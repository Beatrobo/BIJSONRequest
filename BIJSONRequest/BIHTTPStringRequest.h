#import "BIHTTPRequest.h"


typedef void (^BIHTTPStringRequestCallback)(NSHTTPURLResponse* httpUrlResponse, NSString* body, NSError* connectionError);


@interface BIHTTPStringRequest : BIHTTPRequest

- (void)sendHTTPStringRequestWithCallback:(BIHTTPStringRequestCallback)callback;

@end
