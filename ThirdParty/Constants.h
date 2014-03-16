#include <UIKit/UIDevice.h>


#define API_BASE_ADDRESS        @"http://www.uberguest.com/uberguest_dev/index.php/api"

#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)


#if DEVELOPER
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif

