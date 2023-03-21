import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer

    implicitHeight: 20

    RowLayout {
        anchors.fill: parent

        Text {
            id: mediaTime
            Layout.minimumWidth: 50
            Layout.minimumHeight: 18
            horizontalAlignment: Text.AlignRight
            text: {
                var m = Math.floor(mediaPlayer.position / 60000)
                var ms = (mediaPlayer.position / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }
        }

        Rectangle {
            id: sliderTrack
            Layout.fillWidth: true
            height: 2
            color: "lightgrey"
            radius: 1

            Rectangle {
                id: sliderHandle
                height: 8
                width: 8
                color: "grey"
                radius: width/2

                x: mediaSlider.visualPosition * (sliderTrack.width - width)
                y: sliderTrack.height/2 - height/2

                MouseArea {
                    id: sliderHandleMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: {
                        mediaSlider.grabMouse()
                        mediaSlider.position = mediaSlider.visualPosition * mediaSlider.maximumValue
                    }

                    onReleased: {
                        mediaSlider.releaseMouse()
                    }

                    onPositionChanged: {
                        if (sliderHandleMouseArea.containsMouse) {
                            mediaSlider.position = mediaSlider.visualPosition * mediaSlider.maximumValue
                        }
                    }

                    onEntered: {
                        sliderHandle.color = "lightgrey"
                    }

                    onExited: {
                        sliderHandle.color = "grey"
                    }
                }
            }
        }

        Slider {
            id: mediaSlider
            Layout.fillWidth: true
            enabled: mediaPlayer.seekable
            to: 1.0
            visualPosition: value
            handle: null
            onPositionChanged: {
                sliderHandle.x = visualPosition * (sliderTrack.width - sliderHandle.width)
            }

            onMoved: {
                mediaPlayer.setPosition(value * mediaPlayer.duration)
            }
        }
    }
}
