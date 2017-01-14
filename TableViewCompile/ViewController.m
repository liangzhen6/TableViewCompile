//
//  ViewController.m
//  TableViewCompile
//
//  Created by shenzhenshihua on 2017/1/12.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "Friend.h"
#define STAR @"★"
#define WELL @"#"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * indexs;
@property(nonatomic,strong)NSMutableDictionary * allDataDict;
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

    NSMutableDictionary * dict = [self handleAllFriendsName:data];
    self.allDataDict = dict;
    
    NSArray * allKeysArray = [dict allKeys];
    
    // 排序的字母
    NSArray *sortKeysArr = [allKeysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexs = [NSMutableArray arrayWithArray:sortKeysArr];
    NSString * firstString = [self.indexs objectAtIndex:0];
//    [self.indexs addObject:@"★"];
//    [self.indexs exchangeObjectAtIndex:0 withObjectAtIndex:self.indexs.count-1];
    [self.indexs removeObject:firstString];

    [self.indexs addObject:firstString];
    
    
    for (NSString * key in self.indexs) {
        if ([dict objectForKey:key]) {
            [self.dataSource addObject:[dict objectForKey:key]];
        }
    }
   
    [self.tableView reloadData];
    
}
//增加星标朋友
- (void)addStarFriend:(Friend *)friend{
    NSString * fristCharacter = [self getFirstLetterFromString:friend.friendName];
    friend.starFriend = YES;
    //1.从元数据中移除这一个朋友
//    NSMutableArray * dataArr = [self.allDataDict objectForKey:fristCharacter];
//    [dataArr removeObject:friend];
//    if (!dataArr.count) {
//        //这个数组被移空
//        [self.allDataDict removeObjectForKey:fristCharacter];
//    }
    [self removeFriend:friend key:fristCharacter];
    //2.将这个朋友添加到星标组
//    NSMutableArray * starArr = [self.allDataDict objectForKey:STAR];
//    if (starArr==nil) {
//        starArr = [[NSMutableArray alloc] init];
//        [self.allDataDict setObject:starArr forKey:STAR];
//    }
//    [starArr addObject:friend];
    [self addFriend:friend key:STAR];
    //3.处理索引数组以及数据源
    [self handleIndexArrAndSourceData];
    
    //4.刷新tableView
    [self.tableView reloadData];
    
    

}
//删除星标朋友
- (void)deleteStarFriend:(Friend *)friend{
    NSString * fristCharacter = [self getFirstLetterFromString:friend.friendName];
    friend.starFriend = NO;
   //1.从星标移除这个好友
//    NSMutableArray * dataArr = [self.allDataDict objectForKey:STAR];
//    [dataArr removeObject:friend];
//    if (!dataArr.count) {
//        //这个数组被移空
//        [self.allDataDict removeObjectForKey:STAR];
//    }
    [self removeFriend:friend key:STAR];
    //2.将他添加到fristCharacter这个数组内
//    NSMutableArray * starArr = [self.allDataDict objectForKey:fristCharacter];
//    if (starArr==nil) {
//        starArr = [[NSMutableArray alloc] init];
//        [self.allDataDict setObject:starArr forKey:fristCharacter];
//    }
//    [starArr addObject:friend];
    [self addFriend:friend key:fristCharacter];
    //3.处理索引数组以及数据源
    [self handleIndexArrAndSourceData];
    
    //4.刷新tableView
    [self.tableView reloadData];

}
//移除key为键的数字里面的friend
- (void)removeFriend:(Friend *)friend key:(NSString *)key{

    NSMutableArray * dataArr = [self.allDataDict objectForKey:key];
    [dataArr removeObject:friend];
    if (!dataArr.count) {
        //这个数组被移空
        [self.allDataDict removeObjectForKey:key];
    }

}
//添加key为键的数字里面的friend
- (void)addFriend:(Friend *)friend key:(NSString *)key{
    
    NSMutableArray * starArr = [self.allDataDict objectForKey:key];
    if (starArr==nil) {
        starArr = [[NSMutableArray alloc] init];
        [self.allDataDict setObject:starArr forKey:key];
    }
    [starArr addObject:friend];
    
}

- (void)handleIndexArrAndSourceData{
    NSArray * allKeysArray = [self.allDataDict allKeys];
    
    // 排序的字母
    NSArray *sortKeysArr = [allKeysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexs = [NSMutableArray arrayWithArray:sortKeysArr];
    if ([self.indexs containsObject:STAR]) {
        [self.indexs removeObject:STAR];
        [self.indexs insertObject:STAR atIndex:0];
    }
    if ([self.indexs containsObject:WELL]) {
        [self.indexs removeObject:WELL];
        [self.indexs addObject:WELL];
    }
    //先把旧的数据移除
    [self.dataSource removeAllObjects];
    for (NSString * key in self.indexs) {
        if ([self.allDataDict objectForKey:key]) {
            [self.dataSource addObject:[self.allDataDict objectForKey:key]];
        }
    }

    
}

#pragma mark  处理后台返回的一堆数据，将他们按首字母归类
- (NSMutableDictionary *)handleAllFriendsName:(NSArray *)friendsName{
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * friendName in friendsName) {
        NSString * key = [self getFirstLetterFromString:friendName];
        NSMutableArray * subArray = [resultDict objectForKey:key];
        if (subArray==nil) {
            subArray = [[NSMutableArray alloc] init];
            [resultDict setObject:subArray forKey:key];
        }
        Friend *friend = [[Friend alloc] init];
        friend.friendName = friendName;
        [subArray addObject:friend];
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
    
/*
 区： 音为ōu（欧）常有人读为“区”(qū)。
 查： 本是检查、考查的意思，念chá，但作为姓氏要念zhā。
 曾 指曾经、未曾之意时念céng,但作为姓氏时要念zēng。
 晟 本是光明之意，念shèng,。但作为姓氏时念chéng。
 单 本是不复杂、独一的意思，念dān，但是作为姓氏时念shàn。
 乐 是一个多音字，念lè或者yuè，作为姓氏时念yuè。
 仇 作姓氏时应读作qíu
 尉迟 其中的尉应读作yù
 沈 shen 也读chen 系统转换拼音时是chen
*/
#warning ===目前发现上面的这些作为姓氏的时候首字母与原汉字首字母不同需要特殊处理
    NSArray * chinacese = @[@"区",@"查",@"曾",@"晟",@"单",@"乐",@"仇",@"尉",@"沈"];
    NSArray * pinYin = @[@"ou",@"zha",@"zeng",@"cheng",@"shan",@"yue",@"qiu",@"yu",@"shen"];
    for (NSInteger i = 0; i<chinacese.count; i++) {
        if ([[(NSString *)aString substringToIndex:1] compare:chinacese[i]] == NSOrderedSame) {
            NSArray * arr = [str componentsSeparatedByString:@" "];
            if (arr.count) {
                [str replaceCharactersInRange:NSMakeRange(0, [arr[0] length]) withString:pinYin[i]];
                break;
            }
            
        }

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
        return WELL;
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Friend * friend = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.friendName;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
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




- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend * friend = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    
    return friend.starFriend?@"取消星标好友":@"添加星标好友";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    tableView.editing = YES;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Friend * friend = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
//    [self.dataSource[indexPath.section] removeObject:friend];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    if (friend.starFriend) {
    //取消星标好友
        [self deleteStarFriend:friend];
    }else{
    //添加星标好友
        [self addStarFriend:friend];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}




/*
 
 //对数据源进行重新排序
 
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
 
 //    [tableView exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
 
 }
 
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 
 return YES;
 
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
*/
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
