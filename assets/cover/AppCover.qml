import bb.cascades 1.2

SceneCover {
    property string coverText: "0 : 0 : 0"
    content: Container {
        onCreationCompleted: {
            Application.thumbnail.connect(onThumbnailed)
            Application.fullscreen.connect(onFullScreen)
        }
        function onFullScreen() {
            Qt.isMinimized = false
        }
        function onThumbnailed() {
            Qt.isMinimized = true
        }
        layout: DockLayout {}
        horizontalAlignment: HorizontalAlignment.Fill;
        verticalAlignment: VerticalAlignment.Fill;
        background: back.imagePaint;
        attachedObjects: [
            ImagePaintDefinition {
                id: back;
                repeatPattern: RepeatPattern.XY;
                imageSource: "asset:///Images/Background.amd";
            }
        ]
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center;
            verticalAlignment: VerticalAlignment.Center;
            Label {
                horizontalAlignment: HorizontalAlignment.Center
                id: coverTitle;
                text: "Timer";
                textStyle.fontSize: FontSize.Large;
                textStyle.color: Color.White;
                textStyle.fontWeight: FontWeight.W500;
            }
            Label {
                horizontalAlignment: HorizontalAlignment.Center
                id: coverClock;
                text: coverText
                textStyle.fontSize: FontSize.Large
                textStyle.color: Color.White
                textStyle.fontWeight: FontWeight.W500
            }
        }
    }
}