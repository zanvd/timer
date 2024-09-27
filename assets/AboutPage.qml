import bb.cascades 1.2;
import bb.system 1.2;

Page {
    id: aboutPage;
    onCreationCompleted: {
        console.log("Entering About Page.");
        Application.menuEnabled = false;
    }
    /*Setup for recognizing if the user does not have social account set up for this service.
     * 
     * property bool invokeErr: false;
    attachedObjects: [
        SystemToast {
            id: invokeError;
            body: "Account is not set up.";
            onFinished: {
                invokeErr = false;
            }
        }
    ]*/
    titleBar: TitleBar {
        title: qsTr("About");
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
                    text: "About";
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
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom;
                }
                attachedObjects: SystemToast {
                    id: socialToast;
                    body: "Please check your log-in status.";
                }
                horizontalAlignment: HorizontalAlignment.Fill;
                verticalAlignment: VerticalAlignment.Fill;
                Container {
                    topPadding: _ui.du(3);
                    leftPadding: topPadding;
                    rightPadding: topPadding;
                    bottomPadding: topPadding;
                    horizontalAlignment: HorizontalAlignment.Center;
                    verticalAlignment: VerticalAlignment.Center;
                    Label {
                        horizontalAlignment: HorizontalAlignment.Center;
                        text: Application.applicationName + " " + Application.applicationVersion;
                        textStyle.base: SystemDefaults.TextStyles.BigText;
                        textStyle.color: Color.create("#00CCFF");
                    }
                }
                Container {
                    id: textContainer;
                    topPadding: _ui.du(3);
                    leftPadding: _ui.du(1);
                    rightPadding: leftPadding;
                    bottomPadding: topPadding;
                    horizontalAlignment: HorizontalAlignment.Center;
                    verticalAlignment: VerticalAlignment.Center;
                    TextArea {
                        textStyle.fontWeight: FontWeight.W500;
                        textStyle.textAlign: TextAlign.Center;
                        textStyle.color: Color.create("#00CCFF")
                        text: "Thank you for downloading Timer by zApp!
                        \r\nI hope you enjoy this app. Expect upgrades and enhancements in the future to make your experience even more enjoyable.
                        \r\nSuggestions, criticism and general feedback are welcome. Use the email button to start your feedback message.
                        \r\nIf you like the app, please leave a review! If you have an issue, contact me as noted above before making a review, so that I can address any issues and make changes.
                        \r\nEveryone loves to be social, so please share!";
                        editable: false;
                        focusHighlightEnabled: false;
                        touchPropagationMode: TouchPropagationMode.None;
                    }
                }
                Container {
                    id: buttonsContainer;
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight;
                    }
                    horizontalAlignment: HorizontalAlignment.Center;
                    verticalAlignment: VerticalAlignment.Bottom;
                    topPadding: _ui.du(3);
                    leftPadding: _ui.du(20);
                    rightPadding: leftPadding;
                    bottomPadding: _ui.du(10);
                    TextField {
                        id: mailField;
                        visible: false;
                        hintText: "Text to send...";
                    }
                    ImageButton {
                        id: supportMail;
                        defaultImageSource: "asset:///Images/ic_email.png";
                        preferredHeight: _ui.du(13);
                        preferredWidth: _ui.du(13);
                        maxHeight: _ui.du(13);
                        maxWidth: _ui.du(13);
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1;
                        }
                        verticalAlignment: VerticalAlignment.Center;
                        onClicked: {
                            invokeMail.query.setMimeType("text/plain");
                            var date = new Date();
                            var subject = "Timer Support";
                            var body = mailField.text;
                            var uri = "mailto:zapp.devcom@gmail.com?subject=" + subject + "&body=" + body;
                            invokeMail.query.setUri(uri);
                            invokeMail.query.setInvokeTargetId("sys.pim.uib.email.hybridcomposer");
                            invokeMail.query.updateQuery();
                        }
                        attachedObjects: [
                            Invocation {
                                id: invokeMail;
                                onArmed: {
                                    trigger("bb.action.SENDEMAIL");
                                }
                            }
                        ]
                    }
                    
                    TextField {
                        id: socialBody;
                        visible: false;
                        text: (qsTr("Timer app by zApp is now avaliable! Get it here: http://appworld.blackberry.com/webstore/content/59946349") + Retranslate.onLocaleOrLanguageChanged);
                    }
                    ImageButton {
                        id: share;
                        defaultImageSource: "asset:///Images/ic_share.png";
                        preferredHeight: _ui.du(11);
                        preferredWidth: _ui.du(11);
                        maxHeight: _ui.du(11);
                        maxWidth: _ui.du(11);
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1;
                        }
                        verticalAlignment: VerticalAlignment.Center;
                        onClicked: {
                            shareInvoke.trigger("bb.action.SHARE");
                        }
                        attachedObjects: [
                            Invocation {
                                id: shareInvoke;
                                query{
                                    mimeType: "text/plain";
                                    invokeActionId: "bb.action.SHARE";
                                }
                            }
                        ]
                    }
                }
            }
        }
    }
}
