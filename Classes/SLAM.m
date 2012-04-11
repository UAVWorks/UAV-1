    //
//  SLAM.m
//  UAV
//
//  Created by Lee Sing Jie on 5/8/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "SLAM.h"


@implementation SLAM

@synthesize radarView;
@synthesize imageData;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
	
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    // Use the generic RGB color space.
	//removed sg
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
	
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
	
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
    // per component. Regardless of what the source image format is 
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
	
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
	
    return context;
}
CGImageRef ManipulateImagePixelData(CGContextRef cgctx, CGImageRef inImage, double x, double y, int value)
{
    // context.
    void *data = CGBitmapContextGetData (cgctx);
    if (data != NULL)
    {
		
		unsigned char *dataChar = data;
		
		int i = (int)x*4*SLAMMAXRESOLUTIONLIMIT + (int)y*4;
		
		//int increment = 50;
		if (dataChar[i+3] < 255) {
			dataChar[i+3]++;
		}
		
		if (value >= dataChar[i+3]) {
			dataChar[i+1] = 0;
			dataChar[i+2] = 0;
		} else if (value < dataChar[i+3]) {
			if (50*(dataChar[i+3]-value) < 255) {
				dataChar[i+1] = 50*(dataChar[i+3]-value);
			} else {
				dataChar[i+1] = 50*5;
			}
			
			dataChar[i+2] = 255;
		}

		
	/*	dataChar[i] = dataChar[i]; //alpha
		if (dataChar[i+1] < 255-increment) {
			dataChar[i+1] = dataChar[i+1]+increment; //intensify red
		} */
		
		
		
    }
	
	
	
	CGImageRef returnImage = CGBitmapContextCreateImage(cgctx);

    // When finished, release the context
    //CGContextRelease(cgctx); 
    // Free image data memory for the context
   /* if (data)
    {
        free(data);
    }*/
	return returnImage;
	
}
CGImageRef ClearImagePixelData(CGContextRef cgctx){
	// context.
    void *data = CGBitmapContextGetData (cgctx);
    if (data != NULL)
    {
		unsigned char *dataChar = data;

		for (int i=0; i<SLAMMAXRESOLUTIONLIMIT*SLAMMAXRESOLUTIONLIMIT*4; i+=4) {
			dataChar[i+0] = 255;
			dataChar[i+1] = 0;
			dataChar[i+2] = 0; //green
			dataChar[i+3] = 0;
		}
		
    }
	
	
	
	CGImageRef returnImage = CGBitmapContextCreateImage(cgctx);
	
    // When finished, release the context
    //CGContextRelease(cgctx); 
    // Free image data memory for the context
	/* if (data)
	 {
	 free(data);
	 }*/
	return returnImage;
}
CGImageRef CalibrateImagePixelData(CGContextRef cgctx, int value){
	// context.
    void *data = CGBitmapContextGetData (cgctx);
    if (data != NULL)
    {
		unsigned char *dataChar = data;
		
		for (int i=0; i<SLAMMAXRESOLUTIONLIMIT*SLAMMAXRESOLUTIONLIMIT*4; i+=4) {
			if (value >= dataChar[i+3]) {
				dataChar[i+1] = 0;
				dataChar[i+2] = 0;
			} else if (value < dataChar[i+3]) {
				if (50*(dataChar[i+3]-value) < 255) {
					dataChar[i+1] = 50*(dataChar[i+3]-value);
				} else {
					dataChar[i+1] = 50*5;
				}

				dataChar[i+2] = 255;
			}
			
/*			dataChar[i] = dataChar[i];
			dataChar[i+1] = dataChar[i+1];
			dataChar[i+2] = dataChar[i+2]; //green
			dataChar[i+3] = dataChar[i+3];
*/		}
		
    }
	
	
	
	CGImageRef returnImage = CGBitmapContextCreateImage(cgctx);
	
    // When finished, release the context
    //CGContextRelease(cgctx); 
    // Free image data memory for the context
	/* if (data)
	 {
	 free(data);
	 }*/
	return returnImage;
}


- (void) plot:(id)object{
	struct UAVCOORD array[COORDINATESLIMIT];
 	//NSLog(@"inplot");

	memcpy(array, [[object object] bytes], [[object object] length]);
	
	for (int i=0; i<COORDINATESLIMIT; i++) {
		if (array[i].state > 5) {
			continue;
		}
		
		if (array[i].state < 0.01) {
			continue;
		}
		
		if (array[i].x != 0 && array[i].y != 0) {
			//max x = 20m. max x coordinates = 1024
		//	NSLog(@"Plot");

			[self plotAt:SLAMMAXRESOLUTIONLIMIT/2 + -array[i].x/40.0*SLAMMAXRESOLUTIONLIMIT y:SLAMMAXRESOLUTIONLIMIT/2 + array[i].y/40.0*SLAMMAXRESOLUTIONLIMIT ];
		} else {
			NSLog(@"x:%f y:%f s:%f BREAK", array[i].x, array[i].y, array[i].state);
			//NSLog(@"zero x,y found");
			//break;
		}
	}
	
	[self updateUAVIndicator];
	
//	NSLog(@"points in subview:%d", [[radarView subviews] count]);
}

- (void) plotAt: (double) x y: (double) y  {
	if (x < 0) {
		return;
	}
	if (y < 0) {
		return;
	}
	if (x >= SLAMMAXRESOLUTIONLIMIT) {
		return;
	}
	if (y >= SLAMMAXRESOLUTIONLIMIT) {
		return;
	}
	NSParameterAssert(x < SLAMMAXRESOLUTIONLIMIT);
	NSParameterAssert(y < SLAMMAXRESOLUTIONLIMIT);
	CGImageRelease(imageCG);
	imageCG = ManipulateImagePixelData(context, imageCG,x ,y, [sliderSLAM value]);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageCG];
	radarView.image = image;
	
	[image release];
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1304838684_bullet-red.png"]];
	
//	imageView.frame = CGRectMake(0,0,SLAMMAXRESOLUTIONLIMIT,SLAMMAXRESOLUTIONLIMIT);
//	[radarView addSubview:imageView];
//	[imageView release];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	imageCG = [UIImage imageNamed:@"1024by1024.bmp"].CGImage;
//	self.radarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1304838684_bullet-red.png"]];

//	self.radarView.frame = CGRectMake(0, 0, SLAMMAXRESOLUTIONLIMIT, SLAMMAXRESOLUTIONLIMIT);
	
	//self.imageData = (NSData*) CGDataProviderCopyData(CGImageGetDataProvider([UIImage imageNamed:@"1304838684_bullet-red.png"].CGImage));

	self.radarView = [[[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageCG]] autorelease];
	
	[radarArea setBouncesZoom:NO];
	self.radarView.frame = CGRectMake(0, 0, SLAMMAXRESOLUTIONLIMIT, SLAMMAXRESOLUTIONLIMIT);
	radarArea.delegate = self;
	[radarArea setContentSize:CGSizeMake(SLAMMAXRESOLUTIONLIMIT, SLAMMAXRESOLUTIONLIMIT)];

	[radarArea setMaximumZoomScale:4];
	[radarArea setMinimumZoomScale:1];
	
	[radarArea addSubview:radarView];
	
	UIButton *clearSLAM = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[clearSLAM setTitle:@"Clear SLAM" forState:UIControlStateNormal];
	
	clearSLAM.frame = CGRectMake(1024-150-20, 20, 150, 40);
	
	[clearSLAM addTarget:self action:@selector(clearSLAM) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:clearSLAM];
	
	
	sliderSLAM = [[UISlider alloc] initWithFrame:CGRectMake(1024/2-300/2, 640, 300, 20)];
	
	[sliderSLAM addTarget:self action:@selector(sliderSLAM:) forControlEvents:UIControlEventValueChanged];
	[sliderSLAM setMaximumValue:4];
	[sliderSLAM setMinimumValue:0];
	[sliderSLAM setValue:0];
	sliderValue = 0;
	[self.view addSubview:sliderSLAM];

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plot:) name:@"plotCoordinates" object:nil];
	
	[[UAV sharedInstance] removeSpinner];
	// Create the bitmap context
    context = CreateARGBBitmapContext(imageCG);
    if (context == NULL) 
    { 
        // error creating context
        NSAssert(0, @"Context == null");
    }
	
	// Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(imageCG);
    size_t h = CGImageGetHeight(imageCG);
    CGRect rect = {{0,0},{w,h}}; 
	
    // Draw the image to the bitmap context. Once we draw, the memory 
    // allocated for the context for rendering will then contain the 
    // raw image data in the specified color space.
	
	//	NSDate *s = [NSDate date];
    CGContextDrawImage(context, rect, imageCG); 
	
	//	NSLog(@"%f", [s timeIntervalSinceNow]*-1);
    // Now we can get a pointer to the image data associated with the bitmap
//	NSLog(@"strt");
/*	for (int i=0; i<0; i++) {
		[self plotAt:rand()%1024 y:rand()%1024];
	}
*/
	
//	contextBlackScreen = context;
	
	
	uavIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-icon.png"]];
	
	uavIndicator.frame = CGRectMake(0, 0, 9,10);
	uavIndicator.center = CGPointMake(0, 0);
	[radarView addSubview:uavIndicator];
	
	
	/*for (int i=0; i<10000; i++) {
		CGImageRelease(imageCG);
		imageCG = 		ManipulateImagePixelData(context, imageCG, rand()%100, rand()%100, [sliderSLAM value]);

		
		UIImage *image = [[UIImage alloc] initWithCGImage:imageCG];
		radarView.image = image;
		
		[image release];

	}*/
}

- (void)updateUAVIndicator{
	NSArray *array = [[UAV sharedInstance] getLatestRowData];
	
	uavIndicator.center = CGPointMake(SLAMMAXRESOLUTIONLIMIT/2 + [[array objectAtIndex:1] doubleValue]/40.0*SLAMMAXRESOLUTIONLIMIT, SLAMMAXRESOLUTIONLIMIT/2 - [[array objectAtIndex:0] doubleValue]/40.0*SLAMMAXRESOLUTIONLIMIT);
	
	uavIndicator.transform = CGAffineTransformMakeRotation([[array objectAtIndex:8] doubleValue]);

	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	[sliderSLAM release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[sliderSLAM release];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	//NSLog(@"zooming");
	return radarView;
}

- (IBAction)clearSLAM{
	[[[[UIAlertView alloc] initWithTitle:@"Clear SLAM?" message:@"All points will be removed" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] autorelease] show];
	
	
}

- (void)sliderSLAM:(id)sender{
	UISlider *slide = (UISlider*)sender;
	if ((int)[slide value] !=  sliderValue) {
		sliderValue = [slide value];
		CGImageRelease(imageCG);
		imageCG = CalibrateImagePixelData(context, [slide value]);
		
		UIImage *image = [[UIImage alloc] initWithCGImage:imageCG];
		radarView.image = image;
		
		[image release];
		
	//	NSLog(@"slided,%f", [slide value]);
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) {
		NSLog(@"Cancelled");
	} else {
		CGImageRelease(imageCG);
		imageCG = ClearImagePixelData(context);
		
		UIImage *image = [[UIImage alloc] initWithCGImage:imageCG];
		radarView.image = image;
		
		[image release];
		uavIndicator.center = CGPointMake(0, 0);
		//	context = contextBlackScreen;
		NSLog(@"Cleared");
	}

}

@end
