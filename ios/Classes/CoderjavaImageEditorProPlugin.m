#import "CoderjavaImageEditorProPlugin.h"
#if __has_include(<coderjava_image_editor_pro/coderjava_image_editor_pro-Swift.h>)
#import <coderjava_image_editor_pro/coderjava_image_editor_pro-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "coderjava_image_editor_pro-Swift.h"
#endif

@implementation CoderjavaImageEditorProPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCoderjavaImageEditorProPlugin registerWithRegistrar:registrar];
}
@end
