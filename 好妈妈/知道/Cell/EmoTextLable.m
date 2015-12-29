//
//  EmoTextLable.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "EmoTextLable.h"
#import "EmoKeyboardView.h"

@implementation EmoTextLable

@synthesize m_DrawWidth;
@synthesize m_EmoWidth;
@synthesize m_EmoHeight;
@synthesize m_RowHeigh;
@synthesize m_FontSize;
@synthesize m_Font, textColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor clearColor];
      mArray = [[NSMutableArray alloc] initWithCapacity:10];
      
      self.m_RowHeigh = 20;//行高
      self.m_FontSize = 15;//字体大小
      self.m_EmoWidth = 20;//表情
      self.m_EmoHeight = 20;//表情
      self.m_Font = [UIFont systemFontOfSize:m_FontSize];
    }
    return self;
}
/********************************************************************
 函数描述  : 判断是否为英文或特殊字符，用于换行判断
 *********************************************************************/
-(BOOL)isEnglish:(NSString *)str {
	char c = [str characterAtIndex:0];
	//如果是英文或特殊字符，返回YES
	if (('a' <= c  && c<= 'z') || ('A' <= c  && c <= 'Z')
      || c == ':' || c == '{'|| c == '/'|| c == '*'||c == ';'||c=='['||c==']')
	{
		return TRUE;
	}
	
	return FALSE;
}

- (void)drawRect:(CGRect)rect {
  if (textColor) {
    [textColor set];
  }
  [super drawRect:rect];
  //循环绘制每一行的文字
	for (int i = 0; i < mArray.count; i++) {
    NSString *temStr = [mArray objectAtIndex:i];
    [temStr drawInRect:CGRectMake(0, i*m_RowHeigh-1, m_DrawWidth+20, m_RowHeigh) withFont:m_Font];
  }
}

/********************************************************************
 函数描述  : 对传入的字符串进行处理，图文混排，得到混排好的视图
 *********************************************************************/
- (int)LoadContent:(NSString *)text {
	if (text == nil) {
		return 0;
	}
	//因为有大量的字符串处理，创建局部自动释放池，协助系统进行内存释放
	NSAutoreleasePool *i_pool = [[NSAutoreleasePool alloc] init];
	self.m_DrawWidth = self.frame.size.width;
	//文字显示的最大宽度
	#define TEXTWIDTH self.frame.size.width
	//字符向前循环处理的最大字节数
	#define WORDMAXLEN 8
  
	NSMutableString *rowText = [NSMutableString string];//每一行的String  判断用
	NSString *rowTextReal = [NSMutableString string];//每一行的String  最终显示用
	NSMutableArray *rowStrArr =[NSMutableArray array];//行数组 用于存入所有 的行
	NSMutableArray *emoLocationXArr = [NSMutableArray array];//放表情X组的数组
	NSMutableArray *emoLocationYArr = [NSMutableArray array];//放表情Y组的数组
	NSInteger rowNum = 0;//行数
  
  //每次截取当前行后 剩下的的String
	NSString *VarText = text;
	//VartText中的表情第一次处理：找到表情（转义字符串） ，并替换为 特定的统一转义字符串
	NSDictionary *emodict = [self replaceEmo:VarText];
	//第一次处理后的表情
  (@" emodict  %@",emodict);
	NSMutableArray *emoArr = [emodict objectForKey:@"emo"];
	//第一次处理后字符串
	VarText = [emodict objectForKey:@"text"];
	//循环遍历 每个字符
	for (int i=0; i<[VarText length]; i++) {
		//取出每个字符
		NSString *everyStr = [VarText substringWithRange:NSMakeRange(i, 1)];
		//append到当前行中
		[rowText appendString:everyStr];
		//判断显示字体的状态
		//算已经截取的字符的长度
    
		CGSize size = [rowText sizeWithFont:m_Font];
		
		//得到每一行的最后一个字符 c
		//如果c为空格 直接可以换行 如果c不为空格 确定换行的位置后处理表情
		if (size.width >= TEXTWIDTH) {
			//得到每一行的最后一个字符 c
			//如果c为空格换行,空格保留在这一行，不带入下一行
			if ([everyStr isEqual:@" "]) {
        rowTextReal = [rowText substringToIndex:i+1];
				[rowStrArr addObject:rowTextReal];
				VarText = [VarText substringFromIndex:i+1];
				
			}//如果C不是英文，或者转移字符中的字符，换行，C带入到下一行
			else if (![self isEnglish:everyStr]) {
				rowTextReal = [rowText substringToIndex:i];
				[rowStrArr addObject:rowTextReal];
				VarText = [VarText substringFromIndex:i];
			}
			//如果c不为空格 向前找
			else {
				//读取的次数，向前截取
				int readCount = 0;
				
				for (int m = [rowText length]-1; m >= 0; m--) {
					// 一行的最后 是几个连续的表情  的处理		(已经被简单化处理了 我手动加了空格）
					//一行的最后 是一个很长的没有空格的 没有意义的字符串  //暂规定一个有意义的英文单词最大为 WORDMAXLEN  8个字符
					if (readCount > WORDMAXLEN) // 这是一个无意义的词，所以可以手动换行 从最后的字符C处换  相当直接换行
					{
            rowTextReal = [rowText substringToIndex:i];// 压线的C换到下一行
						[rowStrArr addObject:rowTextReal];
						VarText = [VarText substringFromIndex:i];
						break;//结束当前截取
					}
					
					//找到第一个空格 换行
					NSString *tempSpaceStr = [rowText substringWithRange:NSMakeRange(m, 1)];
					if ([tempSpaceStr isEqualToString:@"["])
					{
						//空格前的string（要绘的）  要空格  判断表情时用
						rowTextReal = [rowText substringToIndex:m+1];
						[rowStrArr addObject:rowTextReal];
						//另起一行 不取空格  找表情时 特殊字符不包括前置空格
						VarText = [VarText substringFromIndex:m+1];
						break;//结束当前截取
					}
					readCount ++;
				}
			}
			
			//得到当前行中 表情的坐标
			NSMutableArray *widthArr = 	[self findWidthArr:rowTextReal];
			for (int n = 0; n < [widthArr count]; n++) {
				[emoLocationXArr  addObject:[widthArr objectAtIndex:n]];
				NSString *high = [NSString stringWithFormat:@"%d",rowNum*m_RowHeigh];
				[emoLocationYArr addObject:  high];
			}
      
			rowNum++;
			//当前行已经换好  并且表情坐标也处理好  当前行的所有任务完成 将rowText 和 rowTextReal   i 清空
			rowText =[NSMutableString string];
			rowTextReal = [NSMutableString string];
			i = -1;
		}
		
		//最后一行的处理
		if ([VarText sizeWithFont:m_Font].width <= TEXTWIDTH) {
			//处理 表情
			NSMutableArray *widthArr = 	[self findWidthArr:VarText];
			//得到当前行中 表情的坐标
			for (int n = 0; n < [widthArr count]; n++)
			{
				[emoLocationXArr addObject:[widthArr objectAtIndex:n]];
				NSString *high = [NSString stringWithFormat:@"%d",rowNum*m_RowHeigh];
				[emoLocationYArr addObject:high];
			}
			[rowStrArr addObject:VarText];
			rowNum++;
			break;
		}
	}
	
  int iTop = (18-m_EmoHeight)/2;
	//绘表情
	for (int k = 0; k<emoLocationXArr.count; k++) {
		NSString *imgName = [emoArr objectAtIndex:k];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
		//从数组中取出X Y坐标字符串，转化为float值
		CGFloat x = [[emoLocationXArr objectAtIndex:k] floatValue];
		CGFloat y = [[emoLocationYArr objectAtIndex:k] floatValue];
		//确定表情frame
		imageView.frame =CGRectMake(x-1,y+iTop,m_EmoWidth,m_EmoHeight);
		[self addSubview:imageView];
		[imageView release];
	}
	
	
	//初始化一个数组，装新的字符
	NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:10];
	//把每一行字符中的转义字符替换成为空格
	for (int k= 0; k<[rowStrArr count]; k++) {
		NSString *text = [rowStrArr objectAtIndex:k];
    
		//如果有转义字符，就替换成空格
		while (true) {
			//根据不同自体大小，采用不同的特殊字符
			NSRange range = [self GetRangeOfEmo:text];
			//有表情
			if (range.length > 0) {
				//根据不同自体大小，采用不同的特殊字符
        text = [self FormatEmoString3:text :range];
			}
      else {
        break;
      }
		}
		[newArray addObject:text];
	}
	
  if (newArray) {
    [mArray removeAllObjects];
    [mArray addObjectsFromArray:newArray];
  }
  
  CGRect rect = self.frame;
  rect.size.height = rowNum*m_RowHeigh;
  self.frame = rect;
	
	[self setNeedsDisplay];
	
	[i_pool release];
  return self.frame.size.height;
}


/********************************************************************
 函数描述  : 处理原始字符串，用特殊字符替换表情转义字符，得到表情数组，处理后的字符串
 *********************************************************************/
//为了处理在每个转义字符串的换行的方便转义字符串前后加一个空格
- (NSDictionary *)replaceEmo:(NSString *)text {
  
	NSMutableString *LastTest = [NSMutableString string];   // 改为 特定的统一转义字符串
	NSMutableArray *emoArr = [NSMutableArray array];        //放表情的数组
	NSMutableDictionary *newdict = [NSMutableDictionary dictionary];      //放入上面两个对象
	
	if (text.length<3) {
		//先放表情 再放字符串  顺序和后面的保持一致
    [newdict setObject:emoArr forKey:@"emo"];
    [newdict setObject:text forKey:@"text"];
		return newdict;
	}
	while (text.length>0) {
		NSRange range = [text rangeOfString:@"["];
		if (range.length == 0) {
			//已经没有了就跳出
			[LastTest appendString:text];
			break;
		}
		else {	//如果/的末尾不超过2个字符，没有表情，跳出
			if (text.length-range.location < 3) {
				[LastTest appendString:text];
				break;
			}
			//当前 表情的 前面的 string
      //            NSString * emojiString=[text ];
			NSString *emojiString = [text substringWithRange:NSMakeRange(range.location,4)];
			NSString *emoStr = [EmoKeyboardView GetEmoImage:emojiString];
      (@"emoStr  emoStr  %@",emoStr);
			//如果有表情，替换掉，将表情名称存入数组
			if (emoStr) {
				// 获取 表情 将表情（地址） 放入 数组
				[emoArr addObject:emoStr];
				//将表情转义字符  改为统一的转义字符串
				//根据不同自体大小，采用不同的特殊字符
        text = [self FormatEmoString2:text :range];
				//封装 最后处理好的string
				[LastTest appendString:[text substringWithRange:NSMakeRange(0,range.location+5)]];
				//剩下的string
				text = [text substringWithRange:NSMakeRange(range.location+5, text.length-range.location-5)];
			}
			else {
				//封装 最后处理好的string
				[LastTest appendString:[text substringWithRange:NSMakeRange(0,range.location+1)]];
				//剩下的string
				text = [text substringWithRange:NSMakeRange(range.location+1, text.length-range.location-1)];
				
			}
		}
	}
	
	//将存放所有表情名字的数组添加到emoArrAndText数组
  [newdict setObject:emoArr forKey:@"emo"];
	//将处理后的字符串添加到emoArrAndText数组
  [newdict setObject:LastTest forKey:@"text"];
	
	return newdict;
}


/********************************************************************
 函数描述  : 获取每一行表情的坐标，存入坐标数组
 *********************************************************************/
-(NSMutableArray *)findWidthArr:(NSString *)text {
	NSString *beforeEmo = nil;
	NSMutableArray *xLocationArr = [NSMutableArray array];
	int length = text.length;
	if (length < 2) {
		return xLocationArr;
	}
	// 循环遍历每一个表情
	while (true) {
		//根据不同自体大小，采用不同的特殊字符
		NSRange range = [self GetRangeOfEmo:text];
		if (range.length > 0 ) {
      //有表情
      text = [self FormatEmoString:text :range];
			
			beforeEmo = [text substringWithRange:NSMakeRange(0, range.location)];
      
			CGFloat xLocation = [beforeEmo sizeWithFont:m_Font].width;
			NSString *xlo = [NSString stringWithFormat:@"%f",xLocation];
			[xLocationArr addObject:xlo];
		}
    else {
      //没有表情
			return xLocationArr;
		}
	}
	return xLocationArr;
}
- (NSRange)GetRangeOfEmo:(NSString *)text {
  return [text rangeOfString:@"[**]"];
}
- (NSString *)FormatEmoString:(NSString *)text :(NSRange)range {
  return [text stringByReplacingCharactersInRange:NSMakeRange(range.location, 4) withString:@" *[]* "];
}
- (NSString *)FormatEmoString2:(NSString *)text :(NSRange)range {
  return [text stringByReplacingCharactersInRange:NSMakeRange(range.location, 4) withString:@"[**] "];
}

- (NSString *)FormatEmoString3:(NSString *)text :(NSRange)range {
  return [text stringByReplacingCharactersInRange:NSMakeRange(range.location, 4) withString:@"    "];
}

- (void)dealloc {
  self.textColor = nil;
  [mArray release];
  [super dealloc];
}


@end
