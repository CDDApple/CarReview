//
//  UIKit+Extension.swift
//  SwiftBP
//
//  Created by caodd on 2018/8/7.
//  Copyright © 2018年 caodd. All rights reserved.
//

import UIKit
import CoreText
import SnapKit
import Kingfisher

protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    /// 提供 加载方法
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

protocol NibLoadable {}

extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}


extension UIView {
    
    /// x
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get { return frame.size }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size        = newValue
            frame                 = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get { return center.x }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get { return center.y }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffectStyle = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffectStyle, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffectStyle,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutAttribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutAttribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutAttribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutAttribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutAttribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutRelation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

protocol RegisterCellFromNib {}

extension RegisterCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
}

extension UIImage {
    
    static func getLaunchImage() -> UIImage {
        var lauchImage      : UIImage!
        var viewOrientation : String!
        let viewSize        = UIScreen.main.bounds.size
        let orientation     = UIApplication.shared.statusBarOrientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            viewOrientation = "Landscape"
        } else {
            viewOrientation = "Portrait"
        }
        
        let imagesInfoArray = Bundle.main.infoDictionary!["UILaunchImages"]
        for dict : Dictionary <String, String> in imagesInfoArray as! Array {
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"]!)
            if imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"]! as String {
                
                lauchImage = UIImage(named: dict["UILaunchImageName"]!)
            }
        }
        
        return lauchImage
    }
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        } else {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        }
    }
    
    /// 随机色
    class var randomColor:UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 背景灰色(写法1)
    /// 使用:UIColor.backgroudColor
    class var backgroudColor : UIColor {
        return UIColor(r: 0, g: 0, b: 0)
    }
    
    /// 背景灰色(写法2)
    /// 使用:.globalBackgroundColor()
    class func globalBackgroundColor() -> UIColor {
        return UIColor(r: 32, g: 31, b: 38)
    }
    
    /// 蓝色(按钮文字)
    class func primaryColor () -> UIColor {
        return UIColor(r: 216, g: 172, b: 95)
    }
    
    /// 辅助引导文字颜色
    class func secondaryColor() -> UIColor {
        return UIColor(r: 143, g: 144, b: 135)
    }
    
    /// 分割线颜色
    class func strokeColor() -> UIColor {
        return UIColor(r: 193, g: 193, b: 193)
    }
    
    /// 页面标题色
    class func primaryTextColor() -> UIColor {
        return UIColor(r: 48, g: 48, b: 48)
    }
    
    /// 弹框红色按钮
    class func alertColor() -> UIColor {
        return UIColor(r: 243, g: 153, b: 46)
    }
    
    /// 背景色
    class func ctrlBgColor() -> UIColor {
        return UIColor(r: 32, g: 31, b: 38)
    }
    
    /// 阴影色
    class func shadowColor() -> UIColor {
        return UIColor(r: 195, g: 195, b: 195)
    }
    
    /// tab默认文字颜色
    class func tabTitleColor() -> UIColor {
        return UIColor(r: 150, g: 150, b: 150)
    }
    
    /// tab选中文字颜色
    class func tabSelTitleColor() -> UIColor {
        return UIColor(r: 216, g: 172, b: 95)
    }
    
    /// 消息数颜色
    class func messageCountColor() -> UIColor {
        return UIColor(r: 252, g: 95, b: 95)
    }
    
    /// 色值返回图片
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

//MARK: Kingfisher
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.transition(.fade(0.5))])
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControlState, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
        
    }
}

//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}


extension String {
    
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
}
