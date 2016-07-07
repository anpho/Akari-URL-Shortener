import bb.cascades 1.2
import bb.system 1.2
Page {
    ScrollView {
        Container {
            leftPadding: 10.0
            rightPadding: 10.0
            topPadding: 30.0
            ImageView {
                imageSource: "asset:///img/CEW8XEJWYAArzWM.jpg"
                scalingMethod: ScalingMethod.AspectFill
                horizontalAlignment: HorizontalAlignment.Center

            }
            Header {
                title: qsTr("My Account")
            }
            Label {
                text: qsTr("You should create an account in waa.ai in order to get your own app key.")
                multiline: true
                textFormat: TextFormat.Html
            }
            TextField {
                hintText: qsTr("Your account Key")
                text: ApplicationUI.getv('key', '')
                id: keytext
                validator: Validator {
                    mode: ValidationMode.Immediate
                    errorMessage: qsTr("Not a valid key")
                    onValidate: {
                        if (keytext.text.length == 32) {
                            valid = true;
                        } else {
                            valid = false;
                        }
                    }
                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                Button {
                    text: qsTr("Save")
                    enabled: keytext.validator.valid
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        ApplicationUI.setv('key', keytext.text);
                        sst.show();
                    }
                    attachedObjects: [
                        SystemToast {
                            id: sst
                            body: qsTr("App Key Saved.")
                        }
                    ]
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0

                    }
                }
                Button {
                    text: qsTr("Clear")
                    enabled: ApplicationUI.getv('key', '').length > 0
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        ApplicationUI.setv('key', "");
                        keytext.text = "";
                        sstclear.show();
                    }
                    attachedObjects: [
                        SystemToast {
                            id: sstclear
                            body: qsTr("App Key Cleared.")
                        }
                    ]
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0

                    }
                }
            }

            Divider {

            }
            Label {
                text: qsTr("Open waa.ai register page: <a href='http://waa.ai/signup'>Sign Up Account</a>")
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Right
                textStyle.fontWeight: FontWeight.W100
            }
            Label {
                text: qsTr("Open waa.ai my account page: <a href='http://waa.ai/account'>My Account</a>")
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Right
                textStyle.fontWeight: FontWeight.W100
            }
        }
    }
}
