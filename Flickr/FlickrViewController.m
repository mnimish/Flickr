//
//  FlickrViewController.m
//  Flickr
//
//  Created by Nimish Manjarekar on 8/10/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import "FlickrViewController.h"
#import "CustomCell.h"

@interface FlickrViewController ()

- (NSString*) imageUrl:(NSDictionary*) imageObject;

@end

@implementation FlickrViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [[NSMutableArray alloc] init];
    
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=befa73ae916053499b7f64dad5aab25e&tags=sunnyvale&format=json&nojsoncallback=1&api_sig=b513514c679a10585dbd0fee29ebcb13"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *jsonObject =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *photosObject = [jsonObject objectForKey:@"photos"];
        NSArray *photos = [photosObject objectForKey:@"photo"];
        NSDictionary *object = nil;
        for(object in photos) {
            [self.images addObject: [self imageUrl: object]];
        }
        NSLog(@"%@", self.images);
        //IMP
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (NSString*) imageUrl:(NSDictionary*) imageObject {
    NSString *url = @"http://farm{farm}.static.flickr.com/{server}/{id}_{secret}_n.jpg",
             *farm = [[NSString alloc] initWithFormat:@"%@", [imageObject objectForKey:@"farm"]],
             *id =  [[NSString alloc] initWithFormat:@"%@", [imageObject objectForKey:@"id"]],
             *server =  [[NSString alloc] initWithFormat:@"%@", [imageObject objectForKey:@"server"]],
             *secret =  [[NSString alloc] initWithFormat:@"%@", [imageObject objectForKey:@"secret"]];
    url = [url stringByReplacingOccurrencesOfString:@"{farm}" withString:farm];
    url = [url stringByReplacingOccurrencesOfString:@"{id}" withString:id];
    url = [url stringByReplacingOccurrencesOfString:@"{server}" withString:server];
    url = [url stringByReplacingOccurrencesOfString:@"{secret}" withString:secret];
 
    return url;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.imagesInTable.count;
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(self.images.count > 0) {
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [self.images objectAtIndex:indexPath.row]]]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 210;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
