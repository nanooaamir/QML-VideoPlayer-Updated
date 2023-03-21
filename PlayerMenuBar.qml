import QtQuick

Item {
    id: root

    required property MediaPlayer mediaPlayer

    height: menuBar.height

    signal closePlayer

    function loadUrl(url) {
        mediaPlayer.stop()
        mediaPlayer.source = url
        mediaPlayer.play()
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: qsTr("&File")

            MenuItem {
                text: qsTr("&Open")
                onTriggered: fileDialog.visible = true
            }

            MenuItem {
                text: qsTr("&URL")
                onTriggered: urlDialog.visible = true
            }

            MenuItem {
                text: qsTr("&Exit")
                onTriggered: closePlayer()
            }
        }
    }

    Dialog {
        id: urlDialog
        title: qsTr("Load URL")

        Row {
            Label {
                text: qsTr("URL:")
            }

            TextField {
                id: urlText
                Layout.fillWidth: true
                onAccepted: {
                    loadUrl(urlText.text)
                    urlText.text = ""
                    urlDialog.visible = false
                }
            }
        }

        onAccepted: {
            loadUrl(urlText.text)
            urlText.text = ""
            urlDialog.visible = false
        }

        onRejected: {
            urlText.text = ""
            urlDialog.visible = false
        }
    }

    Dialog {
        id: fileDialog
        title: qsTr("Open File")
        selectMultiple: false
        folder: shortcuts.home
        fileUrl: shortcuts.home

        onAccepted: {
            mediaPlayer.stop()
            mediaPlayer.source = fileDialog.fileUrl
            mediaPlayer.play()
        }
    }
}
