//
//  MasterViewController.m
//  KanjiReading
//
//  Created by Osamu Noguchi on 8/10/13.
//  Copyright (c) 2013 Osamu Noguchi. All rights reserved.
//

#import "MasterViewController.h"
#import "HandwritingResult.h"
#import "DetailViewController.h"
#import "CharacterCell.h"

@interface MasterViewController () {
    
}

@end

@implementation MasterViewController

@synthesize canvas;
@synthesize queue;
@synthesize touchPoint;
@synthesize points;
@synthesize recognizer;
@synthesize kanji;
@synthesize tableView;
@synthesize results;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"KANJIREADING", @"")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonPressed:)];
    
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [aboutButton addTarget:self action:@selector(aboutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = aboutButton.frame;
    [aboutButton setFrame:CGRectMake(frame.origin.x, frame.origin.y, 40, frame.size.height)];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:aboutButton]];
    
    self.queue = [[NSOperationQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1];
	self.recognizer = [[HandwritingRecognizer alloc] initWithCanvas:canvas];
    
    self.kanji = [[ATJoyoKanjiDao alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)clearButtonPressed:(id)sender {
	[recognizer clear];
	
	[queue cancelAllOperations];
	
	canvas.image = nil;
    
    results = nil;
    [tableView reloadData];
}

- (void)aboutButtonPressed {
    [self performSegueWithIdentifier:@"AboutViewFromMasterView" sender:self];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.points = [NSMutableArray array];
	
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:canvas];
	
	[points addObject:[NSValue valueWithCGPoint:CGPointMake((int)touchPoint.x, (int)touchPoint.y)]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:canvas];
    
    UIGraphicsBeginImageContext(canvas.frame.size);
    
    [canvas.image drawInRect:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
	[points addObject:[NSValue valueWithCGPoint:CGPointMake((int)currentPoint.x, (int)currentPoint.y)]];
    
    self.touchPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[queue addOperationWithBlock:^{
        
		NSArray *_results = [recognizer classify:points];

		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if (_results) {
                NSMutableArray *tmpArray = [NSMutableArray array];
                
				for (int i = 0; i < [_results count]; i++) {
					HandwritingResult *result = [_results objectAtIndex:i];
                    
                    ATCharacter *character = [kanji getData:result.value];
                    if (character) {
                        [tmpArray addObject:character];
                    }
				}
                
                if ([tmpArray count]) {
                    results = [NSArray arrayWithArray:tmpArray];
                    
                    [tableView reloadData];
                }
			}
		}];
	}];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CharacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    ATCharacter *result = [results objectAtIndex:indexPath.row];
    
    [cell.characterLabel setText:result.character];
    [cell.characterLabel sizeToFit];
    
    [cell.characterReadingLabel setText:result.reading];
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    ATCharacter *result = [results objectAtIndex:indexPath.row];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.character = result;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
