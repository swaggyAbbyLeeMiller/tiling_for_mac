import Cocoa

struct WindowSnapper {

    static func focusedWindowElement() -> AXUIElement? {
        let systemWideElement = AXUIElementCreateSystemWide()

        var focusedApp: AnyObject?
        let appResult = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXFocusedApplicationAttribute as CFString,
            &focusedApp
        )

        guard appResult == .success, let appElement = focusedApp as? AXUIElement else {
            print("Failed to get focused application")
            return nil
        }

        var focusedWindow: AnyObject?
        let windowResult = AXUIElementCopyAttributeValue(
            appElement,
            kAXFocusedWindowAttribute as CFString,
            &focusedWindow
        )

        guard windowResult == .success, let windowElement = focusedWindow as? AXUIElement else {
            print("Failed to get focused window")
            return nil
        }

        return windowElement
    }

    static func windowScreenFrame(windowElement: AXUIElement) -> CGRect? {
        var positionValue: CFTypeRef?
        var sizeValue: CFTypeRef?

        let posResult = AXUIElementCopyAttributeValue(windowElement, kAXPositionAttribute as CFString, &positionValue)
        let sizeResult = AXUIElementCopyAttributeValue(windowElement, kAXSizeAttribute as CFString, &sizeValue)

        guard posResult == .success, sizeResult == .success,
              let posVal = positionValue as? AXValue,
              let sizeVal = sizeValue as? AXValue else {
            print("Failed to get window position or size")
            return nil
        }

        var windowPosition = CGPoint.zero
        var windowSize = CGSize.zero

        AXValueGetValue(posVal, .cgPoint, &windowPosition)
        AXValueGetValue(sizeVal, .cgSize, &windowSize)

        let windowFrame = CGRect(origin: windowPosition, size: windowSize)

        let screen = NSScreen.screens.first(where: { $0.frame.intersects(windowFrame) }) ?? NSScreen.main

        return screen?.frame
    }

    static func setWindowFrame(_ windowElement: AXUIElement, frame: CGRect) {
        var frameVar = frame

        guard let positionValue = AXValueCreate(.cgPoint, &frameVar.origin),
              let sizeValue = AXValueCreate(.cgSize, &frameVar.size) else {
            print("Failed to create AXValue for frame")
            return
        }

        let posResult = AXUIElementSetAttributeValue(windowElement, kAXPositionAttribute as CFString, positionValue)
        let sizeResult = AXUIElementSetAttributeValue(windowElement, kAXSizeAttribute as CFString, sizeValue)

        if posResult != .success || sizeResult != .success {
            print("Failed to set window frame")
        }
    }
}
