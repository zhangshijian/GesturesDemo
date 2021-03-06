//
//  PinchGestureViewController.m
//  
//
//  Created by 讯心科技 on 2017/11/13.
//

#import "PinchGestureViewController.h"

@interface PinchGestureViewController ()

@property (weak, nonatomic) IBOutlet UIView *targetView;

@end

@implementation PinchGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    
    [self.view addGestureRecognizer:pinch];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        self.targetView.transform = CGAffineTransformMakeScale(gestureRecognizer.scale, gestureRecognizer.scale);
    }
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
