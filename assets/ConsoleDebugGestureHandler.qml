import bb.cascades 1.2
import bb.system 1.2

    Container {
        layout: DockLayout {}
        horizontalAlignment: HorizontalAlignment.Fill;
        verticalAlignment: VerticalAlignment.Fill;
        
        property double numberOfDoubleTaps: 0;
        
        gestureHandlers: [
            DoubleTapHandler {
                onDoubleTapped: {
                    numberOfDoubleTaps++;
                    if (numberOfDoubleTaps == 2) {
                        numberOfDoubleTaps = 0;
                        if(_settings.value("sendToConsoleDebug", false)) {
                            console.log("ConsoleDebug ended.");
                            _settings.setValue("sendToConsoleDebug", !_settings.value("sendToConsoleDebug", false));
                        }
                        else {
                            _settings.setValue("secondToConsoleDebug", !_settings.value("sendToConsoleDebug", false));
                            console.log("ConsoleDebug started.");
                        }
                        systemToast.body = "ConsoleDebug mode set to: " + (_settings.value("sendToConsoleDebug", false) ? "ON" : "OFF");
                        systemToast.show();
                    }
                }
                attachedObjects: [
                    SystemToast {
                        id: systemToast;
                    }
                ]
            }
        ]
    }
