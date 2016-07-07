import bb.cascades 1.2

Page {
    ScrollView {
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            topPadding: 30.0
            leftPadding: 10.0
            rightPadding: 10.0
            ImageView {
                imageSource: "asset:///img/B9xpjLlCQAAdu5O.jpg"
                scalingMethod: ScalingMethod.AspectFit
                horizontalAlignment: HorizontalAlignment.Center
            }
            Header {
                title: qsTr("HOW TO USE")
            }
            Label {
                text: qsTr("This is a simple URL link shortner app, which can short your URL to waa.ai/shortcode and make it easy to remember.")
                multiline: true
                textStyle.fontWeight: FontWeight.W100
            }
            Label {
                text: qsTr("You can either type the URL and make it short or directly invoke this app from your system browser. That's easy~") + String.fromCharCode(9835)
                multiline: true
                textStyle.fontWeight: FontWeight.W100
            }
            Header {
                title: qsTr("About waa.ai")
            }
            Label {
                text: qsTr("Created with love for everyone's favorite background protagonist.") + String.fromCharCode(9829)
                multiline: true
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Center
                textFit.mode: LabelTextFitMode.FitToBounds
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                text: qsTr("Visit <a href='http://waa.ai'>http://waa.ai</a> for more information !")
                multiline: true
                textStyle.fontWeight: FontWeight.W100
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
            }
            Header {
                title: qsTr("About this app")
            }
            Label {
                text: qsTr("This simple app is created by Merrick Zhang, vendor <a href='https://appworld.blackberry.com/webstore/vendor/26755/'>anpho</a> , FREE for everyone to use.")
                multiline: true
                textStyle.fontWeight: FontWeight.W100
                textFormat: TextFormat.Html
            }
            Label {
                text: qsTr("To support me, please buy my other apps !") + String.fromCharCode(9835)
                textStyle.fontWeight: FontWeight.W100
            }
        }
    }
}
