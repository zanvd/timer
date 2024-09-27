import bb.cascades 1.2;
import bb.system 1.2;

Container {
    //Variable that stores timer values in seconds.
    property int timerInSeconds: ((Number(hours.text) * 3600) + (Number(minutes.text) * 60) + Number(seconds.text));
    //Variable that stores timer values in string and outputs in digital clock format.
    property string timerString: hours.text + " : " + minutes.text + " : " + seconds.text;
    //Variable that checks if Timer is active.
    property bool active: false;
    property bool activeInput: false;
    //Variables that check for input error.
    property bool inputErr: false
    property bool inputErrHours: false
    property int charCode1;
    property int charCode2;
    //Variable that checks for font weight settings.
    property bool fontW: _settings.value("fontButton", false);
    
    //Change timer variables accordingly.
    onTimerInSecondsChanged: {
        var hoursNumber = Math.floor(timerInSeconds / 3600);
        var minutesNumber = Math.floor((timerInSeconds - (hoursNumber * 3600)) / 60);
        var secondsNumber = timerInSeconds - (hoursNumber * 3600) - (minutesNumber * 60);
        hours.text = String(hoursNumber);
        minutes.text = String(minutesNumber);
        seconds.text = String(secondsNumber);
        Application.cover.coverText = hours.text + " : " + minutes.text + " : " + seconds.text;
    }
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight;
    }
    horizontalAlignment: HorizontalAlignment.Center;
    verticalAlignment: VerticalAlignment.Center;
    leftPadding: _ui.du(3);
    rightPadding: _ui.du(3);
    bottomPadding: _ui.du(12.5);
    
    TextField {
        id: hours;
        verticalAlignment: VerticalAlignment.Center;
        textStyle.textAlign: TextAlign.Center;
        textStyle.fontSize: FontSize.XXLarge;
        textStyle.fontWeight: fontW ? FontWeight.W900 : FontWeight.Default;
        preferredWidth: _ui.du(15);
        inputMode: TextFieldInputMode.NumbersAndPunctuation;
        maximumLength: 2;
        text: "0";
        hintText: "hh";
        enabled: !active;
        onFocusedChanged: {
            if (focused) {
                activeInput = false;
                hours.editor.setSelection(0, hours.text.length);
            } else {
                hours.editor.setSelection(0, 0);
                if (hours.text == "")
                    hours.text = "0";
            }
        }
        //Get new value in variable timerInSeconds.
        onTextChanged: {
            if (hours. text == "00")
                hours.text = "0";
            charCode1 = hours.text.charCodeAt(0);
            if (hours.text.length > 1)
                charCode2 = hours.text.charCodeAt(1);
            else
                charCode2 = -1;
            //Check if input is valid.
            clockValidator.validate();
            if (clockValidator.valid) {
                //Check if input is negative.
                if (Number(hours.text) < 0)
                    inputErrHours = true;
                if (!activeInput && !inputErrHours) {
                    timerInSeconds = ((Number(hours.text) * 3600) + (Number(minutes.text) * 60) + Number(seconds.text));
                    console.log("Hours field changed: " + hours.text);
                } else if (inputErrHours) {
                    console.log("Input Error.");
                    hours.text = "0";
                }
            } else {
                hours.text = "0";
                inputError.show();
            }
        }
    }

    Label {
        text: ":"
        textStyle.fontSize: FontSize.XXLarge;
        textStyle.color: Color.White;
        verticalAlignment: VerticalAlignment.Center;
    }

    TextField {
        id: minutes
        verticalAlignment: VerticalAlignment.Center;
        textStyle.textAlign: TextAlign.Center;
        textStyle.fontSize: FontSize.XXLarge;
        textStyle.fontWeight: fontW ? FontWeight.W900 : FontWeight.Default;
        preferredWidth: _ui.du(15);
        inputMode: TextFieldInputMode.NumbersAndPunctuation;
        maximumLength: 2;
        text: "0";
        hintText: "mm";
        enabled: !active;
        onFocusedChanged: {
            if (focused) {
                activeInput = false;
                minutes.editor.setSelection(0, minutes.text.length);
            } else {
                minutes.editor.setSelection(0, 0);
                if (minutes.text == "")
                    minutes.text = "0";
            }
        }
        //Get new value in variable timerInSeconds.
        onTextChanged: {
            if (minutes.text == "00")
                minutes.text = "0";
            charCode1 = minutes.text.charCodeAt(0);
            if (minutes.text.length > 1)
                charCode2 = minutes.text.charCodeAt(1);
            else
                charCode2 = -1;
            //Check if input is valid.
            clockValidator.validate();
            if (clockValidator.valid) {
                if (Number(minutes.text) > 59 || Number(minutes.text) < 0)
                    inputErr = true;
                console.log("InputMinError: " + inputErr);
                //Check if input is withing boundaries.
                if (! activeInput && ! inputErr) {
                    timerInSeconds = ((Number(hours.text) * 3600) + (Number(minutes.text) * 60) + Number(seconds.text));
                    console.log("Minutes field changed: " + minutes.text);
                } else if (inputErr) {
                    console.log("Input Error.");
                    minutes.text = "0";
                }
            } else {
                minutes.text = "0";
                inputError.show();
            }
        }
    }

    Label {
        text: ":";
        textStyle.fontSize: FontSize.XXLarge;
        textStyle.color: Color.White;
        verticalAlignment: VerticalAlignment.Center;
    }
    
    TextField {
        id: seconds
        verticalAlignment: VerticalAlignment.Center;
        textStyle.textAlign: TextAlign.Center;
        textStyle.fontSize: FontSize.XXLarge;
        textStyle.fontWeight: fontW ? FontWeight.W900 : FontWeight.Default;
        preferredWidth: _ui.du(15);
        inputMode: TextFieldInputMode.NumbersAndPunctuation;
        maximumLength: 2;
        text: "0";
        hintText: "ss";
        enabled: !active;
        onFocusedChanged: {
            if (focused) {
                activeInput = false;
                seconds.editor.setSelection(0, seconds.text.length);
            } else {
                seconds.editor.setSelection(0, 0);
                if (seconds.text == "")
                    seconds.text = "0";
            }
        }
        //Get new value in variable timerInSeconds.
        onTextChanged: {
            if (seconds.text == "00")
                seconds.text = "0";
            charCode1 = seconds.text.charCodeAt(0);
            if (seconds.text.length > 1)
                charCode2 = seconds.text.charCodeAt(1);
            else
                charCode2 = -1;
            //Check if input is valid.
            clockValidator.validate();
            if (clockValidator.valid) {
                //Check if input is withing boundaries.
                if(Number(seconds.text) > 59 || Number(seconds.text) < 0)
                    inputErr = true;
                if(!activeInput && !inputErr) {
                    timerInSeconds = ((Number(hours.text) * 3600) + (Number(minutes.text) * 60) + Number(seconds.text));
                    console.log("Seconds field changed: " + seconds.text);
                }
                else if(inputErr) {
                    console.log("Input Error.");
                    seconds.text = "0";
                }
            }
            else {
                seconds.text = "0";
                inputError.show();
            }
        }
    }
    attachedObjects: [
        Validator {
            id: clockValidator;
            mode: ValidationMode.Immediate;
            errorMessage: "Incorrect input."
            onValidate: {
                if (charCode2 == -1) {
                    if (charCode1 < 48 || charCode1 > 57)
                        state = ValidationState.Invalid;
                    else
                        state = ValidationState.Valid;
                } else {
                    if (charCode1 < 48 || charCode2 < 48 || charCode1 > 57 || charCode2 > 57)
                        state = ValidationState.Invalid;
                    else
                        state = ValidationState.Valid;
                }
            }
        },
        SystemToast {
            id: inputError;
            body: clockValidator.errorMessage;
        }
    ]
}