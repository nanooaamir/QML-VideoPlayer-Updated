import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtMultimedia


Window {
    id: root
    width: 600
    height: 450
    visible: true
    title: qsTr("Aamir's Video Player")
    property alias source: mediaPlayer.source

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    MediaPlayer {
        id: mediaPlayer
        videoOutput: videoOutput
        audioOutput: AudioOutput {
            id: audio
            muted: playbackControl.muted
            volume: playbackControl.volume
        }
    }

    Item {
        id: menuBar

        anchors.left: parent.left
        anchors.right: parent.right

        visible: !videoOutput.fullScreen

        Rectangle {
            id: menuBarBg
            color: "#4d4d4d"
            height: 30
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Text {
            id: menuBarTitle
            text: qsTr("Aamir's Video Player")
            color: "white"
            font.pixelSize: 16
            anchors.verticalCenter: menuBarBg.verticalCenter
            anchors.left: menuBarBg.left
            anchors.leftMargin: 10
        }

        Button {
            id: closeButton
            text: qsTr("Close")
            anchors.verticalCenter: menuBarBg.verticalCenter
            anchors.right: menuBarBg.right
            anchors.rightMargin: 10
            onClicked: root.close()
        }
    }

    Rectangle {
        id: videoOutput

        property bool fullScreen: false

        color: "black"
        anchors.top: fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.top
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    parent.fullScreen ?  showNormal() : showFullScreen()
                    parent.fullScreen = !parent.fullScreen
                } else if (mouse.button === Qt.RightButton) {
                    mediaPlayer.playbackRate = mediaPlayer.playbackRate === 1 ? 2 : 1
                }
            }
        }
    }

    Rectangle {
        id: playbackControl

        color: "#4d4d4d"
        height: 50
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Slider {
            id: seekBar

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            height: 10

            from: 0
            to: mediaPlayer.duration / 1000
            value: mediaPlayer.position / 1000

            onMoved: mediaPlayer.position = value * 1000
            onPositionChanged: seekBar.value = mediaPlayer.position / 1000
        }

        Button {
            id: playPauseButton

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: 32
            height: 32

            iconSource: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "pause.svg" : "play.svg"
            onClicked: mediaPlayer.playbackState === MediaPlayer.PlayingState ? mediaPlayer.pause() :
