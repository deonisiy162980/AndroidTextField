//
//  AndroidTextField.swift
//  Engineer
//
//  Created by Denis on 27.01.17.
//  Copyright © 2017 Denis Petrov. All rights reserved.
//

import UIKit

@IBDesignable public class AndroidTextField: UITextField
{
    fileprivate var helper : UILabel!
    
    //смещение вправо основного текста
    @IBInspectable
    var textOffset: CGFloat = 10
    {
        didSet {
            layoutSubviews()
        }
    }
    
    //нужно ли подчеркивать элемент
    @IBInspectable
    var needBottomLine : Bool = true {
        didSet {
            configure()
        }
    }
    
    //цвет подчеркивания
    @IBInspectable
    var bottomLineColor: UIColor = UIColor.lightGray
    {
        didSet {
            configure()
        }
    }
    
    //уменьшение размера линии подчеркивания
    @IBInspectable
    var bottomLineSizeDecrease: Double = 0
    {
        didSet {
            setFrameForBottomLine()
        }
    }
    
    //нужно ли показывать хелпер
    @IBInspectable
    var needShowHelper: Bool = true
    {
        didSet {
            configure()
        }
    }
    
    //цвет хелпера
    @IBInspectable
    var helperColor: UIColor = UIColor.darkGray
    {
        didSet {
            setHelperColor(color: helperColor)
        }
    }
    
    //смещение хелпера вправо
    @IBInspectable
    var helperOffset: CGFloat = 10
        {
        didSet {
            layoutSubviews()
        }
    }
    
    //размер хелпера
    @IBInspectable
    var helperSize : CGFloat = 10
        {
        didSet {
            layoutSubviews()
        }
    }
    
    //расстояние между хелпером и основным текстом
    @IBInspectable
    var spaceBetweenHelperAndLabel : CGFloat = 0
        {
        didSet {
            layoutSubviews()
        }
    }
    
    //отключить функцию "вставить"
    @IBInspectable
    var disablePaste : Bool = false
    
    //нужно ли удалять пробелы после всего текста. Пример (текст______), где _ это проебелы, которые будут удалены
    @IBInspectable
    var needDeleteSpacesAtEnd : Bool = true
    
    //нужно ли делать заглавной первую букву каждого слова
    @IBInspectable
    var needUppercaseFirstChars : Bool = false
    
    
    
    
    //MARK: Initializers
    override public init(frame : CGRect)
    {
        super.init(frame : frame)
        setup()
        configure()
    }
    
    convenience public init()
    {
        self.init(frame:CGRect.zero)
        setup()
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
        configure()
    }
    
    
    override public func awakeFromNib()
    {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override public func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    
    override public func layoutSublayers(of layer: CALayer)
    {
        super.layoutSublayers(of: layer)
        
        configure()
    }
    
    /////////////////////////////////////////////////////////
    
    
    //ADDING HELPER
    fileprivate func addHelper()
    {
        if helper != nil
        {
            helper.removeFromSuperview()
            helper = nil
        }
        
        
        if needShowHelper
        {
            let help = UILabel(frame: CGRect.zero)
            helper = help
            helper.text = self.placeholder?.uppercased()
            helper.font = UIFont.systemFont(ofSize: helperSize, weight: UIFontWeightRegular)
            helper.textColor = helperColor
            helper.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - spaceBetweenHelperAndLabel - helper.intrinsicContentSize.height, width: helper.intrinsicContentSize.width, height: helper.intrinsicContentSize.height)
            
            if self.text?.characters.count == 0
            {
                helper.alpha = 0.0
            }
            else
            {
                helper.alpha = 1.0
            }
            
            self.superview?.insertSubview(helper, aboveSubview: self)
        }
    }
}


//MARK: - SETTING TEXT OFFSET
extension AndroidTextField
{
    override public func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return super.textRect(forBounds: bounds).offsetBy(dx: textOffset, dy: 0.0)
    }
    
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return super.editingRect(forBounds: bounds).offsetBy(dx: textOffset, dy: 0.0)
    }
}


//MARK: - EVENTS
extension AndroidTextField
{
    override public func becomeFirstResponder() -> Bool
    {
        addHelper()
        
        if helper != nil { helper.alpha = 1.0 }
        
        return super.becomeFirstResponder()
    }
    
    //did end
    override public func resignFirstResponder() -> Bool
    {
        if self.text?.characters.count == 0
        {
            if helper != nil { helper.removeFromSuperview(); helper = nil }
        }
        else
        {
            if helper != nil { helper.alpha = 1.0 }
        }
        
        //delete spaces
        if !(self.text?.isEmpty)! && needDeleteSpacesAtEnd
        {
            while (self.text?.hasSuffix(" "))! || (self.text?.hasSuffix("\n"))!
            {
                self.text = self.text?.substring(to: (self.text?.index(before: (self.text?.endIndex)!))!)
            }
        }
        
        //upper first char
        if needUppercaseFirstChars { self.text = self.text?.capitalized }
        
        return super.resignFirstResponder()
    }
}


//MARK: - DISABLE PASTE
extension AndroidTextField
{
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) && disablePaste
        {
            return false
        }
        else
        {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}


//MARK: - SET HELPER COLOR
extension AndroidTextField
{
    public func setHelperColor(color : UIColor)
    {
        if helper != nil
        {
            self.helper.textColor = color
        }
    }
}


//MARK: SET BOTTOM LINE SIZE
public extension AndroidTextField
{
    fileprivate func setFrameForBottomLine()
    {
        self.layer.sublayers?.forEach({ (layer) in
            if layer.name == "bottomLine" { layer.frame = CGRect(x: CGFloat(bottomLineSizeDecrease) / 2, y: self.frame.height - 1, width: self.bounds.width - CGFloat(bottomLineSizeDecrease), height: 1.0) }
        })
        
        self.layer.layoutIfNeeded()
    }
}


//MARK: - SETUP AND CONFIGURE
public extension AndroidTextField
{
    fileprivate func setup()
    {
        self.borderStyle = .none
    }
    
    
    fileprivate func configure()
    {
        if needBottomLine
        {
            let bottomLine = CALayer()
            bottomLine.name = "bottomLine"
            bottomLine.frame = CGRect(x: CGFloat(bottomLineSizeDecrease) / 2, y: self.frame.height - 1, width: self.bounds.width - CGFloat(bottomLineSizeDecrease), height: 1.0)
            bottomLine.backgroundColor = bottomLineColor.cgColor
            self.borderStyle = UITextBorderStyle.none
            self.layer.addSublayer(bottomLine)
        }
        else
        {
            self.layer.sublayers?.forEach({ (layer) in
                if layer.name == "bottomLine" { layer.removeFromSuperlayer() }
            })
        }
        
        
        addHelper()
    }
}
