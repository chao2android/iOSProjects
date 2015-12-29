//
//  shengzhangViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "shengzhangViewController.h"
#import "InputGrowView.h"
#import "LineLabelView.h"

@interface shengzhangViewController ()

@end

@implementation shengzhangViewController

@synthesize mbMale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbMale = YES;
        mDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self GetLocalPath]];
        if (!mDict) {
            mDict = [[NSMutableDictionary alloc] init];
        }
        if (mDict.allKeys.count == 0) {
            for (int i = 0; i < 6; i ++) {
                NSString *key = [NSString stringWithFormat:@"Wei%d", i];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
                [mDict setObject:array forKey:key];
                key = [NSString stringWithFormat:@"Hei%d", i];
                array = [NSMutableArray arrayWithCapacity:10];
                [mDict setObject:array forKey:key];
            }
            for (int i = 0; i < 5; i ++) {
                NSString *key = [NSString stringWithFormat:@"BMI%d", i];
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
                [mDict setObject:array forKey:key];
            }
            [self LoadLineForm];
        }
    }
    return self;
}

- (NSString *)GetLocalPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [docDir stringByAppendingPathComponent:@"growline.plist"];
}

- (void)dealloc {
    [mDict release];
    [super dealloc];
}

- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.91 alpha:1.0];
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topView.backgroundColor = [UIColor blackColor];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"nav_background.png"];
    [self.view addSubview:topView];
    [topView release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 6, 45, 30.5);
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"001_4.png"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, topView.frame.size.width-100, topView.frame.size.height)];
    mlbTitle.backgroundColor = [UIColor clearColor];
    mlbTitle.text = @"生长曲线";
    mlbTitle.textAlignment = UITextAlignmentCenter;
    mlbTitle.textColor = [UIColor whiteColor];
    mlbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [topView addSubview:mlbTitle];
    [mlbTitle release];
    
    int iWidth = self.view.frame.size.width/4;
    int iOffset = 5;
    if (ISIPAD) {
        iOffset = 20;
    }
    mContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-120)];
    [self.view addSubview:mContentView];
    [mContentView release];
    
    NSArray *array = [NSArray arrayWithObjects:@"输入", @"体重", @"身高", @"BMI", nil];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(iWidth*i+iOffset, self.view.frame.size.height-44, iWidth-iOffset*2, 35);
        btn.tag = i+2000;
        [btn setBackgroundImage:[UIImage imageNamed:@"btnback.png"] forState:UIControlStateNormal];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    [self RefreshView:0];
}

- (void)OnButtonClick:(UIButton *)sender {
    int index = sender.tag-2000;
    [self RefreshView:index];
}

- (void)RefreshView:(int)index {
  
  
    if (index == 0) {
        mlbTitle.text = @"创建生长点";
        [self ShowInputView];
    }
    else if (index == 1) {
        mlbTitle.text = @"体重生长曲线图";
        miType = TLineFormType_Weight;
        [self ShowPlotView];
    }
    else if (index == 2) {
        mlbTitle.text = @"身高生长曲线图";
        miType = TLineFormType_Height;
        [self ShowPlotView];
    }
    else if (index == 3) {
        mlbTitle.text = @"BMI生长曲线图";
        miType = TLineFormType_BMI;
        [self ShowPlotView];
    }
}

- (void)LoadLineForm {
    NSLog(@"LoadLineForm");
    NSString *txtname = mbMale?@"boy_wh":@"girl_wh";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:txtname ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (content) {
        NSArray *lines = [content componentsSeparatedByString:@"\r\n"];
        for (NSString *line in lines) {
            if (!line || line.length == 0) {
                continue;
            }
            NSArray *numbers = [line componentsSeparatedByString:@" "];
            for (int i = 0; i < 5; i ++) {
                int iWeight = [[numbers objectAtIndex:i+1] intValue];
                NSString *key = [NSString stringWithFormat:@"Wei%d", i];
                NSMutableArray *array = [mDict objectForKey:key];
                if (array) {
                    [array addObject:[NSNumber numberWithFloat:iWeight]];
                }
            }
            for (int i = 0; i < 5; i ++) {
                int iHeight = [[numbers objectAtIndex:i+8] intValue];
                NSString *key = [NSString stringWithFormat:@"Hei%d", i];
                NSMutableArray *array = [mDict objectForKey:key];
                if (array) {
                    [array addObject:[NSNumber numberWithFloat:iHeight]];
                }
            }
        }
    }
    txtname = mbMale?@"boy_bmi":@"girl_bmi";
    
    path = [[NSBundle mainBundle] pathForResource:txtname ofType:@"txt"];
    content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (content) {
        NSArray *lines = [content componentsSeparatedByString:@"\r\n"];
        for (NSString *line in lines) {
            if (!line || line.length == 0) {
                continue;
            }
            NSArray *numbers = [line componentsSeparatedByString:@" "];
            for (int i = 0; i < 4; i ++) {
                int iBMI = [[numbers objectAtIndex:i] intValue];
                NSString *key = [NSString stringWithFormat:@"BMI%d", i];
                NSMutableArray *array = [mDict objectForKey:key];
                if (array) {
                    [array addObject:[NSNumber numberWithFloat:iBMI]];
                }
            }
        }
    }
    NSLog(@"%@", mDict);
}

- (NSArray *)GetKeyOfType {
    NSArray *array = nil;
    if (miType == TLineFormType_Weight) {
        array = [NSArray arrayWithObjects:@"Wei0", @"Wei1", @"Wei2", @"Wei3", @"Wei4", @"Wei5", nil];
    }
    else if (miType == TLineFormType_Height) {
        array = [NSArray arrayWithObjects:@"Hei0", @"Hei1", @"Hei2", @"Hei3", @"Hei4", @"Hei5", nil];
    }
    else if (miType == TLineFormType_BMI) {
        array = [NSArray arrayWithObjects:@"BMI0", @"BMI1", @"BMI2", @"BMI3", @"BMI4", nil];
    }
    return array;
}

- (NSArray *)GetNameOfType {
    NSArray *array = nil;
    if (miType == TLineFormType_Weight) {
        array = [NSArray arrayWithObjects:@"-2SD", @"-1SD", @"均数", @"1SD", @"2SD", @"宝宝", nil];
    }
    else if (miType == TLineFormType_Height) {
        array = [NSArray arrayWithObjects:@"-2SD", @"-1SD", @"均数", @"1SD", @"2SD", @"宝宝", nil];
    }
    else if (miType == TLineFormType_BMI) {
        array = [NSArray arrayWithObjects:@"50th", @"85th", @"95th", @"97th", @"宝宝", nil];
    }
    return array;
}

- (int)GetMaxNumOfType {
    int iYMaxNum = 150;
    if (miType == TLineFormType_Weight) {
        iYMaxNum = 50;
    }
    else if (miType == TLineFormType_Height) {
        iYMaxNum = 150;
    }
    else if (miType == TLineFormType_BMI) {
        iYMaxNum = 30;
    }
    return iYMaxNum;
}

- (NSString *)GetIntervalOfType {
    NSString *interval = @"10";
    if (miType == TLineFormType_Weight) {
        interval = @"5";
    }
    else if (miType == TLineFormType_Height) {
        interval = @"10";
    }
    else if (miType == TLineFormType_BMI) {
        interval = @"5";
    }
    return interval;
}

- (void)OnInputGrow:(InputGrowView *)sender {
    float fWeight = [sender.mWeight.text floatValue];
    float fHeight = [sender.mHeight.text floatValue];
    NSMutableArray *weiarray = [mDict objectForKey:@"Wei5"];
    NSMutableArray *heiarray = [mDict objectForKey:@"Hei5"];
    NSMutableArray *bmiarray = [mDict objectForKey:@"BMI4"];
    [weiarray addObject:[NSNumber numberWithFloat:fWeight]];
    [heiarray addObject:[NSNumber numberWithFloat:fHeight]];
    [bmiarray addObject:[NSNumber numberWithFloat:fWeight*10000/(fHeight *fHeight)]];
    [mDict writeToFile:[self GetLocalPath] atomically:YES];
    [self RefreshView:1];
}

- (void)ShowInputView {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (UIView *view in mContentView.subviews) {
        [view removeFromSuperview];
    }
    if (mLabelView) {
        [mLabelView removeFromSuperview];
        mLabelView = nil;
    }
    [pool release];
    int iTop = 0;
    if (ISIPAD) {
        iTop = 60;
    }
    InputGrowView *view = [[InputGrowView alloc] initWithFrame:CGRectMake((mContentView.frame.size.width-320)/2, iTop, 320, mContentView.frame.size.height-iTop)];
    view.delegate = self;
    view.OnInputGrow = @selector(OnInputGrow:);
    [mContentView addSubview:view];
    [view release];
}

- (void)ShowPlotView {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (UIView *view in mContentView.subviews) {
        [view removeFromSuperview];
    }
    if (mLabelView) {
        [mLabelView removeFromSuperview];
        mLabelView = nil;
    }
    [pool release];
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(10, 10, mContentView.frame.size.width-20, mContentView.frame.size.height-20)];
    hostView.backgroundColor = self.view.backgroundColor;
    [mContentView addSubview:hostView];
    [hostView release];
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.frame];
    graph.plotAreaFrame.paddingBottom = 30.0;
    graph.plotAreaFrame.paddingLeft = 30.0;
    graph.paddingBottom = 0.0f;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 10.0f;
    graph.paddingRight = 10.0f;
    hostView.hostedGraph = graph;
    [graph release];
    
    NSArray *colors = [NSArray arrayWithObjects:[CPTColor blueColor], [CPTColor colorWithComponentRed:0.95 green:0.9 blue:0.0 alpha:1.0], [CPTColor lightGrayColor], [CPTColor redColor], [CPTColor blackColor], nil];
    
    int iYMaxNum = [self GetMaxNumOfType];
    NSString *interval = [self GetIntervalOfType];
    CPTPlotRange *xPlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(12)];
    CPTPlotRange *yPlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(iYMaxNum)];
    
    NSArray *keyarray = [self GetKeyOfType];
    for (int i = 0; i < keyarray.count; i ++) {
        NSString *key = [keyarray objectAtIndex:i];
        NSArray *array = [mDict objectForKey:key];
        if (array.count == 0) {
            continue;
        }
        CPTColor *color = [colors objectAtIndex:i%5];
        float fLineWidth = 1.0;
        if ([key isEqualToString:@"Wei5"] || [key isEqualToString:@"Hei5"] || [key isEqualToString:@"BMI4"]) {
            color = [CPTColor greenColor];
            fLineWidth = 2.0;
        }
        
        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
        scatterPlot.dataSource = self; //设定数据源，需应用 CPTPlotDataSource 协议
        scatterPlot.identifier = key;
        [graph addPlot:scatterPlot];
        [scatterPlot release];
        
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit = 1.0f;
        lineStyle.lineWidth = fLineWidth;
        lineStyle.lineColor = color;
        scatterPlot.dataLineStyle = lineStyle;
        
        if (fLineWidth > 1.5) {
            CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
            symbolLineStyle.lineColor = [CPTColor greenColor];
            CPTPlotSymbol *plotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
            plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor greenColor]];
            plotSymbol.lineStyle     = symbolLineStyle;
            plotSymbol.size          = CGSizeMake(5, 5);
            scatterPlot.plotSymbol = plotSymbol;
        }
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) scatterPlot.plotSpace;
        plotSpace.allowsUserInteraction = YES;
        plotSpace.delegate = self;
        plotSpace.xRange = xPlotRange;
        plotSpace.yRange = yPlotRange;
    }
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet; //1
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 0.5f;
    lineStyle.lineColor = [CPTColor lightGrayColor];
    
    CPTXYAxis * xaxis = axisSet.xAxis;
    xaxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    xaxis.majorTickLength = 1;  // 刻度线的长度
    xaxis.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    xaxis.majorGridLineStyle = lineStyle;
    xaxis.minorTicksPerInterval = 1;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    xaxis.minorTickLineStyle = lineStyle;
    
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.numberStyle = NSNumberFormatterNoStyle;
    xaxis.labelFormatter = labelFormatter;
    
    CPTXYAxis * yaxis = axisSet.yAxis;
    yaxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    yaxis.majorTickLength = 1;  // 刻度线的长度
    yaxis.majorGridLineStyle = lineStyle;
    yaxis.majorIntervalLength = CPTDecimalFromString(interval);   // x轴主刻度：显示数字标签的量度间隔
    yaxis.minorTicksPerInterval = 1;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    yaxis.minorTickLineStyle = lineStyle;
    
    yaxis.labelFormatter = labelFormatter;
    
    UILabel *lbXText = [[UILabel alloc] initWithFrame:CGRectMake(10, mContentView.frame.size.height-20, mContentView.frame.size.width-20, 20)];
    lbXText.backgroundColor = [UIColor clearColor];
    lbXText.font = [UIFont systemFontOfSize:14];
    lbXText.textAlignment = UITextAlignmentCenter;
    lbXText.textColor = [UIColor darkGrayColor];
    lbXText.text = @"月份";
    //lbText.transform = CGAffineTransformMakeRotation(M_PI/8);
    [mContentView addSubview:lbXText];
    [lbXText release];

    int iWidth = mContentView.frame.size.height;
    UILabel *lbYText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iWidth, 16)];
    lbYText.center = CGPointMake(8, iWidth/2);
    lbYText.backgroundColor = [UIColor clearColor];
    lbYText.font = [UIFont systemFontOfSize:14];
    lbYText.textAlignment = UITextAlignmentCenter;
    lbYText.textColor = [UIColor darkGrayColor];
    lbYText.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [mContentView addSubview:lbYText];
    [lbYText release];

    if (miType == TLineFormType_Weight) {
        lbYText.text = @"体重";
    }
    else if (miType == TLineFormType_Height) {
        lbYText.text = @"身高";
    }
    else if (miType == TLineFormType_BMI) {
        lbYText.text = @"BMI";
    }
    
    mLabelView = [[LineLabelView alloc] initWithFrame:CGRectMake(30, mContentView.frame.size.height+mContentView.frame.origin.y, self.view.frame.size.width-60, 40)];
    [self.view addSubview:mLabelView];
    [mLabelView release];
    
    NSArray *colors2 = [NSArray arrayWithObjects:[UIColor blueColor], [UIColor colorWithRed:0.95 green:0.9 blue:0.0 alpha:1.0], [UIColor lightGrayColor], [UIColor redColor], [UIColor blackColor], nil];
    
    NSArray *namearray = [self GetNameOfType];
    for (int i = 0; i < namearray.count; i ++) {
        NSString *name = [namearray objectAtIndex:i];
        UIColor *color = nil;
        if (i == namearray.count-1) {
            color = [UIColor greenColor];
        }
        else {
            color = [colors2 objectAtIndex:i];
        }
        [mLabelView ShowLineLabel:i name:name color:color];
    }
}

- (CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length {
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
}

-(CPTPlotRange *)plotSpace:(CPTXYPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    int iMaxNum = [self GetMaxNumOfType];
    CPTPlotRange *xPlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(66)];
    CPTPlotRange *yPlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(iMaxNum)];
    
    //限制缩放和移动的时候。不超过原始范围
    if ( coordinate == CPTCoordinateX)
    {
        if ([ xPlotRange containsRange:newRange])
        {
            //如果缩放范围在 原始范围内。则返回缩放范围
            return newRange;
            
        }
        else if([newRange containsRange:xPlotRange]) {
            //如果缩放范围在原始范围外，则返回原始范围
            return xPlotRange;
        }
        else{
            //如果缩放和移动，导致新范围和元素范围向交叉。则要控制 左边或者右边超界的情况
            NSDecimalNumber *myXPlotLocationNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:xPlotRange.location];
            NSDecimalNumber *myXPlotLengthNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:xPlotRange.length];
            
            NSDecimalNumber *myNewRangeLocationNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:newRange.location];
            NSDecimalNumber *myNewRangeLengthNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:newRange.length];
            NSLog(@"willChangePlotRangeTo  newRange :%@\n xplotRange is %@",newRange,xPlotRange);
            if ( myXPlotLocationNSDecimalNumber.doubleValue >= myNewRangeLocationNSDecimalNumber.doubleValue)
            {
                //限制左边不超界
                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:xPlotRange.location length:newRange.length];
                return returnPlot;
            }
            if ((myNewRangeLocationNSDecimalNumber.doubleValue + myNewRangeLengthNSDecimalNumber.doubleValue) > (myXPlotLengthNSDecimalNumber.doubleValue +myXPlotLocationNSDecimalNumber.doubleValue))
            {
                double offset = (myNewRangeLocationNSDecimalNumber.doubleValue + myNewRangeLengthNSDecimalNumber.doubleValue) -(myXPlotLengthNSDecimalNumber.doubleValue+myXPlotLocationNSDecimalNumber.doubleValue);
                //限制右边不超界
                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:[NSDecimalNumber numberWithDouble:(myNewRangeLocationNSDecimalNumber.doubleValue - offset)].decimalValue length:newRange.length];
                //                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:newRange.location length:xPlotRange.length];
                NSLog(@"右边超界，超界 %f", offset);
                NSLog(@"将要返回的 range 是：%@",returnPlot);
                return returnPlot;
            }
        }
        return newRange;
    }
    else {
//        if ([yPlotRange containsRange:newRange]) {
//            //如果缩放范围在 原始范围内。则返回缩放范围
//            return newRange;
//            
//        }
//        else if([newRange containsRange:yPlotRange]) {
//            //如果缩放范围在原始范围外，则返回原始范围
//            return yPlotRange;
//        }
//        else{
//            //如果缩放和移动，导致新范围和元素范围向交叉。则要控制 左边或者右边超界的情况
//            NSDecimalNumber *myYPlotLocation = [NSDecimalNumber decimalNumberWithDecimal:yPlotRange.location];
//            NSDecimalNumber *myYPlotLength = [NSDecimalNumber decimalNumberWithDecimal:yPlotRange.length];
//            
//            NSDecimalNumber *myNewRangeLocation = [NSDecimalNumber decimalNumberWithDecimal:newRange.location];
//            NSDecimalNumber *myNewRangeLength = [NSDecimalNumber decimalNumberWithDecimal:newRange.length];
//            NSLog(@"willChangePlotRangeTo  newRange :%@\n xplotRange is %@",newRange,yPlotRange);
//            if ( myYPlotLocation.doubleValue >= myNewRangeLocation.doubleValue)
//            {
//                //限制左边不超界
//                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:yPlotRange.location length:newRange.length];
//                return returnPlot;
//            }
//            if ((myNewRangeLocation.doubleValue + myNewRangeLength.doubleValue) > (myYPlotLength.doubleValue +myYPlotLocation.doubleValue))
//            {
//                double offset = (myNewRangeLocation.doubleValue + myNewRangeLength.doubleValue) -(myYPlotLength.doubleValue+myYPlotLocation.doubleValue);
//                //限制右边不超界
//                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:[NSDecimalNumber numberWithDouble:(myNewRangeLocation.doubleValue - offset)].decimalValue length:newRange.length];
//                //                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:newRange.location length:xPlotRange.length];
//                NSLog(@"右边超界，超界 %f", offset);
//                NSLog(@"将要返回的 range 是：%@",returnPlot);
//                return returnPlot;
//            }
//        }
//        return newRange;
        return yPlotRange;
    }
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint {
    return YES;
}

- (BOOL) plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(UIEvent *)event atPoint:(CGPoint)point {
    
    return YES;
}

//询问有多少个数据，在 CPTPlotDataSource 中声明的
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    NSArray *array = [mDict objectForKey:plot.identifier];
    return array.count;
}

//询问一个个数据值，在 CPTPlotDataSource 中声明的
- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSArray *array = [mDict objectForKey:plot.identifier];
    NSNumber *number = [array objectAtIndex:index];
    
    if (fieldEnum == CPTScatterPlotFieldY) {    //询问 Y 值时
        return number;
    }
    else {                                    //询问 X 值时
        return [NSNumber numberWithInt:index];
    }
}

@end
