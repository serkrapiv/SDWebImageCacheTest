//
//  ViewController.m
//  StubsImageTest
//
//  Created by Sergey Krapivenskiy on 19/09/15.
//  Copyright © 2015 =). All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "OHHTTPStubs.h"

static NSString *TestURL = @"http://www.test.com/myImage.png";
static NSString *BlackImageFileName = @"image1.png";
static NSString *RedImageFileName = @"image2.png";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureStubs];
    [self downloadTestImage];
}

- (void)configureStubs {
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.absoluteString containsString:TestURL];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = OHPathForFile(BlackImageFileName, self.class);
        
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setValue:@"image/png" forKey:@"Content-Type"];
        [headers setValue:@"Sat, 19 Sep 2015 14:40:52 GMT" forKey:@"Last-Modified"];
        [headers setValue:@"Sun, 27 Sep 2015 19:20:00 GMT" forKey:@"Expires"];
        [headers setValue:@"55fd73f4-3e53" forKey:@"ETag"];
        
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200
                                                   headers:headers];
    }];
}

- (void)downloadTestImage {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    static int i = 0;
    
    __weak typeof(self) wSelf = self;
    
    [manager downloadImageWithURL:[NSURL URLWithString:TestURL]
                          options:SDWebImageRefreshCached
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (i > 0) {
             wSelf.rightImage.image = image;
         } else {
             wSelf.leftImage.image = image;
         }
         
         i++;
     }];
}

@end
