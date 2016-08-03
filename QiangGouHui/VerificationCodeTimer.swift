//
//  VerificationCodeTimer.swift
//  MamHao
//
//  Created by Louis Zhu on 15/5/16.
//  Copyright (c) 2015年 Mamhao. All rights reserved.
//

import Foundation


let VerificationCodeSendingInterval: NSTimeInterval = 60


@objc protocol VerificationCodeTimerDelegate: NSObjectProtocol {
    func verificationCodeTimerFinished(timer: VerificationCodeTimer!);
    func verificationCodeTimerStepped(timer: VerificationCodeTimer!);
}


class VerificationCodeTimer: NSObject {
    
    var running: Bool = false
    var startDate: NSDate?
    var timer: NSTimer?
    
    weak var delegate: VerificationCodeTimerDelegate?
   
    internal class var sharedTimer: VerificationCodeTimer {
        struct Singleton {
            static let timer = VerificationCodeTimer()
        }
        
        return Singleton.timer
    }
    
    internal func start() {
        if self.running {
            return
        }
        
        self.startDate = NSDate()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(VerificationCodeTimer.fired(_:)), userInfo: nil, repeats: true)
        self.timer = timer
    }
    
    internal func stop() {
        self.running = false
        self.startDate = nil
        
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func fired(timer: NSTimer) {
        if self.startDate == nil {
            self.stop()
            return
        }
        
        let timeInterval = NSDate().timeIntervalSinceDate(self.startDate!)
        if timeInterval > VerificationCodeSendingInterval {
            self.stop()
            self.delegate?.verificationCodeTimerFinished(self)
        }
        else {
            self.delegate?.verificationCodeTimerStepped(self)
        }
    }
    
    internal func remainingTime() -> NSTimeInterval {
        if self.startDate == nil {
            return 0
        }
        
        return max(VerificationCodeSendingInterval - (NSDate().timeIntervalSinceDate(self.startDate!)), 0)
    }

}
