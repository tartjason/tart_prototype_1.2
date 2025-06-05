import SwiftUI

// MARK: - App Font System
enum AppFont {
    // 标题字体
    case largeTitle     // 32pt, Bold - WelcomeView主要标题
    case title          // 20pt, Medium - 页面标题、主要部分标题
    case subtitle       // 18pt, Medium - 次要标题、导航标题
    
    // 正文字体
    case body           // 16pt, Regular - 正文内容、按钮文字
    case bodyBold       // 16pt, Semibold - 强调的正文内容
    case subheadline    // 14pt, Regular - 次要信息、说明文字
    case subheadlineBold // 14pt, Medium - 强调的次要信息
    
    // 小字体
    case caption        // 12pt, Regular - 标签、时间戳、辅助信息
    case captionBold    // 12pt, Medium - 强调的小文本
    
    // 特殊字体
    case lightTitle     // 18pt, Light - 特殊标题，如应用logo
    case lightText      // 12pt, Light - 最次要的信息
    
    var font: Font {
        switch self {
        case .largeTitle:
            return .system(size: 32, weight: .bold)
        case .title:
            return .system(size: 20, weight: .medium)
        case .subtitle:
            return .system(size: 18, weight: .medium)
        case .body:
            return .system(size: 16, weight: .regular)
        case .bodyBold:
            return .system(size: 16, weight: .semibold)
        case .subheadline:
            return .system(size: 14, weight: .regular)
        case .subheadlineBold:
            return .system(size: 14, weight: .medium)
        case .caption:
            return .system(size: 12, weight: .regular)
        case .captionBold:
            return .system(size: 12, weight: .medium)
        case .lightTitle:
            return .system(size: 18, weight: .light)
        case .lightText:
            return .system(size: 12, weight: .light)
        }
    }
}

// MARK: - Typography View Modifiers
extension View {
    // 标题字体样式
    func largeTitleStyle() -> some View {
        self.font(AppFont.largeTitle.font)
    }
    
    func titleStyle() -> some View {
        self.font(AppFont.title.font)
    }
    
    func subtitleStyle() -> some View {
        self.font(AppFont.subtitle.font)
    }
    
    // 正文字体样式
    func bodyStyle() -> some View {
        self.font(AppFont.body.font)
    }
    
    func bodyBoldStyle() -> some View {
        self.font(AppFont.bodyBold.font)
    }
    
    func subheadlineStyle() -> some View {
        self.font(AppFont.subheadline.font)
    }
    
    func subheadlineBoldStyle() -> some View {
        self.font(AppFont.subheadlineBold.font)
    }
    
    // 小字体样式
    func captionStyle() -> some View {
        self.font(AppFont.caption.font)
    }
    
    func captionBoldStyle() -> some View {
        self.font(AppFont.captionBold.font)
    }
    
    // 特殊字体样式
    func lightTitleStyle() -> some View {
        self.font(AppFont.lightTitle.font)
    }
    
    func lightTextStyle() -> some View {
        self.font(AppFont.lightText.font)
    }
}

// MARK: - Text Convenience Initializers
extension Text {
    static func largeTitle(_ text: String) -> Text {
        Text(text).font(AppFont.largeTitle.font)
    }
    
    static func title(_ text: String) -> Text {
        Text(text).font(AppFont.title.font)
    }
    
    static func subtitle(_ text: String) -> Text {
        Text(text).font(AppFont.subtitle.font)
    }
    
    static func body(_ text: String) -> Text {
        Text(text).font(AppFont.body.font)
    }
    
    static func bodyBold(_ text: String) -> Text {
        Text(text).font(AppFont.bodyBold.font)
    }
    
    static func subheadline(_ text: String) -> Text {
        Text(text).font(AppFont.subheadline.font)
    }
    
    static func subheadlineBold(_ text: String) -> Text {
        Text(text).font(AppFont.subheadlineBold.font)
    }
    
    static func caption(_ text: String) -> Text {
        Text(text).font(AppFont.caption.font)
    }
    
    static func captionBold(_ text: String) -> Text {
        Text(text).font(AppFont.captionBold.font)
    }
    
    static func lightTitle(_ text: String) -> Text {
        Text(text).font(AppFont.lightTitle.font)
    }
    
    static func lightText(_ text: String) -> Text {
        Text(text).font(AppFont.lightText.font)
    }
} 