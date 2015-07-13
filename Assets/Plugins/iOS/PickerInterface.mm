//
//  PickerInterface.mm
//
//
//  Created by VIEWPOINT on 2015. 7. 9..
//
//

#import <Foundation/Foundation.h>
#import "PickerInterface.h"

const char* recevierName = "NativeImagePickerReceiver";
const char* receiverMethod = "OnPick";
const int resizeWidth = 160;
const int resizeHeight = 160;
char* imageData;

@interface PickerDelegate : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property NSString* message;
@end

@implementation PickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* img = info[UIImagePickerControllerOriginalImage];
	
	if(img.size.width != img.size.height)
	{
		double width = CGImageGetWidth(img.CGImage);
		double height = CGImageGetHeight(img.CGImage);
		double squareSide = width > height ? height : width;
		double x = (img.size.width / 2.0f) - (squareSide / 2.0f);
		double y = (img.size.height / 2.0f) - (squareSide / 2.0f);
		CGRect cropRect = CGRectMake(x, y, squareSide, squareSide);
		CGImageRef newImageRef = CGImageCreateWithImageInRect([img CGImage], cropRect);
		img = [UIImage imageWithCGImage:newImageRef];
		CGImageRelease(newImageRef);
	}
	
	// Resize start
	UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, resizeHeight);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [img CGImage]);
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	// Resize end
	
	NSData *d = UIImageJPEGRepresentation(img, 1.0);
	const char* base64String = [[d base64Encoding] UTF8String];
	imageData = (char*)malloc(sizeof(char) * (strlen(base64String) + 1));
	strcpy(imageData, base64String);
	[picker dismissViewControllerAnimated:NO completion:^{
		UnitySendMessage(recevierName, receiverMethod, [self.message UTF8String]);
	}];
}

@end

PickerDelegate* gPickerDelegate;

void NativePick(int callbackNum)
{
	NSString* msg = [NSString stringWithFormat:@"%d", callbackNum];
	
	gPickerDelegate = [[PickerDelegate alloc] init];
	gPickerDelegate.message = msg;
	
	UIImagePickerController* picker = [[UIImagePickerController alloc] init];
	[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	[picker setDelegate:gPickerDelegate];
	[picker setAllowsEditing:NO];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:NO completion:^{
	}];
}

char* NativeGetImageBase64Data()
{
	return imageData;
}