//
//  FilterTableViewController.m
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-19.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import "FilterTableViewController.h"
#import "APIManager.h"
#import "DataManager.h"

@interface FilterTableViewController ()

@end

@implementation FilterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filterNames = [DataManager sharedManager].filterNames;
    self.filterOptions = [NSMutableDictionary dictionary];
    self.selectedFilterOptions = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [self.filterNames count]; i++)
    {
        [self.filterOptions setObject:[NSMutableArray array] forKey:[self.filterNames objectAtIndex:i]];
        [self.selectedFilterOptions setObject:[NSMutableArray array] forKey:[self.filterNames objectAtIndex:i]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateWithNewData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate filterTableView:self.tableView didUpdate:self.selectedFilterOptions];
}

- (void)updateWithNewData
{
    self.filterNames = [DataManager sharedManager].filterNames;
    [self.filterNames enumerateObjectsUsingBlock:^(NSString *filter, NSUInteger idx, BOOL *stop)
    {
        if ([filter isEqualToString:@"Location"])
        {
            [[APIManager sharedManager] getLocations:nil Names:nil OrderBy:nil Limit:nil Skip:[NSNumber numberWithInt:0] Success:^(NSArray *locations)
            {
                [self.filterOptions setObject:locations.mutableCopy forKey:filter];
                [self.tableView reloadData];
            } Failure:^(NSError *error)
            {
                NSLog(@"Fetch location data failed");
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.filterNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *filter = [self.filterNames objectAtIndex:section];
    NSArray *option = [self.filterOptions objectForKey:filter];
    if (option && option.count > 0)
    {
        return filter;
    }
    else
    {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *filter = [self.filterNames objectAtIndex:section];
    NSArray *option = [self.filterOptions objectForKey:filter];
    return option.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"filterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *filter = [self.filterNames objectAtIndex:indexPath.section];
    id<FilterOption> option = [[self.filterOptions objectForKey:filter] objectAtIndex:indexPath.row];
    cell.textLabel.text = option.filterName;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add checkmark
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *filter = [self.filterNames objectAtIndex:indexPath.section];
    id<FilterOption> option = [[self.filterOptions objectForKey:filter] objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.selectedFilterOptions objectForKey:filter] addObject:option.filterId];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.selectedFilterOptions objectForKey:filter] removeObject:option.filterId];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
