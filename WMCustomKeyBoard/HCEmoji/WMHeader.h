

#ifndef HCHeader_h
#define HCHeader_h

#import "UIFont+MyFont.h"
#import "UIView+Frame.h"
#import "UIColor+MyColor.h"


#pragma mark - -----HCInputBar-----

static NSString *emoji     = @"Resources.bundle/emoji";
static NSString *keyboard  = @"Resources.bundle/keyboard";
static NSString *camera    = @"Resources.bundle/camera";
static NSString *photo     = @"Resources.bundle/photo";
static NSString *video     = @"Resources.bundle/video";
static NSString *voice     = @"Resources.bundle/voice";

static NSString *selectedEmoji  = @"Resources.bundle/emojiHighlighted";
static NSString *selectedVoice  = @"Resources.bundle/voiceHighlighted";
static NSString *selectedVideo  = @"Resources.bundle/videoHighlighted";
static NSString *selectedPhoto  = @"Resources.bundle/photoHighlighted";
static NSString *selectedCamera = @"Resources.bundle/cameraHighlighted";

#define kInputBarHeight     50

#define kKeyboardX          4
#define kKeyboardY          (kInputBarHeight-kKeyboardWidth)/2
#define kKeyboardWidth      28

#define kInputViewX         (kKeyboardWidth+kKeyboardX*2)
#define kInputViewY         7
#define kInputViewWidth     (ScreenWidth-kInputViewX-kKeyboardX)
#define kInputViewHeight    (kInputBarHeight-kInputViewY*2)
#define kInputViewMaxHeight 60
//ExpandingType下的坐标
#define kInputViewOtherX    kKeyboardX
#define kInputViewOtherWidth    (ScreenWidth-kInputViewOtherX*2)

#define kExpandingHeight    40
#define kTopSpace           4
#define kBottomSpace        10
#define kItemSize           (kExpandingHeight-kTopSpace-kBottomSpace)

#define kPreSelectedRow     10000
#define kSelectedRow        20000

#pragma mark - -----EmojiCollectionView-----

#define kCollectionHeight   (32*3+kIconTop*4)
#define kPageControlHeight  20

#define kPageCount          20.0
#define gifPageCount         8.0
#define gifWidth_KeyBoard    60.0

#pragma mark - -----SinglePageEmojiCell-----

#define kIconSize     ((ScreenWidth - kIconLeft * 2) / 7.0 - 0.5)
#define kIconTop     17
#define kIconLeft    20
#define kgifLeft     (ScreenWidth - gifWidth_KeyBoard *(gifPageCount / 2))/(gifPageCount / 2 + 1)
static NSString *delete = @"Resources.bundle/delete";

#pragma mark - -----EmojiToolBar-----

#define WS(wSelf)           __weak typeof(self) wSelf = self

#define kToolBarHeight      40
#define kSendBtnWidth       50

static NSString *toolBarEmoji = @"Resources.bundle/toolBarEmoji";
static NSString *toolBarLoving = @"flhaha";
static NSString *toolBarDraw = @"shicon";
#pragma mark - -----HCEmojiManager-----

static NSString *emojiPath = @"Resources.bundle/emoji";
static NSString *emojiType = @"json";
#define smallEmtionCount 3

#endif /* HCHeader_h */
