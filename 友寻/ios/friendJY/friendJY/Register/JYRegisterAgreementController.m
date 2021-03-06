//
//  JYRegisterAgreementController.m
//  friendJY
//
//  Created by 高斌 on 15/3/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYRegisterAgreementController.h"

@interface JYRegisterAgreementController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation JYRegisterAgreementController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"注册协议"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    //NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"注册协议" ofType:@"xml"] encoding:NSUTF8StringEncoding error: & error];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"注册协议副本" ofType:@"rtf"]];
    NSString *textFileContents = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // If there are no results, something went wrong
    if (textFileContents == nil) {
    // an error occurred
    NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    NSArray *lines = [textFileContents componentsSeparatedByString:@" "];
    NSLog(@"Number of lines in the file:%lu", (unsigned long)[lines count] );
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth, self.view.bounds.size.height-64)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.text = @"在此注册为友寻会员及在之后进行的征友活动中应遵守以下会员注册条款：\n1、注册条款的接受\n一旦会员在注册页面点击或勾选“阅读并同意接受注册条款”相关内容后，这就表示会员已经阅读并且同意与友寻网站达成协议，并接受所有的注册条款。\n\n2、会员注册条件\n1)申请注册成为友寻网站的会员应同时满足下列全部条件：\n在注册之日以及此后使用友寻交友服务期间必须以恋爱或者婚姻为目的；\n在注册之日以及此后使用友寻交友服务期间必须是单身状态，包括未婚、离异或是丧偶；\n在注册之日必须年满18周岁以上。\n2)为更好的享有友寻提供的服务，会员应：\n向友寻提供本人真实、正确、最新及完整的资料；\n随时更新登记资料，保持其真实性及有效性；\n提供真实有效的电子邮箱地址；\n征友过程中，务必保持征友帐号的唯一性、\n3)若会员提供任何错误、不实或不完整的资料，或友寻有理由怀疑资料为错误、不实或不完整及违反会员注册条款的，或友寻有理由怀疑其会员资料、言行等有悖于“严肃纯净的婚恋交友网站”主题的，友寻有权修改会员的注册昵称、自我介绍等，或暂停或终止该会员的帐号，或暂停或终止向该会员提供友寻网站的全部或部分服务。\n\n3、会员帐号、密码及安全\n1)在完成会员注册程序之后，会员将收到一个密码及帐号。会员有义务保证密码及帐号的安全。会员应对利用该密码及帐号所进行的一切活动负全部责任，包括任何经由友寻网站以上载、张贴、发送电子邮件或任何其它方式传送的资讯、资料、文字、软件、音乐、音讯、照片、图形、视讯、信息或其它资料，无论系公开还是私下传送，均由内容提供者承担责任。\n2)会员的密码或帐号遭到未获授权的使用，或者发生其它任何安全问题时，会员应立即通知友寻网站。由于会员使用不当导致帐号、密码泄漏，进而导致其资料、信息泄漏的，由会员承担其不利后果，友寻不承担责任。\n\n4、服务说明\n1)友寻通过国际互联网为会员提供网络服务，包括在线及无线的相关业务。为使用网站服务，会员应自行配备进入国际互联网所必需的设备，包括计算机、数据机或其它存取装置，并自行支付登录国际互联网所需要的费用。\n2)友寻在向会员提供网络服务时，可能会针对部分特定的网络服务向会员收取一定的费用，在此情况下，友寻会在相关页面上做明确的提示。如会员拒绝支付该等费用，则视为双方未能就该项付费业务达成一致，因此会员将不能使用相关的网络服务。付费业务将在本注册条款的基础上另行规定专门的服务条款，以规范付费业务的内容和双方的权利义务，会员应事先认真阅读该服务条款之后再决定是否购买该项付费业务，如会员购买付费业务，则视为双方已就服务条款的内容达成一致并均应受其约束。\n3)付费业务服务均将明确约定服务期限，即“有效期”，有效期结束后服务将自动终止，且有效期不可中断、暂停或延期。除非本注册条款另有规定，所有付费业务均不退费。\n4)对于利用友寻服务进行非法活动，或其言行（无论线上或者线下的）背离友寻严肃交友目的的，友寻将严肃处理，包括将其列入黑名单、将其被投诉的情形公之于众、删除其会员帐号等处罚措施。\n5)友寻有权向其会员发送广告信，或为组织线下活动等目的，向其会员发送电子邮件、短信或电话通知。\n6)为提高友寻会员的交友的成功率和效率的目的，友寻有权将友寻会员的交友信息在友寻的合作网站上进行展示或其他类似行为。\n\n5、免责条款\n1)友寻不保证其提供的服务一定能满足会员的要求和期望，也不保证服务不会中断，对服务的及时性、安全性、准确性都不作保证。\n2)对于会员通过友寻提供的服务传送的内容，友寻会尽合理努力按照国家有关规定严格审查，但无法完全控制经由网站服务传送的内容，不保证内容的正确性、完整性或品质。因此会员在使用友寻服务时，可能会接触到令人不快、不适当或令人厌恶的内容。在任何情况下，友寻均不为会员经由网站服务以张贴、发送电子邮件或其它方式传送的任何内容负责。但友寻有权依法停止传输任何前述内容并采取相应行动，包括但不限于暂停会员使用网站服务的全部或部分，保存有关记录，并根据国家法律法规、相关政策在必要时向有关机关报告并配合有关机关的行动。\n3)对于友寻网站提供的各种广告信息、链接、资讯等，友寻不保证其内容的正确性、合法性或可靠性，相关责任由广告商承担；并且，对于会员经由友寻服务与广告商进行联系或商业往来，完全属于会员和广告商之间的行为，与友寻无关。对于前述商业往来所产生的任何损害或损失，友寻不承担任何责任。\n4)对于用户上传的视频、照片、资料、证件等，友寻已采用相关措施并已尽合理努力进行审核，但不保证其内容的正确性、合法性或可靠性，同时也不保证其内容不侵犯第三方的权益，相关责任由上传上述内容的会员负责。\n5)会员以自己的独立判断从事与交友相关的行为，并独立承担可能产生的不利后果和责任，友寻网站不承担任何法律责任。\n6)是否使用网站服务下载或取得任何资料应由会员自行考虑并自负风险，因任何资料的下载而导致的会员电脑系统的任何损坏或数据丢失等后果，友寻不承担任何责任。\n7)友寻网站对所有会员自发组织的活动、自发成立的组织不负责任。\n8)对于本网站策划、发起、组织或是承办的任何会员活动（包括但不限于收取费用以及完全公益的活动），友寻不对上述活动的效果向会员作出任何保证或承诺，也不担保活动期间会员自身行为的合法性、合理性。由此产生的任何对于会员个人或者他人的人身损害或者名誉贬损或者财产损失以及其他损害，本网站不承担任何责任。\n9)对于会员的投诉，友寻将尽合理努力认真核实，但不保证最终公之于众的投诉的真实性、合法性，对于投诉内容侵犯会员隐私权、名誉权等合法权利的，所有法律责任由投诉者承担，与友寻无关。\n10)尽管友寻已采取相应的技术保障措施，但会员仍有可能收到各类的广告信（友寻发送的广告信除外）或其他不以交友为目的邮件，友寻不承担责任。\n11)友寻未授权任何第三方销售任何友寻的线上服务产品。任何第三方（包括但不限于淘宝等购物网站上的商铺等）出售友寻上述线上服务产品的，均可能属于非法的和侵犯友寻合法权益的销售行为，友寻均不保证提供相应的服务。\n\n6、会员权利\n会员对于自己的个人资料享有以下权利：\n1）随时查询及请求阅览，但因极少数特殊情况（如被网站加入黑名单等）无法查询及提供阅览的除外；\n2）随时请求补充或更正，但因极少数特殊情况（如网站或有关机关为司法程序保全证据等）无法补充或更正的除外；\n3）随时请求关闭账户。\n\n7、会员应遵守以下法律法规：\n1)友寻提醒会员在使用友寻服务时，遵守《中华人民共和国合同法》、《中华人民共和国著作权法》、《全国人民代表大会常务委员会关于维护互联网安全的决定》、《中华人民共和国保守国家秘密法》、《中华人民共和国电信条例》、《中华人民共和国计算机信息系统安全保护条例》、《中华人民共和国计算机信息网络国际联网管理暂行规定》及其实施办法、《计算机信息系统国际联网保密管理规定》、《互联网信息服务管理办法》、《计算机信息网络国际联网安全保护管理办法》、《互联网电子公告服务管理规定》、《信息网络传播权保护条例》等相关中国法律法规的规定。\n2)在任何情况下，如果友寻有理由认为会员使用友寻服务过程中的任何行为，包括但不限于会员的任何言论和其它行为违反或可能违反上述法律和法规的任何规定，友寻可在任何时候不经任何事先通知终止向该会员提供服务。\n\n8、禁止会员从事下列行为:\n1)发布信息或者利用友寻的服务时在友寻的网页上或者利用友寻的服务制作、复制、发布、传播以下信息：反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；损害国家荣誉和利益的；煽动民族仇恨、民族歧视、破坏民族团结的；破坏国家宗教政策，宣扬邪教和封建迷信的；散布谣言，扰乱社会秩序，破坏社会稳定的；散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；侮辱或者诽谤他人，侵害他人合法权利的；含有虚假、有害、胁迫、侵害他人隐私、骚扰、侵害、中伤、粗俗、猥亵、或其它有悖道德、令人反感的内容；含有中国法律、法规、规章、条例以及任何具有法律效力的规范所限制或禁止的其它内容的。\n2)使用友寻服务的过程中，以任何方式危害未成年人的利益的。\n3)冒充任何人或机构，包含但不限于冒充友寻工作人员、版主、主持人，或以虚伪不实的方式陈述或谎称与任何人或机构有关的。\n4)将侵犯任何人的肖像权、名誉权、隐私权、专利权、商标权、著作权、商业秘密或其它专属权利的内容上载、张贴、发送电子邮件或以其它方式传送的。\n5)将病毒或其它计算机代码、档案和程序，加以上载、张贴、发送电子邮件或以其它方式传送的。\n6)跟踪或以其它方式骚扰其他会员的。\n7)未经合法授权而截获、篡改、收集、储存或删除他人个人信息、电子邮件或其它数据资料，或将获知的此类资料用于任何非法或不正当目的。\n8)以任何方式干扰友寻服务的。\n\n9、隐私权\n1)本注册条款所涉及的隐私是指：\n在会员注册友寻网站帐户时，使用其它友寻网站产品或服务，访问友寻网站网页,或参加任何形式的会员活动时，友寻网站收集的会员的个人身份识别资料，包括会员的姓名、昵称、电邮地址、出生日期、性别、职业、所在行业、个人收入等。友寻网站自动接收并记录会员的浏览器和服务器日志上的信息，包括但不限于会员的IP地址、在线、无线信息、信件等资料。\n2)友寻收集上述信息将用于：提供网站服务、改进网页内容，满足会员对某种产品、活动的需求、通知会员最新产品、活动信息、或根据法律法规要求的用途。\n3)会员的友寻帐号具有密码保护功能，以确保会员的隐私和信息安全。在某些情况下，友寻使用通行标准的保密系统，确保资料传送的安全性。\n4)友寻可能利用工具，为合作伙伴的网站进行数据搜集工作，有关数据也会作统计用途。网站会将所记录的友寻会员数据整合起来，以综合数据形式供合作伙伴参考。综合数据会包括人数统计和使用情况等资料，但不会包含任何可以识别个人身份的数据。当友寻为合作伙伴进行数据搜集时，友寻将和合作伙伴同时在网站或者是网页上告知会员。\n5)会员的个人识别信息不会被出租、出售或以任何方式透露给给任何第三方，但以下情况除外：\n会员明确同意让第三方共享资料；\n透露会员的个人资料是提供会员所要求的产品和服务的必要条件；\n为保护友寻、会员及社会公众的权利、财产或人身安全；\n根据法律法规的规定，向司法机关提供； \n受到黑客攻击导致会员信息泄漏的；\n被搜索引擎在搜索结果中显示；\n友寻认为有必要的其他情况。\n\n10、关于会员在友寻的上传或张贴的内容\n1)会员在友寻上传或张贴的内容（包括视频、照片、文字、交友成功会员的成功故事等），视为会员授予友寻免费、非独家的使用权，友寻有权为展示、传播及推广前述张贴内容的目的，对上述内容进行复制、修改、出版等。该使用权持续至会员书面通知友寻不得继续使用，且友寻实际收到该等书面通知时止。如果友寻合作伙伴使用或在现场活动中使用，友寻将会事先征得会员的同意，但在友寻网站内使用不受此限。\n2)因会员进行上述上传或张贴，而导致任何第三方提出侵权或索赔要求的，会员承担全部责任。\n3)任何第三方对于会员在友寻的公开使用区域张贴的内容进行复制、修改、编辑、传播等行为的，该行为产生的法律后果和责任均由行为人承担，与友寻无关。\n\n11、信息储存和限制\n友寻有权制定一般措施及限制，包含但不限于网站服务将保留的电子邮件讯息、所张贴内容或其他上载内容的最长期间、每个帐号可收发电子邮件讯息的最大数量及可收发的单个消息的大小。通过网站服务存储或传送之任何信息、通讯资料和其他内容，如被删除或未予储存，友寻不承担任何责任。会员同意，连续2年时间未使用的帐号，友寻有权关闭。同时友寻有权自行决定并无论通知会员与否，随时变更这些一般措施及限制。\n\n12、结束服务\n1)如会员连续2年未登录其在友寻网站的账号，该会员的帐号将被自动关闭，友寻同时终止提供与该帐号相对应的全部或部分会员服务，并不承担退费或其他责任。\n2)会员若反对任何注册条款的内容或对之后注册条款修改有异议，或对友寻服务不满，会员有以下权利：\n不再使用友寻服务；\n结束会员使用友寻服务的资格；\n通知友寻停止该会员的服务。\n结束会员服务的同时，会员使用友寻服务的权利立即终止，友寻不再对会员承担任何义务。\n\n13、禁止商业行为\n会员承诺不对友寻提供的服务或服务的任何部分，进行复制、拷贝、出售、转售或其他用于任何商业目的的行为。\n\n14、赔偿\n1)因会员通过友寻提供的服务提供、张贴或传送内容、违反本服务条款、或侵害他人任何权利而导致任何第三人对友寻提出任何索赔或请求（包括但不限于要求友寻与该会员承担连带责任），会员应当赔偿友寻或其他合作伙伴的直接损失和间接损失，包括但不限于律师费和合理的调查费用等。\n2)会员在投诉其他会员有违法行为或违反本注册条款情形时，投诉者应承担不实投诉所产生的全部法律责任。如侵犯他人的合法权益，投诉人应独立承担全部法律责任。如给友寻造成损失的，投诉人应对友寻承担相应的赔偿责任。\n\n15、会员注册条款的变更和修改\n友寻网站有权随时对本注册条款进行变更和修改。一旦发生注册条款的变动，友寻网站将在页面上提示修改的内容，或将最新版本的会员注册条款以邮件的形式发送给会员。会员如果不同意会员注册条款的修改，可以主动取消会员资格（如注销账号）视为双方未能就变更合同达成一致，如对部分服务支付了额外的费用，可以申请将费用全额或部分退回。如果会员继续使用其会员帐号，则视为双方已经就变更合同（即注册条款的变更和修改）达成一致，双方均应受到变更后的合同内容的约束。\n\n16、不可抗力\n1)“不可抗力”是指友寻不能合理控制、不可预见或即使预见亦无法避免的事件，该事件妨碍、影响或延误友寻根据本注册条款履行其全部或部分义务。该事件包括但不限于政府行为、自然灾害、战争、黑客袭击、电脑病毒、网络故障等。不可抗力可能导致友寻网站无法访问、访问速度缓慢、存储数据丢失、会员个人信息泄漏等不利后果。\n2)遭受不可抗力事件时，友寻可中止履行本注册条款项下的义务直至不可抗力的影响消除为止，并且不因此承担违约责任；但应尽最大努力克服该事件，减轻其负面影响。\n\n17、通知\n友寻向其会员发出的通知，将采用电子邮件或页面公告的形式。注册条款的修改或其他事项变更时，友寻可以以上述形式进行通知。\n\n18、法律的适用和管辖\n本注册条款的生效、履行、解释及争议的解决均适用中华人民共和国的现行法律，所发生的争议应提交北京仲裁委员会，其仲裁裁决是终局的。本注册条款因与中华人民共和国现行法律相抵触而导致部分条款无效的，不影响其他条款的效力。\n\n\n友寻交友网";
    _textView.editable = NO;
    [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
