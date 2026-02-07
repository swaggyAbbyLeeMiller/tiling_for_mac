import Cocoa
import SwiftUI

final class HotKeyTap {
    private var eventTap: CFMachPort?

    func start() {
        let mask = (1 << CGEventType.keyDown.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: { _, _, event, _ in
                let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                let flags = event.flags

                if flags.contains(.maskCommand) {
                    DispatchQueue.main.async {
                        switch keyCode {
                        case 123: // Left Arrow
                            print("CMD + LEFT detected")
                            snapLeft()
                        case 124: // Right Arrow
                            print("CMD + RIGHT detected")
                            snapRight()
                        case 125: // Down Arrow
                            print("CMD + DOWN detected")
                            snapDown()
                        case 126: // Up Arrow
                            print("CMD + UP detected")
                            snapUp()
                        default:
                            break
                        }
                    }
                }

                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        )

        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        } else {
            print("Failed to create event tap")
        }
    }
}

