//
//  ViewController.m
//  TableViewCompile
//
//  Created by shenzhenshihua on 2017/1/12.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * indexs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initTableView{

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    
    self.tableView.showsHorizontalScrollIndicator = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    
    //改变索引的颜色
//    self.tableView.sectionIndexColor = [UIColor blueColor];
    //改变索引选中的背景颜色
//    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
//    for(char c = 'Z'; c >= 'A'; c-- ){
//        NSString * data = [NSString stringWithFormat:@"%c",c];
//        [self.indexs addObject:data];
//    }
//    
//    //初始化数据
//    for(char c = 'A'; c <= 'Z'; c++ ){
//        NSString * data = [NSString stringWithFormat:@"%c",c];
//        
//        NSMutableArray * arr = [NSMutableArray array];
//        for (NSInteger i = 0; i<3; i++) {
//            [arr addObject:data];
//        }
//        [self.dataSource addObject:arr];
//    
//    }
    [self initData];
    

    [self.tableView reloadData];

}


- (void)initData{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"plist"];
    NSArray * data = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@",data);
    NSString * str = [self getFirstLetterFromString:@"仇人"];

    NSMutableDictionary * dict = [self handleAllFriendsName:data];
    for (NSString * key in dict.allKeys) {
        NSArray  * arr = [dict objectForKey:key];
        NSLog(@"%@-",key);
        
        for (NSString * str in arr) {
            NSLog(@"%@",str);
        }
    }

    NSArray * allKeysArray = [dict allKeys];
    
    // 排序的字母
    NSArray *sortKeysArr = [allKeysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexs = [NSMutableArray arrayWithArray:sortKeysArr];
    NSString * firstString = [self.indexs objectAtIndex:0];
    [self.indexs removeObject:firstString];
    [self.indexs addObject:firstString];
    
    for (NSString * key in self.indexs) {
        [self.dataSource addObject:[dict objectForKey:key]];
    }
   
    [self.tableView reloadData];
    
}

/*
- (NSMutableArray *)createSectionData:(NSArray *)arrayds
{
    NSMutableArray *allKeysArray = [[NSMutableArray alloc] init];   // 没有排序的字母
    NSMutableDictionary *dataSectionData = [[NSMutableDictionary alloc] init];  // 数据
    
    if (dataSectionData==nil)
    {
        dataSectionData = [[NSMutableDictionary alloc] init];
    }
    else
    {
        [dataSectionData removeAllObjects];
    }
    for (int i = 0; i < arrayds.count; i++)
    {
        
        NSString *sectionKey = @"";
       
       // 将姓名转换成拼音,并取名字拼音的首字母 ,得不到拼音首字母的归类至?
       
        NSString *familyName = [self getFirstLetterFromString:arrayds[i]];
        if (familyName.length == 0) {
            continue;
        }else {
            sectionKey =  familyName.length>0?[familyName substringToIndex:1]:@"?";
        }
        
        
       
       // 将首字母转换成大写
       
        sectionKey = [sectionKey uppercaseString];
        
        NSMutableArray *sectionArray = [dataSectionData objectForKey:sectionKey];
        
        if (sectionArray == nil)
        {
            [allKeysArray addObject:sectionKey];
            sectionArray = [[NSMutableArray alloc] init];
            [dataSectionData setObject:sectionArray forKey:sectionKey];
        }
        [sectionArray addObject:arrayds[i]];
    }
    
    
    NSArray *sortKeysArr = [allKeysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];  // 排序的字母
    
    
    NSMutableArray *asdfaefsag = [[NSMutableArray alloc] init];
    for (int i = 0; i<sortKeysArr.count; i++) {
        NSArray *arrsadf = dataSectionData[[NSString stringWithFormat:@"%@",sortKeysArr[i]]];
        for (int j = 0; j<arrsadf.count; j++) {
            NSArray *asdfd = @[sortKeysArr[i],arrsadf[j]];
            [asdfaefsag addObject:asdfd];
        }
    }
    
    return asdfaefsag;
}
*/

- (NSMutableDictionary *)handleAllFriendsName:(NSArray *)friendsName{
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * friendName in friendsName) {
        NSString * key = [self getFirstLetterFromString:friendName];
        NSMutableArray * subArray = [resultDict objectForKey:key];
        if (subArray==nil) {
            subArray = [[NSMutableArray alloc] init];
            [resultDict setObject:subArray forKey:key];
        }
        [subArray addObject:[friendName copy]];
    }
    
    return resultDict;
}


//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getFirstLetterFromString:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    
//    区： 音为ōu（欧）常有人读为“区”(qū)。
//    查： 本是检查、考查的意思，念chá，但作为姓氏要念zhā。
//    曾 指曾经、未曾之意时念céng,但作为姓氏时要念zēng。
//    晟 本是光明之意，念shèng,。但作为姓氏时念chéng。
//    单 本是不复杂、独一的意思，念dān，但是作为姓氏时念shàn。
//    乐 是一个多音字，念lè或者yuè，作为姓氏时念yuè。
//    仇 作姓氏时应读作qíu
//    尉迟 其中的尉应读作yù
//    万俟 作姓氏时应读作mò qí
//    沈 shen 也读chen 系统转换拼音时是chen
#warning ===目前发现上面的这些作为姓氏的时候首字母与原汉字首字母不同需要特殊处理
    
    //因为发现沈字还要chen这个音，除了沈阳，出的结果是（shen）其他都是chen，很明显不相符，
    //chen这个音基本不用，所以这里特殊处理了，沈字都发shen音
    if ([[(NSString *)aString substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    
    //获取并返回首字母
    NSString *firstStr = [str substringToIndex:1];
    //判断是不是字母
    if ([self matchLetter:firstStr]) {
        //转化为大写字母
        NSString *strPinYin = [firstStr capitalizedString];
        return strPinYin;
    }else{
        //首字母不是字母返回#
        return @"#";
    }
    
}

#pragma mark 正则表达式
- (BOOL)matchLetter:(NSString *)str{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES){
        return YES;
    }else{
        return NO;
    }
}



#pragma mark  =====tableViewDelegate====
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor blackColor];
    label.text =[NSString stringWithFormat:@"   %@",self.indexs[section]];
    return label;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

//对数据源进行重新排序

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
//    [tableView exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView.editing = YES;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        
        
        // 1. 更新数据
        
        [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    
    // 删除一个置顶按钮
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        
        
        
        // 1. 更新数据
        
//       NSString * title0 = [self.dataSource[0] objectAtIndex:0];
       NSString * titleX = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
        
//        [self.dataSource[0] removeObject:title0];
//
        [self.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.dataSource[0] insertObject:titleX atIndex:0];

//        [self.dataSource[indexPath.section] insertObject:title0 atIndex:indexPath.row];
        
//        [self.dataSource[indexPath.section] exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        
        
        
        // 2. 更新UI
        
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
    }];
    
    topRowAction.backgroundColor = [UIColor blueColor];
    
    
    
    // 添加一个更多按钮
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了更多");
        
        
        
        [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationMiddle];
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    
    // 将设置好的按钮放到数组中返回
    
    return @[deleteRowAction, topRowAction, moreRowAction];

}

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexs;
}



- (NSMutableArray *)indexs{
    if (_indexs==nil) {
        _indexs = [[NSMutableArray alloc] init];
    }
    return _indexs;
}

- (NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
