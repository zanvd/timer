import bb.cascades 1.2
import bb.platform 1.2

Page {
    signal fontButtonChanged();
    
    id: settingsPage;
    onCreationCompleted: {
        console.log("Entering Settings Page");
        Application.menuEnabled = false;
    }
    
    titleBar: TitleBar {
        title: qsTr("Settings");
        kind: TitleBarKind.FreeForm;
        scrollBehavior: TitleBarScrollBehavior.Sticky;
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                verticalAlignment: VerticalAlignment.Center;
                topPadding: _ui.du(2);
                leftPadding: topPadding;
                background: Color.Black;
                layout: StackLayout {}
                Label {
                    text: "Settings";
                    textStyle.fontSize: FontSize.XLarge;
                    textStyle.fontWeight: FontWeight.W800;
                    textStyle.color: Color.create("#0299CC");                    
                }
            }
        }
    }
    
    Container {
        background: back.imagePaint;
        attachedObjects: [
            ImagePaintDefinition {
                id: back;
                repeatPattern: RepeatPattern.XY;
                imageSource: "asset:///Images/Background.amd";
            }
        ]
        
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill;
            verticalAlignment: VerticalAlignment.Fill;
            Container {
                id: settingsContainer;
                layout: DockLayout {}
                horizontalAlignment: HorizontalAlignment.Fill;
                verticalAlignment: VerticalAlignment.Fill;
                
                ConsoleDebugGestureHandler {}
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Center;
                    verticalAlignment: VerticalAlignment.Center;
                    leftPadding: _ui.du(15);
                    rightPadding: leftPadding;
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight;
                        }
                        
                        Label {
                            id: soundLabel;
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            text: "Sound:";
                            textStyle.fontSize: FontSize.Large;
                            textStyle.color: Color.White;
                            textStyle.fontWeight: FontWeight.W500;
                        }
                        
                        ToggleButton {
                            id: soundButton;
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            checked: _settings.value("soundButton", true);
                            onCheckedChanged : _settings.setValue("soundButton", checked);
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight;
                        }
                        topPadding: _ui.du(3);
                        Label {
                            id: vibrateLabel;
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            text: "Vibrate:";
                            textStyle.fontSize: FontSize.Large;
                            textStyle.color: Color.White;
                            textStyle.fontWeight: FontWeight.W500;
                        }
                        
                        ToggleButton {
                            id: vibrateButton;
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            checked: _settings.value("vibrateButton", true);
                            onCheckedChanged: _settings.setValue("vibrateButton", checked);
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight;
                        }
                        topPadding: _ui.du(3);
                        Label {
                            id: ledLabel;
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            text: "LED:";
                            textStyle.fontSize: FontSize.Large;
                            textStyle.color: Color.White;
                            textStyle.fontWeight: FontWeight.W500;
                        }
                        
                        ToggleButton {
                            id: ledButton
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1;
                            }
                            checked: _settings.value("ledButton", true);
                            onCheckedChanged: _settings.setValue("ledButton", checked);
                        }
                    }
                    
                    Container {
                        visible: ledButton.checked;
                        topPadding: _ui.du(3);
                        maxWidth: _ui.du(50);
                        background: Color.Transparent;
                        horizontalAlignment: HorizontalAlignment.Fill;
                        DropDown {
                            id: dd;
                            title: "Led Color";
                            onSelectedIndexChanged: {
                                _settings.setValue("ledColor", selectedIndex)
                                console.log("Led selected: " + selectedIndex)
                            }
                           selectedIndex: _settings.value("ledColor", 1)
                            Option {
                                //ix = 0
                                id: blue;
                                value: "Blue";
                                text: "Blue"

                            }
                            Option {
                                //ix = 1
                                id: cyan;
                                value: "Cyan";
                                text: "Cyan";
                            }
                            Option {
                                //ix = 2
                                id: green;
                                value: "Green";
                                text: "Green";
                            }
                            Option {
                                //ix = 3
                                id: magenta;
                                value: "Magenta";
                                text: "Magenta";
                            }
                            Option {
                                //ix = 4
                                id: red;
                                value: "Red";
                                text: "Red";
                            }
                            Option {
                                //ix = 5
                                id: white;
                                value: "White";
                                text: "White";
                            }
                            Option {
                                //ix = 6
                                id: yellow;
                                value: "Yellow";
                                text: "Yellow";
                            }
                        }
                    }
                    Container {
                        topPadding: _ui.du(3);
                        bottomPadding: topPadding;
                        Container {
                            horizontalAlignment: HorizontalAlignment.Fill;
                            background: Color.White;
                            preferredHeight: 1;
                        }
                        Container {
                            topPadding: _ui.du(3);
                            bottomPadding: topPadding;
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight;
                            }
                            Label {
                                id: fontLabel;
                                text: "Bold input";
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1;
                                }
                                textStyle.fontSize: FontSize.Large;
                                textStyle.color: Color.White;
                                textStyle.fontWeight: FontWeight.W500;
                            }
                            ToggleButton {
                                id: fontToggleButton;
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1;
                                }
                                checked: _settings.value("fontButton", false);
                                onCheckedChanged: {
                                    _settings.setValue("fontButton", checked);
                                    fontButtonChanged();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
