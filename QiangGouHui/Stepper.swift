//
//  Stepper.swift
//  MamHao
//
//  Created by Louis Zhu on 15/4/17.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

import UIKit


@objc protocol StepperDelegate {
    func stepper(stepper: Stepper, shouldChangeValueFrom currentValue: Int, to newValue: Int) -> Bool
}


class Stepper: UIControl {
    
    weak var delegate: StepperDelegate?
    
    var value: Int = 0 {
        didSet {
            self.updateButtonEnableStatus()
            self.titleLabel?.text = String(value)
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }
    var minimumValue: Int = 0
    var maximumValue: Int = 0
    
    var decreaseButton: UIButton?
    var increaseButton: UIButton?
    var titleLabel: UILabel?
    
    init(frame: CGRect, minimumValue: Int, maximumValue: Int, value: Int) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.value = value
        
        super.init(frame: frame)
        
        self.configureViews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureViews() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(hexString: "dcdcdc").CGColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true;
        
        let height = self.bounds.size.height
        
        let decreaseButton = UIButton(frame: CGRectMake(0, 0, height, height))
//        decreaseButton.layer.borderWidth = 1
//        decreaseButton.layer.borderColor = UIColor(hexString: "dcdcdc").CGColor
        decreaseButton.backgroundColor = UIColor(hexString: "f6f6f6")
        decreaseButton.setImage(UIImage(named: "pro_icon_down_h"), forState: .Normal)
        decreaseButton.setImage(UIImage(named: "pro_icon_down_d"), forState: .Disabled)
        decreaseButton.addTarget(self, action: Selector("decrease:"), forControlEvents: .TouchUpInside)
        self.addSubview(decreaseButton)
        self.decreaseButton = decreaseButton
        
        let increaseButton = UIButton(frame: CGRectMake(CGRectGetMaxX(self.bounds) - height, 0, height, height))
//        increaseButton.layer.borderWidth = 1
//        increaseButton.layer.borderColor = UIColor(hexString: "dcdcdc").CGColor
        increaseButton.backgroundColor = UIColor(hexString: "f6f6f6")
        increaseButton.setImage(UIImage(named: "pro_icon_add_h"), forState: .Normal)
        increaseButton.setImage(UIImage(named: "pro_icon_add_d"), forState: .Disabled)
        increaseButton.addTarget(self, action: Selector("increase:"), forControlEvents: .TouchUpInside)
        self.addSubview(increaseButton)
        self.increaseButton = increaseButton
        
        
        let titleLabel = UILabel(frame: CGRectMake(height, 0, self.bounds.size.width - (height * 2), height))
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor(hexString: "dcdcdc").CGColor
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(hexString: "383d40")
        titleLabel.font = MMHFontOfSize(18)
        self.addSubview(titleLabel)
        self.titleLabel = titleLabel;
        
        self.updateButtonEnableStatus()
        self.titleLabel?.text = String(value)
    }
    
    
    internal func setDecreaseButtonImage(image: UIImage, forState state: UIControlState) {
        self.decreaseButton?.setImage(image, forState: state)
    }
    
    
    internal func setIncreaseButtonImage(image: UIImage, forState state: UIControlState) {
        self.increaseButton?.setImage(image, forState: state)
    }
    
    
    func decrease(sender: UIButton) {
        let currentValue = self.value
        let newValue = self.value - 1
        if newValue < self.minimumValue {
            return
        }
        
        var shouldChange = true
        if let delegate = self.delegate {
            shouldChange = delegate.stepper(self, shouldChangeValueFrom: currentValue, to: newValue)
        }
        
        if shouldChange {
            self.value = newValue
        }
//        shouldChange = self.delegate?.stepper(self, shouldChangeValueFrom: currentValue, to: newValue)
//        if let shouldChange = self.delegate?.stepper(self, shouldChangeValueFrom: currentValue, to: newValue) {
//            if shouldChange {
//                self.value = newValue
//            }
//        }
    }
    
    
    func increase(sender: UIButton) {
        let currentValue = self.value
        let newValue = self.value + 1
        if newValue > self.maximumValue {
            return
        }
        
        var shouldChange = true
        if let delegate = self.delegate {
            shouldChange = delegate.stepper(self, shouldChangeValueFrom: currentValue, to: newValue)
        }
        
        if shouldChange {
            self.value = newValue
        }
//        if let shouldChange = self.delegate?.stepper(self, shouldChangeValueFrom: currentValue, to: newValue) {
//            if shouldChange {
//                self.value = newValue
//            }
//        }
    }
    
    
    func updateButtonEnableStatus() {
        self.decreaseButton?.enabled = (self.value > self.minimumValue)
        self.increaseButton?.enabled = (self.value < self.maximumValue)
    }
    
}
