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
NavigationPane {
    id: nav
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                var about = Qt.createComponent("page-about.qml").createObject(nav);
                nav.push(about);
            }
        }
        settingsAction: SettingsActionItem {
            onTriggered: {
                var settings = Qt.createComponent("page-settings.qml").createObject(nav);
                nav.push(settings);
            }
        }
        actions: [
            ActionItem {
                title: qsTr("Review")
                imageSource: "asset:///icon/ic_edit_bookmarks.png"
                onTriggered: {
                    Qt.openUrlExternally("appworld://content/59962565")
                }
            }
        ]
    }
    Page {
        Container {
            layout: DockLayout {

            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
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
            }
            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                Container {
                    Button {
                        text: qsTr("Shorten URL")
                        onClicked: {
                            ApplicationUI.invokeCard("")
                            //                            var card = Qt.createComponent("card.qml").createObject(nav);
                            //                            nav.push(card)
                        }
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                }
            }
        }
    }

}