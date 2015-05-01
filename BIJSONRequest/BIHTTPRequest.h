#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, BIHTTPRequestMethod) {
    BIHTTPRequestMethodGET    = 0,
    BIHTTPRequestMethodPOST   = 1,
    BIHTTPRequestMethodPUT    = 2,
    BIHTTPRequestMethodDELETE = 3,
};


typedef void (^BIHTTPRequestCallback)(NSHTTPURLResponse* httpUrlResponse, NSData* body, NSError* connectionError);


@interface BIHTTPRequest : NSObject

@property (nonatomic, copy, readonly) NSURL*               URL;
@property (nonatomic, readonly)       BIHTTPRequestMethod  method;
@property (nonatomic, copy, readonly) NSDictionary*        query;
@property (nonatomic, copy, readonly) NSDictionary*        form;
@property (nonatomic, readonly)       NSMutableURLRequest* URLRequest;
- (instancetype)initWithURLString:(NSString*)URLString method:(BIHTTPRequestMethod)method query:(NSDictionary*)query form:(NSDictionary*)form;

@property (nonatomic) BOOL feedbackNetworkActivityIndicator; // Default is YES. flag for networkActivityIndicator (only iOS)
@property (nonatomic) NSTimeInterval waitAfterConnection;    // Default is 0
@property (nonatomic) NSOperationQueue* requestQueue;        // Default is [[self class] defaultRequestOperationQueue]
@property (nonatomic) dispatch_queue_t  callbackQueue;       // Defautl is main queue

- (void)sendHTTPRequestWithCallback:(BIHTTPRequestCallback)callback;


+ (NSString*)HTTPMethodStringForRequestMethod:(BIHTTPRequestMethod)method;

+ (NSOperationQueue*)defaultRequestOperationQueue;

@end
