//
//  GGCoreTextView.m
//  TextCoreText
//
//  Created by 高斌 on 15/3/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYFeedTextView.h"
#define ZERORANGE ((NSRange){0, 0})

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)CFBridgingRelease(ref) release];
}

static CGFloat ascentCallback( void *ref ) {
    return 14;
}

static CGFloat descentCallback( void *ref ) {
    return 2;
}

static CGFloat widthCallback( void* ref ) {
    return 16.0;
}

static CGFloat widthCallbackForSpace( void* ref ){
    return 0.0;
}

@implementation JYFeedTextView{
    CGRect *_lineImageRectsCArray;
    NSUInteger _numLines;
    CFArrayRef _lines;
    NSString *_touchingID;
    NSRange _touchingIDRange;
    NSRangePointer _rangesCArray;
    
}



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
    }
    
    return self;
}


- (void)layoutWithContent:(NSString *)content
{
    [self setContent:content];

    NSMutableArray *imagesArr = [[NSMutableArray alloc] init];
    [self setImagesArray:imagesArr];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    [self setAttributedString:attributedString];
    
    NSMutableArray *drawImagesArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self setDrawImagesArray:drawImagesArr];
    
    [self parseContentString:self.content];
//    CGSize size = [self sizeForDrawAttributedString:_attributedString width:200.0 andCreateDrawImagesArray:_drawImagesArray];
    //解析完字符串后，再把人名加上属性
    if (_IDRanges.count> 0) {
        for (NSValue *temp in _IDRanges) {
            
            [self.attributedString addAttributes:@{(NSString *)kCTForegroundColorAttributeName:(id)[UIColor colorWithRed:38.0/255.0 green:149.0/255.0 blue:1.0 alpha:1.0].CGColor} range:temp.rangeValue];
        }
    }
    
    CGSize size;
    if (self.showWidth > 0) {
        size = [self sizeForDrawAttributedString:_attributedString width:self.showWidth];
    }else{
        size = [self sizeForDrawAttributedString:_attributedString width:200.0f];
    }
    
    [self setBounds:CGRectMake(0, 0, size.width, size.height)];
    [self setNeedsDisplay];
    //[self setBackgroundColor:[UIColor whiteColor]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.attributedString == nil) {
        return;
    }
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Flip the coordinate system
    CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.0f));
    
//    CTFrameDraw(_cTFrame, context);
    
    for (NSArray* imageData in _drawImagesArray) {
        UIImage* img = [UIImage imageNamed:[imageData objectAtIndex:0]];
        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
        if (self.imgBoundSize.width > 0) {
            imgBounds.size = self.imgBoundSize;
        }
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
//
    
//    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedString length]), path, NULL);

    if (_lines)
        CFRelease(_lines);
    
    _lines = CTFrameGetLines(frame);
    _numLines = CFArrayGetCount(_lines);
    
    CGPoint *lineOrigins = malloc(sizeof(CGPoint) * _numLines);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, _numLines), lineOrigins);
    if (_lineImageRectsCArray)
        free(_lineImageRectsCArray);
    
    _lineImageRectsCArray = malloc(sizeof(CGRect) * _numLines);
    for (CFIndex i=0; i<_numLines; i++){
        CTLineRef line = CFArrayGetValueAtIndex(_lines, i);
        CGRect imgBounds = CTLineGetImageBounds(line, context);
        CGFloat ascender, descender, leading;
        CTLineGetTypographicBounds(line, &ascender, &descender, &leading);
        CGFloat filpY = CGRectGetHeight(self.bounds) - lineOrigins[i].y - ascender;
        CGFloat yy = filpY - imgBounds.origin.y;
        _lineImageRectsCArray[i] = CGRectMake(imgBounds.origin.x, yy, imgBounds.size.width, imgBounds.size.height) ;
    }
    
    if (_rangesCArray)
        free(_rangesCArray);
    
    _rangesCArray = malloc(sizeof(NSRange) * [_IDs count]);
    [_IDRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        _rangesCArray[idx] = [obj rangeValue];
    }];
    
    CTFrameDraw(_cTFrame, context);
    
    CGContextRestoreGState(context);
    free(lineOrigins);
    CFRelease(framesetter);
    CFRelease(path);
}


//这个方法用于构造 _attributedString _imagesArray
- (void)parseContentString:(NSString *)contentString
{
   
    
    NSRange rangeLeft = [contentString rangeOfString:@"["];
    NSRange rangeRight = [contentString rangeOfString:@"]"];
    if (rangeLeft.length && rangeRight.length)
    {
        if (rangeLeft.location < rangeRight.location)
        {
            NSString *subString_1 = [contentString substringWithRange:NSMakeRange(rangeLeft.location+1, rangeRight.location-rangeLeft.location)];
            
            if ([subString_1 rangeOfString:@"["].length)
            {
                NSString * subString_2 = [contentString substringToIndex:rangeLeft.location+1];
                [self appendAttributedStringWithString:subString_2];
                [self parseContentString:[contentString substringFromIndex:rangeLeft.location+1]];
            } else {
                
                NSString * faceGIFName = [NSString stringWithFormat:@"[%@",subString_1];
                
                if ([faceGIFName length]) {
                    
                    [self appendAttributedStringWithString:[contentString substringToIndex:rangeLeft.location]];
                    
                    CTRunDelegateCallbacks callbacks_1;
                    callbacks_1.version = kCTRunDelegateVersion1;
                    callbacks_1.getAscent = ascentCallback;
                    callbacks_1.getDescent = descentCallback;
                    callbacks_1.getWidth = widthCallbackForSpace;
                    callbacks_1.dealloc = deallocCallback;
                    
                    CTRunDelegateRef delegate_1 = CTRunDelegateCreate(&callbacks_1, NULL);
                    NSDictionary *attrDictionaryDelegate_1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              //set the delegate
                                                              (id)delegate_1, kCTRunDelegateAttributeName,
                                                              nil];
                    CFRelease(delegate_1);
                    
                    //add a space to the text so that it can call the delegate
                    NSAttributedString * attributedString_1 = [[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate_1];
                    [_attributedString appendAttributedString:attributedString_1];
                    
                    //add the image for drawing
                    [_imagesArray addObject:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      faceGIFName, @"fileName",
                      [NSNumber numberWithInteger: [_attributedString length]], @"location",
                      nil]
                     ];
                    
                    //render empty space for drawing the image in the text
                    CTRunDelegateCallbacks callbacks;
                    callbacks.version = kCTRunDelegateVersion1;
                    callbacks.getAscent = ascentCallback;
                    callbacks.getDescent = descentCallback;
                    callbacks.getWidth = widthCallback;
                    callbacks.dealloc = deallocCallback;
                    
                    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, NULL);
                    NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            //set the delegate
                                                            (id)delegate, kCTRunDelegateAttributeName,
                                                            (id)[UIColor clearColor].CGColor,kCTForegroundColorAttributeName,
                                                            nil];
                    CFRelease(delegate);
                    
                    //add a space to the text so that it can call the delegate
                    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:@"l" attributes:attrDictionaryDelegate];
                    [_attributedString appendAttributedString:attributedString];
                    [attributedString release];
                    
                    [_attributedString appendAttributedString:attributedString_1];
                    [attributedString_1 release];
                    
                    [self parseContentString:[contentString substringFromIndex:rangeRight.location+1]];
                    
                } else {
                    [self appendAttributedStringWithString:[contentString substringToIndex:rangeRight.location+1]];
                    [self parseContentString:[contentString substringFromIndex:rangeRight.location+1]];
                }
                
            }
            
        } else {
            
            [self appendAttributedStringWithString:[contentString substringToIndex:rangeLeft.location]];
            [self parseContentString:[contentString substringFromIndex:rangeLeft.location]];
        }
        
    } else {
        
        [self appendAttributedStringWithString:contentString];
        
    }
}


- (void)appendAttributedStringWithString:(NSString *)string
{
    //段落
    //line break
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //行间距
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = 3.0;  //指定间距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);   //第二个参数为settings的长度
    
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", 14.0f, NULL);
    CGFloat widthValue = -1.0;
    CFNumberRef strokeWidth = CFNumberCreate(NULL,kCFNumberFloatType,&widthValue);
    CGColorRef theCGColorRef = [UIColor blackColor].CGColor;
    if (self.fontColor != nil) {
        theCGColorRef = self.fontColor.CGColor;
    }
    NSDictionary* attrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                           (id)theCGColorRef, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           (id)strokeWidth, kCTStrokeWidthAttributeName,
                           (id)paragraphStyle, kCTParagraphStyleAttributeName,
                           nil];
    
//    [_attributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName
//                              value:(id)paragraphStyle
//                              range:NSMakeRange(0, _attributedString.length)];
    CFRelease(strokeWidth);
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    [attrs release];
    [_attributedString appendAttributedString:attributedString];
    [attributedString release];
}

//用_imagesArray构造drawImagesArray
- (CGSize)sizeForDrawAttributedString:(NSAttributedString*)attString
                                width:(CGFloat)width
//             andCreateDrawImagesArray:(NSMutableArray *)drawImagesArray
{
    
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect textFrame = CGRectMake(0, 0, textSize.width, textSize.height+1.f);

    CGPathAddRect(path, NULL, textFrame);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    _cTFrame = frame;
    
    self.totalLineNumber = CFArrayGetCount(CTFrameGetLines(frame)); //计算共有多少行
    if (![self.imagesArray count])
    {
        self.imagesArray = nil;
        CFRelease(path);
        CFRelease(framesetter);
        return textSize;
    }
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    int imgIndex = 0;
    NSDictionary* nextImage = [self.imagesArray objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) {
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) {
                
                CGRect runBounds;
                CGFloat ascent;
                CGFloat descent;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = origins[lineIndex].x + xOffset;
                runBounds.origin.y = origins[lineIndex].y;
                //runBounds.origin.y -= descent;
                
                [_drawImagesArray addObject:
                 [NSArray arrayWithObjects:[nextImage objectForKey:@"fileName"], NSStringFromCGRect(runBounds) , nil]
                 ];
                //load the next image
                imgIndex++;
                if (imgIndex < [self.imagesArray count]) {
                    nextImage = [self.imagesArray objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }else
                {
                    break;
                }
                
            }
        }
        if (imgIndex >= [self.imagesArray count]) break;
        lineIndex++;
    }
    
    self.imagesArray = nil;
    CFRelease(path);
    CFRelease(framesetter);
    
    return textSize;
}


#pragma mark -

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"touchbegan!!");

    [self handleTouches:touches withEvent:event];
    if (self.isSuperResponse) {
        [super touchesBegan:touches withEvent:event];
    }
    //[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded!!");
//    if (_touchingID) {
        if (self.IDsClickHandler)
            self.IDsClickHandler(self, _touchingID,_touchingIDRange);
//    }else{
//        [super touchesEnded:touches withEvent:event];
//    }
    
}


- (void)handleTouches:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    _touchingID  = [self URLAtPoint:[[touches anyObject] locationInView:self] effectiveRange:&_touchingIDRange];
    NSLog(@"点击人各id:---%@---",_touchingID);
 
}

- (NSString *)URLAtPoint:(CGPoint)point
       effectiveRange:(NSRangePointer)effectiveRange
{
    if (effectiveRange)
        *effectiveRange = ZERORANGE;
    
    if (![_IDRanges count] ||
        !CGRectContainsPoint(self.bounds, point))
        return nil;
    
    void *found = bsearch_b(&point, _lineImageRectsCArray, _numLines, sizeof(CGRect), ^int(const void *key, const void *el){
        CGPoint *p = (CGPoint *)key;
        CGRect *r = (CGRect *)el;
        if (CGRectContainsPoint(*r, *p))
            return 0;
        
        if  (p->y > CGRectGetMaxY(*r))
            return 1;
        
        return -1;
    });
    
    if (!found)
        return nil;
    
    size_t idx = (CGRect *)found - _lineImageRectsCArray;
    CTLineRef line = CFArrayGetValueAtIndex(_lines, idx);
    CFIndex strIdx = CTLineGetStringIndexForPosition(line, point);
    if (strIdx == kCFNotFound)
        return nil;
    
    CGFloat offset = CTLineGetOffsetForStringIndex(line, strIdx, NULL);
    offset += _lineImageRectsCArray[idx].origin.x;
    if (point.x < offset)
        strIdx--;
    
    found = bsearch_b(&strIdx, _rangesCArray, [_IDRanges count], sizeof(NSRange), ^int(const void *key, const void *el){
        NSUInteger *idx = (NSUInteger *)key;
        NSRangePointer rng = (NSRangePointer)el;
        if (NSLocationInRange(*idx, *rng))
            return 0;
        
        if (*idx < rng->location)
            return -1;
        
        return 1;
    });
    
    if (!found)
        return nil;

    idx = (NSRangePointer)found - _rangesCArray;
    if (effectiveRange)
        *effectiveRange = [_IDRanges[idx] rangeValue];
  
    return _IDs[idx];
}


@end
