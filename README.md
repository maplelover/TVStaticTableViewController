# TVStaticTableViewController
Dynamically hide rows and sections in static UITableView inside UITableViewController. 
And it can change row height and section header/footer height too.
参考 https://github.com/k06a/ABStaticTableViewController

一、无动画移除、还原row/section
在TableView加载数据前调用，无需调用reloadData，加载完成后再动态调整，则需要调用[self.tableView reloadData]以更新TableView
- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

二、动画移除、还原row/section
无需调用reloadData
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

三、设置row及section header/footer高度
- (void)setRowHeight:(CGFloat)rowHeight forIndexPath:(NSIndexPath *)indexPath;
- (void)setHeaderHeight:(CGFloat)headerHeight forSection:(NSInteger)section;
- (void)setFooterHeight:(CGFloat)footerHeight forSection:(NSInteger)section;

最佳实践：Storyboard+Static TableView
