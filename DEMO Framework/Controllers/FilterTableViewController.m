//
//  FilterTableViewController.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-19.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "FilterTableViewController.h"
#import "APIManager.h"
#import "Location.h"

@interface FilterTableViewController ()

@end

@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filters = [NSMutableArray array];
    self.filterData = [NSMutableDictionary dictionary];
    self.selectedRows = [NSMutableDictionary dictionary];
    
    for (int section = 0; section < [self.filters count]; section++)
    {
        NSMutableArray *rows = [NSMutableArray array];
        [self.selectedRows setObject:rows forKey:[self.filters objectAtIndex:section]];
    }

    [self.filters addObject:@"Location"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateWithNewData];
}

- (void)updateWithNewData
{
    [self.filters enumerateObjectsUsingBlock:^(NSString *filter, NSUInteger idx, BOOL *stop) {
        if ([filter isEqualToString:@"Location"])
        {
            [[APIManager sharedManager] getLocations:nil Names:nil OrderBy:@[@"location_id"] Limit:[NSNumber numberWithInt:10] Skip:[NSNumber numberWithInt:0] Success:^(NSArray *locations)
            {
                [self.filterData setObject:locations.mutableCopy forKey:filter];
                [self.tableView reloadData];
            } Failure:^(NSError *error) {
                NSLog(@"Fetch location data failed");
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.filters count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *filter = [self.filters objectAtIndex:section];
    NSArray *data = [self.filterData objectForKey:filter];
    if (data && data.count > 0)
    {
        return filter;
    }
    else
    {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString *filter = [self.filters objectAtIndex:section];
    NSArray *data = [self.filterData objectForKey:filter];
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"filterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *filter = [self.filters objectAtIndex:indexPath.section];
    if ([filter isEqualToString:@"Location"])
    {
        Location *location = [[self.filterData objectForKey:filter] objectAtIndex:indexPath.row];
        cell.textLabel.text = location.l_name;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add checkmark
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedRows setObject:indexPath forKey:[self.filters objectAtIndex:indexPath.section]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedRows removeObjectForKey:[self.filters objectAtIndex:indexPath.section]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
