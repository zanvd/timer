/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2
import bb.platform 1.2
import bb.system 1.2
import bb.device 1.2
import bb.multimedia 1.2

NavigationPane {
    id: navigationPane
    
    property bool timerIsActive: false
    property int originalTimerInSeconds: 0
    property string originalTimerInString
    
    //Start or Stop timer based on "timerIsActive" variable.
    onTimerIsActiveChanged: {
        if (timerIsActive) {
            timer.start()
            clock.active = true;
        }
        else {
            timer.stop()
            clock.active = false;
        }
    }
    //Method to determine led color and flash it.
    function setLedColorAndMakeItFlash() {
        console.log("Setting led color.")
        //Set led color based on saved settings.
        if (_settings.value("ledColor", 1) == 0)
            led.color = LedColor.Blue
        else if (_settings.value("ledColor", 1) == 1)
            led.color = LedColor.Cyan
        else if (_settings.value("ledColor", 1) == 2)
            led.color = LedColor.Green
        else if (_settings.value("ledColor", 1) == 3)
            led.color = LedColor.Magenta
        else if (_settings.value("ledColor", 1) == 4)
            led.color = LedColor.Red
        else if (_settings.value("ledColor", 1) == 5)
            led.color = LedColor.White
        else if (_settings.value("ledColor", 1) == 6)
            led.color = LedColor.Yellow
        
        //Make it flash.
        console.log("Making led flash.")
        led.flash()
    }
    
    //Set top menu bar.
    Menu.definition: MenuDefinition {
        settingsAction: SettingsActionItem {
            onTriggered: navigationPane.push(settingsPage.createObject())
        }
        
        actions: [
            ActionItem {
                title: qsTr("About")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///Images/ic_info.png"
                onTriggered: navigationPane.push(aboutPage.createObject())
            },
            ActionItem {
                title: qsTr("More Apps");
                ActionBar.placement: ActionBarPlacement.OnBar;
                imageSource: "asset:///Images/ic_open.png";
                onTriggered: invoke.trigger("bb.action.OPEN");
            }
        ]
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: settingsPage;
            SettingsPage {
                //Change font weight bool.
                onFontButtonChanged: {
                    console.log("FontW Setting: " + Boolean(_settings.value("fontButton", false)));
                    if (_settings.value("fontButton", false)) {
                        clock.fontW = true;
                    } else {
                        clock.fontW= false;
                    }
                }
            }
        },
        ComponentDefinition {
            id:aboutPage;
            AboutPage {}
        },
        Invocation {
            id: invoke;
            query {
                invokeTargetId: "sys.appworld";
                uri: "appworld://vendor/91870";
            }
        },
        ComponentDefinition {
            id: sceneCover
            SceneCover {}
        },
        //Clock timer.
        Timer {
            id: timer;
            interval: 1000;
            onTimeout: {
                //Decrease the value.
                clock.timerInSeconds--;
                
                if (Qt.isMinimized) {
                    console.log("Application is minimized.");
                    Application.cover.coverText = clock.timerString;
                }
                
                //Check if timer is done.
                if (clock.timerInSeconds == 0) {
                    console.log("Timer is done! Warn the user.");
                    
                    //Save global sound and led settings.
                    mainPage.notifSoundSettings = (notificationGlobalSettings.sound == NotificationPolicy.Allow ? true : false)
                    mainPage.notifLedSettings = (notificationGlobalSettings.led == NotificationPolicy.Allow ? true : false)
                    mainPage.notifVibSettings = (notificationGlobalSettings.vibrate == NotificationPolicy.Allow ? true: false)
                    //Set sound global settings to Deny.
                    notificationGlobalSettings.setSound(NotificationPolicy.Deny)
                    //Set led global settings to Deny.
                    notificationGlobalSettings.setLed(NotificationPolicy.Deny)
                    //Set vibrate global setting to Deny.
                    notificationGlobalSettings.setVibrate(NotificationPolicy.Deny)
                    
                    //If user choose to play the sound.
                    if(_settings.value("soundButton", true)) {
                        console.log("User choose sound.")
                        mp.play()
                    }
                    //If user choose to vibrate.
                    if(_settings.value("vibrateButton", true)) {
                        console.log("User choose vibrate.");
                        //Call vibrate timer.
                        timerForVibrate.start();
                    }
                    //If user choose to get led.
                    if(_settings.value("ledButton", true)) {
                        console.log("User choose LED.");
                        //Call led function.
                        setLedColorAndMakeItFlash();
                    }
                    //Show notification dialog.
                    console.log("Show notification dialog.");
                    notifDialog.show();
                    //Set timer to OFF.
                    console.log("Set timer to OFF.");
                    timerIsActive = false;
                }
            }
        },
        
        Timer {
            //Vibrate timer.
            id: timerForVibrate;
            interval: 500;
            onTimeout: vibration.start(100, 250);
        },
        //Notification dialog shown when timer is done.
        NotificationDialog {
            id: notifDialog;
            title: "Timer";
            body: originalTimerInString;
            //soundUrl: _publicDir + "timer.wav";
            //repeat: true;
            buttons: SystemUiButton {
                label: "Done";
            }
            onFinished: {
                //Set global settings back to previous value.
                console.log("Global settings changed.")
                if(mainPage.notifSoundSettings)
                    notificationGlobalSettings.setSound(NotificationPolicy.Allow)
                if(mainPage.notifLedSettings)
                    notificationGlobalSettings.setLed(NotificationPolicy.Allow)
                if(mainPage.notifVibSettings)
                    notificationGlobalSettings.setVibrate(NotificationPolicy.Allow)
                console.log("Global Sound: " + Boolean(notificationGlobalSettings.sound))
                console.log("Global LED: " + Boolean(notificationGlobalSettings.led))
                console.log("Global Vibrate: " + Boolean(notificationGlobalSettings.vibrate))
                //Stop vibration, led and sound.
                timerForVibrate.stop();
                led.cancel();
                mp.stop()
                buttons.pauseEnable = false
            }
        },
        //Check changes in sound's and led's changes.
        NotificationApplicationSettings {
            id: notficationApplicationSettings;
            onSoundChanged: {
                if (sound == NotificationPolicy.Allow) {
                    console.log("Sound notification is allowed.");
                }
                else if (sound == NotificationPolicy.Deny) {
                    console.log("Sound notification is not allowed.");
                }
                else
                    console.log("Sound notification can not be retrieved.");
            }
            onLedChanged: {
                if (led == NotificationPolicy.Allow) {
                    console.log("LED notification is allowed.");
                }
                else if (led == NotificationPolicy.Deny) {
                    console.log("LED notification is not allowed.");
                }
            }
        },
        
        NotificationGlobalSettings {
            id: notificationGlobalSettings;
        },
        
        VibrationController {
            id: vibration;
        },
        
        Led {
            id: led;
        },
        SystemToast {
            id: inputError
            body: "Input has to be between 0 and 59 included."
            onFinished: {
                clock.inputErr = false
            }
        },
        SystemToast {
            id: inputErrorHours
            body: "Input can not be a negative number."
            onFinished: {
                clock.inputErrHours = false
            }
        }
    ]
    
    Page {
        id: mainPage
        //Variables to temporary store Global Settings values.
        property bool notifSoundSettings
        property bool notifLedSettings
        property bool notifVibSettings
        
        titleBar: TitleBar {
            title: qsTr("Timer");
            kind: TitleBarKind.FreeForm;
            scrollBehavior: TitleBarScrollBehavior.Sticky;
            kindProperties: FreeFormTitleBarKindProperties {
                Container {
                    verticalAlignment: VerticalAlignment.Center;
                    topPadding: _ui.du(2);
                    leftPadding: _ui.du(2);
                    background: Color.Black;
                    layout: StackLayout {}
                    Label {
                        text: "Timer";
                        textStyle.fontSize: FontSize.XLarge;
                        textStyle.fontWeight: FontWeight.W800;
                        textStyle.color: Color.create("#0299CC");
                    }
                }
            }
        }
        Container {
            background:back.imagePaint;
            attachedObjects: [
                ImagePaintDefinition {
                    id: back;
                    repeatPattern: RepeatPattern.XY;
                    imageSource: "asset:///Images/Background.amd";
                }, 
                MediaPlayer {
                    id: mp
                    sourceUrl: "asset:///sound/timer.wav"
                    repeatMode: RepeatMode.Track
                }
            ]
            onCreationCompleted: {
                Application.setCover(sceneCover)
            }
            ScrollView {
                horizontalAlignment: HorizontalAlignment.Fill;
                verticalAlignment: VerticalAlignment.Fill;
                Container {
                    layout: DockLayout {}
                    horizontalAlignment: HorizontalAlignment.Fill;
                    verticalAlignment: VerticalAlignment.Fill;
                    //Clock object.
                    Clock {
                        id: clock;
                        //Check for input errors and display appropriate toast.
                        onInputErrChanged: {
                            if(inputErr)
                                inputError.show()
                            console.log("InputError: " +  Boolean(inputErr))
                        }
                        onInputErrHoursChanged: {
                            if(inputErrHours)
                                inputErrorHours.show()
                            console.log("InputErrorHours: " + Boolean(inputErrHours))
                        }
                        onTimerInSecondsChanged: {
                            console.log("timerInSeconds: " + timerInSeconds);
                        }
                    }
                    StartResetStopButtons {
                        id: buttons
                        bottomPadding: _ui.du(3);
                        onStart: {
                            //Save original time value to reset button and NotificationDialog.
                            if (!clock.active) {
                                console.log("Start pressed. Save original value to reset and Notification Dialog");
                                originalTimerInSeconds = clock.timerInSeconds;
                                originalTimerInString = clock.timerString;
                            }
                            
                            //Sets timer to ON.
                            console.log("Start is pressed. Set timer to ON.");
                            if(!timerIsActive)
                                timerIsActive = true;
                            clock.active = true;
                            buttons.pauseEnable = true
                        }
                        onReset: {
                            //Sets timer to OFF.
                            console.log("Reset pressed. Set timer to OFF.");
                            timerIsActive = false;
                            clock.active = false;
                            buttons.pauseEnable = false
                            
                            //Put the original values in the TextFields.
                            console.log("Put original values in the TextFields.");
                            clock.timerInSeconds = originalTimerInSeconds
                            Application.cover.coverText = clock.timerString
                        }
                        onStop: {
                            //Sets timer to OFF.
                            console.log("Stop is pressed. Set timer to OFF.")
                            timerIsActive = false
                            buttons.pauseEnable = false
                            Application.cover.coverText = clock.timerString
                        }
                    }
                }
            }
        }
    }
    onPopTransitionEnded: {
        //Destroy the popped Page once the back transition has ended.
        console.log("Destroy the popped transition Page once the back transition has ended.");
        Application.menuEnabled = true;
    }
}