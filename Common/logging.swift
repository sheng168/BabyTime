//
//  LoggingPrint.swift
//

//import Foundation
//import SwiftyBeaver

/**
 Prints the filename, function name, line number and textual representation of `object` and a newline character into
 the standard output if the build setting for "Active Complilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
 
 The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
 
 Only the first parameter needs to be passed to this funtion.
 
 The textual representation is obtained from the `object` using `String(reflecting:)` which works for _any_ type.
 To provide a custom format for the output make your object conform to `CustomDebugStringConvertible` and provide your format in
 the `debugDescription` parameter.
 
 :param: object   The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
 :param: file     The name of the file, defaults to the current file without the ".swift" extension.
 :param: function The name of the function, defaults to the function within which the call is made.
 :param: line     The line number, defaults to the line number within the file that the call is made.
 */
func debug<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
//    logger.debug("ok")
//    log.debug(object(), file, function, line: line)
//    log
    #if DEBUG_
        let value = object()
        let fileURL = NSURL(string: file.replacingOccurrences(of: " ", with: "+"))?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
    #endif
}

class log {
    static func info(_ msg: Any) {
        print(msg)
    }
    static func error(_ msg: Any) {
        print(msg)
    }
    static func debug(_ msg: Any) {
        print(msg)
    }
}
//func logger() -> SwiftyBeaver.Type {
//    let log = SwiftyBeaver.self
//    //return log
//    
//    // add log destinations. at least one is needed!
//    let console = ConsoleDestination()  // log to Xcode Console
//    console.minLevel = .verbose
//    // log thread, date, time in milliseconds, level & message
//    let f = console.format
//    console.format = "$T " + f
////    console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
//
////    console.asynchronously = false
//    
//    let file = FileDestination()  // log to default swiftybeaver.log file
//    log.addDestination(console)
//    log.addDestination(file)
//    
//    let platform = SBPlatformDestination(appID: "dGP8ok", appSecret: "mhx6e0qsmr4thvy6cnKydbx4cEqzBvdg", encryptionKey: "xMduO5nxgJkkwzsvdnuzrj4jwr0seyb4")
//    platform.minLevel = .info
//    log.addDestination(platform)
//    log.info("swifty \(String(describing: file.logFileURL))")
//    
//    return log
//}
//
