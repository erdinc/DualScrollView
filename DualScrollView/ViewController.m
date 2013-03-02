//
//  ViewController.m
//  DualScrollView
//
//  Created by Erdinc Akkaya on 3/2/13.
//  Copyright (c) 2013 Erdinc Akkaya. All rights reserved.
//

#import "ViewController.h"
#import "CustomScrollView.h"


@implementation ViewController

UIScrollView *horizontalScroll;


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareMainHorizontalScroll{
    horizontalScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    horizontalScroll.delegate = self;
    horizontalScroll.minimumZoomScale = 1.0f;
    horizontalScroll.maximumZoomScale = 1.0f;
    horizontalScroll.zoomScale = 1.0f;
    horizontalScroll.pagingEnabled = YES;
}

- (CustomScrollView *)createVerticalContainerScrollView:(CGRect)frame{
    CustomScrollView *verticalContainer = [[CustomScrollView alloc] initWithFrame:frame];
    verticalContainer.delegate = self;
    verticalContainer.pagingEnabled = YES;
    verticalContainer.minimumZoomScale = 1.0f;
    verticalContainer.maximumZoomScale = 1.0f;
    verticalContainer.zoomScale = 1.0f;
    verticalContainer.bouncesZoom = false;
    verticalContainer.backgroundColor = [UIColor clearColor];
    return verticalContainer;
}

- (CustomScrollView *)createImageScrollView:(CGRect)frame{
    CustomScrollView* imgScroll = [[CustomScrollView alloc] initWithFrame:frame];
    imgScroll.pagingEnabled = YES;
    imgScroll.minimumZoomScale = 1.0f;
    imgScroll.maximumZoomScale = 3.0f;
    imgScroll.zoomScale = 1.0f;
    imgScroll.bouncesZoom = true;
    imgScroll.bounces = true;
    imgScroll.tag = 1001;
    imgScroll.delegate = self;
    imgScroll.backgroundColor = [UIColor clearColor];
    return imgScroll;
}

- (UIPageControl *)createVerticalPageControl:(int)imageCount{
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    UIPageControl *pageControlVer = [[UIPageControl alloc]init];
    pageControlVer.frame = CGRectMake(5, screenSize.size.height/2, 5, 20);
    // !!!:dont forget to change imageCount
    pageControlVer.numberOfPages = imageCount;
    pageControlVer.currentPage = 0;
    //make it vertical
    pageControlVer.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return pageControlVer;
}

- (void)createScrollView {
    
    //create first scrollView
    [self prepareMainHorizontalScroll];
    
    //outline of each image
    int borderSize = 0;
    // !!!:get this value from array or something
    int horizontalViewCount = 3;
    
    
    //for each horizontal view create vertical views
    int i = 0;
    for (i = 0; i < horizontalViewCount; i++)
    {
        UIView* vcontainer = [[UIView alloc] initWithFrame:CGRectMake(borderSize + i * self.view.bounds.size.width,
                                                                      borderSize + 0,
                                                                      -borderSize * 2 + self.view.bounds.size.width,
                                                                      -borderSize * 2 + self.view.bounds.size.height)];
        
        //this scrollview will hold all images in child vertical scroll view 
        CustomScrollView *vscroll = [self createVerticalContainerScrollView:vcontainer.bounds];
        
        
        // !!!:get this count from array or something else
        int imageCount = 3;
        int j=0;
        for ( j = 0; j < imageCount; j++)
        {
            UIView* container = [[UIView alloc] initWithFrame:CGRectMake(borderSize,
                                                                         borderSize + j * vscroll.bounds.size.height,
                                                                         -borderSize * 2 + vscroll.bounds.size.width,
                                                                         -borderSize * 2 + vscroll.bounds.size.height)];
            
            // put image into another scrollview to use scrollview zooming
            CustomScrollView* imgScroll = [self createImageScrollView:container.bounds];
            
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:
                                    CGRectMake(0,0,imgScroll.bounds.size.width,imgScroll.bounds.size.height)];
            
            // !!!: get this image from array or something
            imgView.image = [UIImage imageNamed:@"coffee.png"];
            imgView.contentMode = UIViewContentModeScaleToFill;
            imgView.backgroundColor = [UIColor clearColor];
            
            
            imgScroll.contentSize = imgView.bounds.size;
    
            [imgScroll addSubview:imgView];
            [container addSubview:imgScroll];
            [vscroll addSubview:container];
        }
        
        vscroll.contentSize = CGSizeMake(vscroll.bounds.size.width, j * vscroll.bounds.size.height);
        
        //add page controller
        vscroll.pageControl = [self createVerticalPageControl:imageCount];
        
        [vscroll addSubview:vscroll.pageControl];
        [vcontainer addSubview:vscroll];
        [horizontalScroll addSubview:vcontainer];
    }
    
    horizontalScroll.contentSize = CGSizeMake(i * self.view.bounds.size.width, self.view.bounds.size.height);
    
    //finally add horizontal view to viewController
    [self.view addSubview:horizontalScroll];
    
}


#pragma mark - UIScrollViewDelegate

//move pageController when user scrolls
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isMemberOfClass:[CustomScrollView class]]){
        CGRect screenSize = [[UIScreen mainScreen]bounds];
        CustomScrollView *tmp = (CustomScrollView *)scrollView;
        [tmp.pageControl  setFrame:CGRectMake(5, scrollView.contentOffset.y+screenSize.size.height/2, 5, 20)];
    }
    
}

//set pageController dots to correct position
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([scrollView isMemberOfClass:[CustomScrollView class]]){
        CustomScrollView *tmp = (CustomScrollView *)scrollView;
        CGRect size = [[UIScreen mainScreen]bounds];
        int verPage = floor((scrollView.contentOffset.y - size.size.height / 2) / size.size.height) + 1;
        tmp.pageControl.currentPage = verPage;
    }
    
}

//enable zooming on scrollView which carries image
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1001){
        return [scrollView.subviews objectAtIndex:0];
    }
    
    return nil;
}



@end
