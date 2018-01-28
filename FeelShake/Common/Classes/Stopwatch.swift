//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by Kiran Kunigiri on 10/15/15.
//  Copyright © 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


// MARK: Stopwatch
protocol TrainSceneStopwatchDelegateProtocol {
    var stopwatchLabel:SKLabelNode {set get}
    
}

class Stopwatch: NSObject {
    
    var delegate: TrainSceneStopwatchDelegateProtocol!
    
    // Timer
    fileprivate var timer = Timer()
    
    // MARK: Time in a string
    /**
     String representation of the number of hours shown on the stopwatch
     */
    var strHours = "00"
    /**
     String representation of the number of minutes shown on the stopwatch
     */
    var strMinutes = "00"
    /**
     String representation of the number of seconds shown on the stopwatch
     */
    var strSeconds = "00"
    /**
     String representation of the number of tenths of a second shown on the stopwatch
     */
    var strTenthsOfSecond = "00"

    /**
     String representation text shown on the stopwatch (the time)
     */
    var timeText = ""
    
    // MARK: Time in values
    /**
     The number of hours that will be shown on a stopwatch
     */
    var numHours = 0
    /**
     The number of minutes that will be shown on a stopwatch
     */
    var numMinutes = 0
    /**
     The number of seconds that will be shown on a stopwatch
     */
    var numSeconds = 0
    var initNumSeconds = 15

    /**
     The number of tenths of a second that will be shown on a stopwatch
     */
    var numTenthsOfSecond = 0
    let initNumTenthsOfSeconds = 99
    var count:Int = 0

    
    // Private variables
    fileprivate var startTime = TimeInterval()
    fileprivate var pauseTime = TimeInterval()
    fileprivate var wasPause = false
    
    
    
    /**
     Updates the time and saves the values as strings
     */
    @objc fileprivate func updateTime() {
        count+=1
        if count == 1{ initNumSeconds -= 1}
        // Save the current time
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        // Find the difference between current time and start time to get the time elapsed
        var elapsedTime: TimeInterval = currentTime - startTime
        
        // Calculate the hours of elapsed time
        numHours = Int(elapsedTime / 3600.0)
        elapsedTime -= (TimeInterval(numHours) * 3600)
        
        // Calculate the minutes of elapsed time
        numMinutes = Int(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(numMinutes) * 60)
        
        // Calculate the seconds of elapsed time
        numSeconds = Int(elapsedTime)
        elapsedTime -= TimeInterval(numSeconds)
        
        // Finds out the number of milliseconds to be displayed.
        numTenthsOfSecond = Int(elapsedTime * 100)
       
        numSeconds = initNumSeconds - numSeconds
        numTenthsOfSecond = initNumTenthsOfSeconds - numTenthsOfSecond
        
        // Save the values into strings with the 00 format
        strHours = String(format: "%02d", numHours)
        strMinutes = String(format: "%02d", numMinutes)
        strSeconds = String(format: "%02d", numSeconds)
        strTenthsOfSecond = String(format: "%02d", numTenthsOfSecond)
        timeText = "\(strSeconds):\(strTenthsOfSecond)"
        
        if strTenthsOfSecond == "00" && strSeconds == "00" { pause() }
    }
    
    // endAction
    // ストップウォッチが止まった時に起こすアクション
    
    
    // MARK: Public functions
    fileprivate func resetTimer() {
        startTime = Date.timeIntervalSinceReferenceDate
        strHours = "00"
        strMinutes = "00"
        strSeconds = "15"
        strTenthsOfSecond = "00"
        timeText = "\(strSeconds):\(strTenthsOfSecond)"
        
    }
    
    /**
     Starts the stopwatch, or resumes it if it was paused
     */
    func start() {
        print("start is called")
        print("time.isValid: \(timer.isValid)")
        if !timer.isValid {
            print("inside start if clause")
            print("wasPause:\(wasPause)")
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(Stopwatch.updateTime), userInfo: nil, repeats: true)
            
            if wasPause {
                startTime = Date.timeIntervalSinceReferenceDate - startTime
            } else {
                startTime = Date.timeIntervalSinceReferenceDate
            }
        }
    }
    
    /**
     Pause the stopwatch so that it can be resumed later
     */
    func pause() {
        wasPause = true
        
        timer.invalidate()
        pauseTime = Date.timeIntervalSinceReferenceDate
        startTime = pauseTime - startTime
    }
    
    /**
     Stops the stopwatch and erases the current time
     */
    func stop() {
        wasPause = false
        
        timer.invalidate()
        resetTimer()
    }
    
    
    // MARK: Value functions
    
    /**
     Converts the time into hours only and returns it
     */
    func getTimeInHours() -> Int {
        return numHours
    }
    
    /**
     Converts the time into minutes only and returns it
     */
    func getTimeInMinutes() -> Int {
        return numHours * 60 + numMinutes
    }
    
    /**
     Converts the time into seconds only and returns it
     */
    func getTimeInSeconds() -> Int {
        return numHours * 3600 + numMinutes * 60 + numSeconds
    }
    
    /**
     Converts the time into milliseconds only and returns it
     */
    func getTimeInMilliseconds() -> Int {
        return numHours * 3600000 + numMinutes * 60000 + numSeconds * 1000 + numTenthsOfSecond * 100
    }
    
}


// MARK: LabelStopwatch

/**
 * Subclass of Stopwatch
 *
 * This class automatically updates any SKSpriate wih the stopwatch time.
 * This makes it easier to use the stopwatch. All you have to do is create a
 * LabelStopwatch and pass in your UILabel as the parameter. Then the LabelStopwatch
 * will automatically update your label as you call the start, stop, or reset functions.
 */

class LabelStopwatch: Stopwatch {
    
    /**
     The label that will automatically be updated according to the stopwatch
     */
    var label :SKLabelNode!
    
    
    /**
     Creates a stopwatch with a label that it will constantly update
     */
    init(label: SKLabelNode) {
        self.label = label
    }
    
    override fileprivate func updateTime() {
        super.updateTime()
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        self.delegate.stopwatchLabel.text = "\(strSeconds):\(strTenthsOfSecond)"
    }
    
    override fileprivate func resetTimer() {
        super.resetTimer()
        self.delegate.stopwatchLabel.text = "\(strSeconds):\(strTenthsOfSecond)"
    }
    
}








