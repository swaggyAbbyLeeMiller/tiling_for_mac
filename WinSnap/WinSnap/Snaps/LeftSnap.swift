import Cocoa

func snapLeft() {
    guard let windowElement = WindowSnapper.focusedWindowElement(),
          let screenFrame = WindowSnapper.windowScreenFrame(windowElement: windowElement)
    else {
        print("Could not get focused window or screen")
        return
    }

    let newFrame = CGRect(
        x: screenFrame.minX,
        y: screenFrame.minY,
        width: screenFrame.width / 2,
        height: screenFrame.height
    )

    WindowSnapper.setWindowFrame(windowElement, frame: newFrame)
}
