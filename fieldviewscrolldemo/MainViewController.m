//
//  MainViewController.m
//  fieldviewscrolldemo
//
//	Copyright 2011 by Rodney Degracia (rdegraci@gmail.com)
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "MainViewController.h"

@implementation MainViewController
@synthesize contentScrollView;
@synthesize textField1;
@synthesize textField2;
@synthesize textField3;
@synthesize textView1;
@synthesize textView2;
@synthesize textView3;


#pragma mark - View Lifecyle Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:) 
                                                 name:UIKeyboardDidHideNotification 
                                               object:self.view.window];
    
    
    
    isKeyboardVisible = NO;
    
    contentScrollView.contentSize = CGSizeMake(320.0f, 842.0f); //Contentsize is specified in the NIB
    
    currentTextField = nil;
    currentTextView = nil;
    
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setContentScrollView:nil];
    [self setTextField1:nil];
    [self setTextField2:nil];
    [self setTextField3:nil];
    [self setTextView1:nil];
    [self setTextView2:nil];
    [self setTextView3:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [contentScrollView release];
    
    [currentTextView release];
    [currentTextField release];
    
    [textField1 release];
    [textField2 release];
    [textField3 release];
    [textView1 release];
    [textView2 release];
    [textView3 release];
    [super dealloc];
}

#pragma mark - Notifications

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSLog(@"- (void)keyboardWillHide:(NSNotification *)notification");
        
    CGRect visibleViewFrame = contentScrollView.frame;
    visibleViewFrame.size.height = visibleViewFrame.size.height + [self keyboardHeight:notification];
    contentScrollView.frame = visibleViewFrame;
    
    
    if (currentTextView != nil) {
        currentTextView.frame = currentTextViewRect;
    }
    
    if (currentTextField != nil) {
        // No need to resize
    }
    
    isKeyboardVisible = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSLog(@"- (void)keyboardWillShow:(NSNotification *)notification");
 
    if (isKeyboardVisible) {
        return;
    }
    
    // Adjust the frame of the scrollView to fit the view unobscured by the keyboard
    CGRect visibleViewFrame = contentScrollView.frame;
    visibleViewFrame.size.height = visibleViewFrame.size.height - [self keyboardHeight:notification];
    contentScrollView.frame = visibleViewFrame;
        
    isKeyboardVisible = YES;
}

- (void)keyboardDidShowNotification:(NSNotification*)notification {
    
    NSLog(@"- (void)keyboardDidShowNotification:(NSNotification*)notification ");
    
    if (currentTextView != nil) {
        
        // Always save the frame of the currentTextView in case we need to restore it later, if
        // we had to change the height of the currentTextView
        currentTextViewRect = currentTextView.frame;
        
        // Edge Case
        // If a textView is too tall to fit, we will resize it to fit
        if (contentScrollView.frame.size.height < currentTextView.frame.size.height) {
            CGRect resizedTextViewFrame = currentTextView.frame;
            resizedTextViewFrame.size.height = resizedTextViewFrame.size.height - [self keyboardHeight:notification];
            currentTextView.frame = resizedTextViewFrame;
        }
        
        [contentScrollView scrollRectToVisible:currentTextView.frame animated:YES];
    }
    
    if (currentTextField != nil) {
        [contentScrollView scrollRectToVisible:currentTextField.frame animated:YES];
    }
}

- (void)keyboardDidHideNotification:(NSNotification*)notification {
    NSLog(@"- (void)keyboardDidHideNotification:(NSNotification*)notification");

}

#pragma mark - UIScrollViewDelegate Protocol


// If the User drags the view, then resign first responder accordingly
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSLog(@"- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView");
    
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
}


#pragma mark - UITextFieldDelegate Protocol

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"- (void)textFieldDidBeginEditing:(UITextField *)textField");
    
    [currentTextView release];
    currentTextView = nil;
    
    [currentTextField release];
    currentTextField = textField;
    [currentTextField retain];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField  {
    NSLog(@"- (void)textFieldDidEndEditing:(UITextField *)textField ");
}

#pragma mark - UITextViewDelegate Protocol 

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"- (void)textViewDidBeginEditing:(UITextView *)textView");
    
    [currentTextField release];
    currentTextField = nil;
    
    [currentTextView release];
    currentTextView = textView;
    [currentTextView retain];
    
    // Edge Case
    // Save the currentTextViewRect since it is possible to go directly from 
    // textViewDidEndEditing to textViewDidBeginEditing; we need it to be able
    // to restore the currentTextView.frame if necessary
    currentTextViewRect = currentTextView.frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"- (void)textViewDidEndEditing:(UITextView *)textView ");
}

#pragma mark - Functions

- (CGFloat)keyboardHeight:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    return keyboardSize.height;
}

@end
