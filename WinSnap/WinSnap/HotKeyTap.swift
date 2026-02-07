//
//  HotKeyTap.swift
//  WinSnap
//
//  Created by alexa neff on 2/7/26.

import Cocoa

final class HotKeyTap {
    private var eventTap: CFMachPort?

    func start() {
        let mask = (1 << CGEventType.keyDown.rawValue)

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: { _, type, event, _ in
                let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                let flags = event.flags

                if flags.contains(.maskCommand) && keyCode == 123 {
                    print("CMD + LEFT")
                }

                return Unmanaged.passRetained(event)
            },
            userInfo: nil
        )

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap!, enable: true)
    }
}

