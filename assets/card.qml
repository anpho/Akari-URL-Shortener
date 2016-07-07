/*
 * Copyright (c) 2013-2015 BlackBerry Limited.
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
import bb.system 1.2
import bb.cascades.multimedia 1.2
NavigationPane {
    peekEnabled: true
    attachedObjects: [
        Common {
            id: co
        }
    ]
    onCreationCompleted: {
        state = 0;
        shortenURL = "";
        ApplicationUI.memoChanged.connect(setMemo);
    }
    property string shortenURL: ""
    property int state: 0
    property string key: ApplicationUI.getv('key', '')
    function process(data) {
        if (data['success']) {
            console.log(data['data']);
            var result = JSON.parse(data["data"]);
            if (result['success']) {
                shortenURL = result.data.url
                state = 2; //success
            } else {
                shortenURL = ""
                errToast.body = qsTr("Error occured. Code: " + result['status'])
                errToast.show()
                state = 3; //error
            }
        } else {
            shortenURL = ""
            errToast.body = qsTr("Internet unreachable.")
            errToast.show()
            state = 3;
        }
    }
    Page {
        actions: [
            ActionItem {
                title: qsTr("Shorten!")
                ActionBar.placement: ActionBarPlacement.OnBar
                enabled: validator.valid
                onTriggered: {
                    state = 1; // process
                    var addkey = false;
                    if (addtomyaccount.checked) {
                        addkey = true;
                    }
                    if (addkey) {
                        co.ajax("GET", "https://api.waa.ai/shorten", [ "url=" + longurl.text, "key=" + key ], function(d) {
                                process(d)
                            }, [])
                    } else {
                        co.ajax("GET", "https://api.waa.ai/shorten", [ "url=" + longurl.text ], function(d) {
                                process(d)
                            }, [])
                    }
                }
                attachedObjects: SystemToast {
                    id: errToast
                }
                imageSource: "asset:///icon/ic_done.png"
            }
        ]
        Container {
            layout: DockLayout {

            }
            ImageView {
                imageSource: "asset:///img/waaai.jpg"
                scalingMethod: ScalingMethod.AspectFill
                loadEffect: ImageViewLoadEffect.FadeZoom
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }
            ImageView {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Bottom
                scalingMethod: ScalingMethod.AspectFill
                imageSource: "asset:///img/akarin.png"
                visible: state == 2
                loadEffect: ImageViewLoadEffect.Subtle
                onVisibleChanged: {
                    if (visible) {
                        showavator.play()
                    } else {
                        hideavator.play()
                    }
                }
                id: leftavator
                animations: [
                    FadeTransition {
                        target: leftavator
                        toOpacity: 1
                        id: showavator
                    },
                    FadeTransition {
                        target: leftavator
                        toOpacity: 0
                        id: hideavator
                    }
                ]
            }
            Container {
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                topPadding: 20.0
                leftPadding: 20.0
                rightPadding: 20.0
                bottomPadding: 20.0
                ImageView {
                    property variant imagearray: [ "asset:///img/utj.png", "asset:///img/akari_leaf.png", "asset:///img/akari-daisuki.png",
                        "asset:///img/akari-hair-extensions.png" ]
                    scalingMethod: ScalingMethod.AspectFit
                    imageSource: imagearray[state]
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.618
                    }
                    loadEffect: ImageViewLoadEffect.FadeZoom
                }
                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    Label {
                        text: qsTr("Paste your URL here")
                        textStyle.color: Color.Black
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight

                        }

                        TextField {
                            id: longurl
                            inputMode: TextFieldInputMode.Url
                            textFormat: TextFormat.Plain
                            input.submitKey: SubmitKey.Done
                            input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
                            validator: Validator {
                                id: validator
                                errorMessage: qsTr("Not a valid URL")
                                onValidate: {
                                    state = ValidationState.InProgress
                                    var r = longurl.text.match("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]");
                                    if (r) {
                                        state = ValidationState.Valid
                                    } else {
                                        state = ValidationState.Invalid
                                    }
                                }
                                mode: ValidationMode.Immediate
                            }
                            onTextChanging: {
                                state = 0;
                            }
                            textStyle.fontWeight: FontWeight.W100
                            horizontalAlignment: HorizontalAlignment.Fill
                            hintText: qsTr("Only http / https allowed.")
                        }
                        Button {
                            imageSource: "asset:///icon/ic_paste.png"
                            preferredWidth: 1.0
                            onClicked: {
                                longurl.text = ApplicationUI.getClipboard();
                            }
                        }
                    }
                    CheckBox {
                        text: qsTr("Add to my account")
                        id: addtomyaccount
                        visible: key.length > 0
                    }
                    Label {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: "......"
                        textStyle.fontSize: FontSize.XLarge
                        visible: state == 1
                        textStyle.color: Color.Black
                    }
                    Label {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: "B E C A M E"
                        textStyle.fontSize: FontSize.XLarge
                        visible: state == 2
                        textStyle.color: Color.Black
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        visible: state == 2
                        topMargin: 20.0
                        TextField {
                            text: shortenURL
                            horizontalAlignment: HorizontalAlignment.Fill
                            textStyle.fontWeight: FontWeight.W100
                            hintText: ""
                        }
                        Button {
                            imageSource: "asset:///icon/ic_copy.png"
                            preferredWidth: 1.0
                            onClicked: {
                                ApplicationUI.setClipboard(shortenURL)
                            }
                        }
                    }
                }
            }
        }

    }
    function setMemo(new_memo) {
        longurl.text = new_memo;
    }
}
