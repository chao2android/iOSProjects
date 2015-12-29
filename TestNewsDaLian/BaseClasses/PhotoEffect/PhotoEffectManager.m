//
//  PhotoEffectManager.m
//  TestPhotoEffect
//
//  Created by Bruce on 11-7-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoEffectManager.h"

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <sys/time.h>
#include <math.h>
#include <stdio.h>
#include <string.h>


@implementation PhotoEffectManager

// Return a bitmap context using alpha/red/green/blue byte values 
CGContextRef CreateRGBABitmapContext (CGImageRef inImage) 
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	void *bitmapData; 
	int bitmapByteCount; 
	int bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage); 
	size_t pixelsHigh = CGImageGetHeight(inImage); 
	bitmapBytesPerRow	= (pixelsWide * 4); 
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); 
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) 
	{
		fprintf(stderr, "Error allocating color space\n"); return NULL;
	}
	// allocate the bitmap & create context 
	bitmapData = malloc( bitmapByteCount ); 
	if (bitmapData == NULL) 
	{
		fprintf (stderr, "Memory not allocated!"); 
		CGColorSpaceRelease( colorSpace ); 
		return NULL;
	}
	context = CGBitmapContextCreate (bitmapData, 
									 pixelsWide, 
									 pixelsHigh, 
									 8, 
									 bitmapBytesPerRow, 
									 colorSpace, 
									 kCGImageAlphaPremultipliedLast);
	if (context == NULL) 
	{
		free (bitmapData); 
		fprintf (stderr, "Context not created!");
	} 
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

// Return Image Pixel data as an RGBA bitmap 
unsigned char *RequestImagePixelData(UIImage *inImage) 
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
	CGContextRef cgctx = CreateRGBABitmapContext(img); 
	
	if (cgctx == NULL) 
		return NULL;
	
	CGRect rect = {{0,0},{size.width, size.height}}; 
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
	CGContextRelease(cgctx);
	return data;
}

+ (UIImage *)GetNewImage:(int)w :(int)h :(unsigned char *)imgPixel {
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h, 
										bitsPerComponent, 
										bitsPerPixel, 
										bytesPerRow, 
										colorSpaceRef, 
										bitmapInfo, 
										provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;	
}

+ (void)FormatRGBValue:(int *)red :(int *)green :(int *)blue {
	if (*red > 255)//这里为什么要在0-255以内
		*red = 255;
	else if (*red < 0)
		*red = 0;
	if (*green > 255)
		*green = 255;
	else if (*green < 0)
		*green = 0;
	if (*blue > 255)
		*blue = 255;
	else if (*blue < 0)
		*blue = 0;
}

+ (void)GetNewRGB:(int *)rValue :(int *)gValue :(int *)bValue :(float)fBright :(float)fRed :(float)fBlue {
	int Red = *rValue;
	int Green = *gValue;
	int Blue = *bValue;
	float fY  = 0.2989*Red+0.5866*Green+0.1145*Blue;
    float fCb = -0.1687*Red-0.3312*Green+0.5000*Blue;
    float fCr = 0.5000*Red-0.4183*Green-0.0816*Blue;
	int Y = fY*fBright;
	int Cb = fCb*fRed;
	int Cr = fCr*fBlue;
	*rValue = Y+0.0000*Cb+1.4022*Cr;
	*gValue = Y-0.3456*Cb-0.7145*Cr;
	*bValue = Y+1.7710*Cb+0.0000*Cr;
}

+ (UIImage*)Effect1:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			red = green = blue = ( red + green + blue ) /3;
			
			red += red*2;
			green = green*2;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect2:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	int iCenterx = w/2;
	int iCentery = h/2;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		int iYOffset = y-iCentery;
		iYOffset = ((float)iYOffset*w)/h;
		int iHalfWidth = sqrt(w*w+h*h)/2;
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iOffset = 80;
			float fCoef = 1.6;
			red = (red-iOffset)*fCoef+iOffset;
			green = (green-iOffset)*fCoef+iOffset;
			blue = (blue-iOffset)*fCoef+iOffset;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			int iXOffset = x-iCenterx;
			float fOffset1 = sqrt(iXOffset*iXOffset+iYOffset*iYOffset);
			fCoef = (iHalfWidth-fOffset1)/iHalfWidth+0.1;
			if (fCoef > 1.0) {
				fCoef = 1.0;
			}
			fCoef = fCoef*1.2;
			
			red = red*fCoef;
			green = green*fCoef;
			blue = blue*fCoef;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect3:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	int iCenterx = w/2;
	int iCentery = h/2;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		int iYOffset = y-iCentery;
		iYOffset = ((float)iYOffset*w)/h;
		int iHalfWidth = sqrt(w*w+h*h)/2;
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iOffset = 80;
			float fCoef = 1.6;
			red = (red-iOffset)*fCoef+iOffset;
			green = (green-iOffset)*fCoef+iOffset;
			blue = (blue-iOffset)*fCoef+iOffset;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			int iXOffset = x-iCenterx;
			float fOffset1 = sqrt(iXOffset*iXOffset+iYOffset*iYOffset);
			fCoef = (iHalfWidth-fOffset1)/iHalfWidth+0.1;
			if (fCoef > 1.0) {
				fCoef = 1.0;
			}
			fCoef = fCoef*1.2;
			
			red = red*fCoef;
			green = green*fCoef*0.9;
			blue = blue*fCoef;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect5:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			green = green*0.9;
			blue = blue*0.77;
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect10:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;

	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			green = green*1.15;
			blue = blue*1.1;
			
			[self GetNewRGB:&red :&green :&blue :1.0 :1.5 :1.5];
			[self FormatRGBValue:&red :&green :&blue];

			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect6:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	
	for(GLuint y = 0; y< h-1; y++) {
		int pixOff = wOff;
		
		for (GLuint x = 0; x<w-1; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];

			red = red*0.9;
			blue = blue*0.95;
			[self GetNewRGB:&red :&green :&blue :1.1 :2.0 :2.0];
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect7:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	
	for(GLuint y = 0; y< h-1; y++) {
		int pixOff = wOff;
		int pixOff2 = wOff+w*4+4;

		
		for (GLuint x = 0; x<w-1; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];

			int red2 = (unsigned char)imgPixel[pixOff2];
			int green2 = (unsigned char)imgPixel[pixOff2+1];
			int blue2 = (unsigned char)imgPixel[pixOff2+2];
			
			red += (red - red2) /2;//r1=r1+0.5*相邻象素的差值
            green +=  (green - green2) / 2;
            blue +=  (blue - blue2) / 2;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
			pixOff2 += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect8:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	
	for(GLuint y = 0; y< h-1; y++) {
		int pixOff = wOff;
		int pixOff2 = wOff+w*4+4;
		
		
		for (GLuint x = 0; x<w-1; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int red2 = (unsigned char)imgPixel[pixOff2];
			int green2 = (unsigned char)imgPixel[pixOff2+1];
			int blue2 = (unsigned char)imgPixel[pixOff2+2];
			
			red += (red - red2)/2;//r1=r1+0.5*相邻象素的差值
            green +=  (green - green2) / 2;
            blue +=  (blue - blue2) / 2;
			
			red = red*0.95;
			blue = blue*0.9;

			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
			pixOff2 += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect4:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iOffset = 128;
			float fCoef = 1.3;
			red = (red-iOffset)*fCoef+iOffset;
			green = (green-iOffset)*fCoef+iOffset;
			blue = (blue-iOffset)*fCoef+iOffset;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect13:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iOffset = 160;
			float fCoef = 1.7;
			red = (red-iOffset)*fCoef+iOffset;
			green = (green-iOffset)*fCoef+iOffset;
			blue = (blue-iOffset)*fCoef+iOffset;
			
			red = red*0.86;
			blue = blue*0.86;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect14:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iOffset = 110;
			float fCoef = 1.8;
			red = (red-iOffset)*fCoef+iOffset;
			green = (green-iOffset)*fCoef+iOffset;
			blue = (blue-iOffset)*fCoef+iOffset;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			green = green*0.97;
			blue = blue*0.85;
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect12:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int iAverage = (red+green+blue)/3;
			red = iAverage*1.2;
			green = iAverage*1.1;
			blue = iAverage;
			
			[self FormatRGBValue:&red :&green :&blue];
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect9:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];

			int iOffset2 = sqrt((red*red+green*green+blue*blue)/3);
			if (iOffset2<128) {
				red = red * 0.7;
				green = green * 0.7;
			}
			[self GetNewRGB:&red :&green :&blue :1.3 :1.0 :2.0];
			[self FormatRGBValue:&red :&green :&blue];
			if (iOffset2>128) {
				red = red*0.98;
				green = green*0.94;
				blue = blue*0.70;
			}
			[self FormatRGBValue:&red :&green :&blue];

			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}

+ (UIImage*)Effect11:(UIImage*)inImage {
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0; y< h; y++) {
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) {
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			[self FormatRGBValue:&red :&green :&blue];
			
			green = green*0.85;
			blue = blue*0.49;
			
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
	return [self GetNewImage:w :h :imgPixel];
}


+ (UIImage*)EffectPhoto:(UIImage*)inImage :(int)type {
    if (type == 0) {
        return [PhotoEffectManager Effect1:inImage];
    }
    else if (type == 1) {
        return [PhotoEffectManager Effect2:inImage];
    }
    else if (type == 2) {
        return [PhotoEffectManager Effect3:inImage];
    }
    else if (type == 3) {
        return [PhotoEffectManager Effect4:inImage];
    }
    else if (type == 4) {
        return [PhotoEffectManager Effect5:inImage];
    }
    else if (type == 5) {
        return [PhotoEffectManager Effect6:inImage];
    }
    else if (type == 6) {
        return [PhotoEffectManager Effect7:inImage];
    }
    else if (type == 7) {
        return [PhotoEffectManager Effect8:inImage];
    }
    else if (type == 8) {
        return [PhotoEffectManager Effect9:inImage];
    }
    else if (type == 9) {
        return [PhotoEffectManager Effect10:inImage];
    }
    else if (type == 10) {
        return [PhotoEffectManager Effect11:inImage];
    }
    else if (type == 11) {
        return [PhotoEffectManager Effect12:inImage];
    }
    else if (type == 12) {
        return [PhotoEffectManager Effect13:inImage];
    }
    else if (type == 13) {
        return [PhotoEffectManager Effect14:inImage];
    }
    return nil;
}

@end
