import ExpoModulesCore

class ExpoTencentTRTCView: ExpoView {
    lazy var contentView = UIView()
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
    }
}
