//
//  PasscodeLock.swift
//  SwiftPasscodeLock
//
//  Created by Yanko Dimitrov on 11/16/14.
//  Copyright (c) 2014 Yanko Dimitrov. All rights reserved.
//

import Foundation

/// MARK: - PasscodeLock
public protocol PasscodeLock: class {
    
    var passcode: [String] {get}
    var state: PasscodeLockState? {get set}
    weak var delegate: PasscodeLockDelegate? {get set}
    
    func enterSign(sign: String)
    func removeSign()
    func resetSigns()
}

/// MARK: - PasscodeLockState
public protocol PasscodeLockState: class {
    
    var title: String {get}
    var description: String {get}
    weak var passcodeLock: PasscodeLock? {get set}
    weak var stateFactory: PasscodeLockStateFactory? {get set}
    
    func verifyPasscode()
}

/// MARK: - PasscodeLockStateFactory
public protocol PasscodeLockStateFactory: class {
    
    func makeEnterPasscodeState() -> PasscodeLockState
    func makeSetPasscodeState() -> PasscodeLockState
    func makeConfirmPasscodeState() -> PasscodeLockState
    func makePasscodesMismatchState() -> PasscodeLockState
    func makeChangePasscodeState() -> PasscodeLockState
}

/// MARK: - PasscodeLockDelegate
public protocol PasscodeLockDelegate: class {
    
    func passcodeLockDidSucceed(passcodeLock: PasscodeLock)
    func passcodeLockDidFailed(passcodeLock: PasscodeLock)
    func passcodeLockDidReset(passcodeLock: PasscodeLock)
    func passcodeLock(passcodeLock: PasscodeLock, changedToState state: PasscodeLockState)
    func passcodeLock(passcodeLock: PasscodeLock, addedSignAtIndex index: Int)
    func passcodeLock(passcodeLock: PasscodeLock, removedSignAtIndex index: Int)
}

/// MARK: - PasscodeRepository
public protocol PasscodeRepository: class {
    
    var hasPasscode: Bool {get}
    var hasPasscodeExpiry: Bool {get}
    
    func savePasscode(passcode: [String]) -> Bool
    func updatePasscode(passcode: [String]) -> Bool
    func deletePasscode() -> Bool
    func getPasscode() -> [String]
    
    func saveExpiryTimeDuration(duration: NSTimeInterval) -> Bool
    func updateExpiryTimeDuration(duration: NSTimeInterval) -> Bool
    func deleteExpiryTimeDuration() -> Bool
    func getExpiryTimeDuration() -> NSTimeInterval?
    
    func saveExpiryStartTime(time: NSTimeInterval) -> Bool
    func updateExpiryStartTime(time: NSTimeInterval) -> Bool
    func deleteExpiryStartTime() -> Bool
    func getExpiryStartTime() -> NSTimeInterval?
}

/// MARK: - PasscodeLockPresentable
@objc public protocol PasscodeLockPresentable {
    
    var onCorrectPasscode: ( () -> Void )? {set get}
}

// load the correct bundle for Localization string file
func getLocalizationBundle() -> NSBundle {
    // check if a Localization string file is overwritten in main bundle
    if(NSBundle.mainBundle().pathForResource("PasscodeLock", ofType: "strings") != nil) {
        return NSBundle.mainBundle()
    }
    
    // return our module bundle
    return NSBundle(forClass: PasscodeLockPresenter.self)
}