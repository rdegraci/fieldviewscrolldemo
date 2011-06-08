//
//  MainViewController.h
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

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate> {

    BOOL isKeyboardVisible;
    
    UIScrollView *contentScrollView;
    UITextField *textField1;
    UITextField *textField2;
    UITextField *textField3;
    UITextView *textView1;
    UITextView *textView2;
    UITextView *textView3;
    
    UITextField* currentTextField;  // Current text View with Focus
    UITextView* currentTextView;    // Current text Field with Focus
    
    CGRect currentTextViewRect;
}
@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain) IBOutlet UITextField *textField1;
@property (nonatomic, retain) IBOutlet UITextField *textField2;
@property (nonatomic, retain) IBOutlet UITextField *textField3;
@property (nonatomic, retain) IBOutlet UITextView *textView1;
@property (nonatomic, retain) IBOutlet UITextView *textView2;
@property (nonatomic, retain) IBOutlet UITextView *textView3;

- (IBAction)showInfo:(id)sender;

- (CGFloat)keyboardHeight:(NSNotification*)notification;
@end
