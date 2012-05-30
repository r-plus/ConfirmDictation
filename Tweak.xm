#import <objc/runtime.h>

@interface UIDictationView : NSObject
+ (id)activeInstance;
- (void)returnToKeyboard;
@end

@interface UIDictationController : NSObject
+ (id)activeInstance;
- (void)startDictation;
@end

static BOOL dictationIsConfirmed = NO;

@interface ConfirmDictation : NSObject <UIAlertViewDelegate>
@end

@implementation ConfirmDictation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (!buttonIndex) {
    dictationIsConfirmed = NO;
    [[objc_getClass("UIDictationView") activeInstance] returnToKeyboard];
  } else {
    dictationIsConfirmed = YES;
    [[objc_getClass("UIDictationController") activeInstance] startDictation];
  }
  [self release];
}
@end

// FIXME: want to more better solution... :(
//        Additionally, this solution isnt compatible for iPad.
static BOOL isFirstDictation = YES;
%hook UIDictationView
- (void)returnToKeyboard
{
  if (!isFirstDictation)
    %orig;
  else
    isFirstDictation = NO;
}
%end

%hook UIDictationController
- (void)startDictation
{
  if (!dictationIsConfirmed) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ConfirmDictation"
                                                 message:@"Start Dictation?"
                                                delegate:[[ConfirmDictation alloc] init]
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"YES", nil];
    [av show];
    [av release];
  } else {
    %orig;
    dictationIsConfirmed = NO;
  }
}
%end
