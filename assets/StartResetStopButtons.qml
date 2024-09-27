import bb.cascades 1.2

Container {
    signal start();
    signal reset();
    signal stop();
    property bool pauseEnable: false
    
    verticalAlignment: VerticalAlignment.Bottom;
    horizontalAlignment: HorizontalAlignment.Center;
    
    Container {
        id: startButtonContainer;
        horizontalAlignment: HorizontalAlignment.Center;
        
        ImageButton {
            id: startButton1;
            defaultImageSource: enabled ? "asset:///Images/startButton2.png" : disabledImageSource.toString();
            disabledImageSource: "asset:///Images/startButton2Disabled.png";
            preferredHeight: _ui.du(15);
            preferredWidth: preferredHeight;
            enabled: ((clock.timerInSeconds != 0) && !timerIsActive);
            onClicked: start()
            horizontalAlignment: HorizontalAlignment.Center
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: _ui.du(3)
            
            Button {
                text: "Reset"
                onClicked: reset()
            }
            
            Button {
                text: "Pause"
                onClicked: stop()
                enabled: pauseEnable ? true : false
            }
        }
    }
}
