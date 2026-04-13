import QtQuick
import Quickshell.Io
import Quickshell

import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth
import "./../config" as QTServices

Variants {
    model: Quickshell.screens
    delegate: Component {

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData
            anchors {
                top: true
                bottom: false
                left: true
                right: true
            }
            implicitHeight: 24
            color: QTServices.Theme.background
            Process {
                id: myProcess
                command: ["bluetoothctl", "power", "on"]
            }
            IpcHandler {
                target: "myWindow"
                function reload() {
                    Quickshell.reload(true);
                    myProcess.running = true;
                }
            }
            Row {
                id: moduleLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: clockLoader
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 16
                    color: QTServices.Theme.color7

                    property var time: Qt.formatDateTime(new Date(), "dd,ddd HH:mm")
                    text: clockLoader.time
                    font.pixelSize: 14
                    // font.family: "JetBrainsMono Nerd Font Propo"

                    font.family: QTServices.Theme.fontFamily
                    Timer {
                        interval: 5000
                        running: true
                        repeat: true
                        onTriggered: clockLoader.text = Qt.formatDateTime(new Date(), "dd,ddd HH:mm")
                    }
                }
            }

            Row {
                id: moduleCenter
                anchors.centerIn: parent

                Repeater {
                    id: workspace
                    model: 20
                    WrapperRectangle {
                        required property int index
                        property var ws: Hyprland.workspaces.values.find(w => w.id == index + 1)
                        property bool isActive: Hyprland.focusedWorkspace?.id == (index + 1)
			border.width:0
                        implicitHeight: 20
                        implicitWidth: ws ? 32 : 0
                        color: isActive ? QTServices.Theme.foreground : "#000000aa"

                        Behavior on implicitWidth {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.OutCubic
                            }
                        }
                        Behavior on implicitHeight {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }

                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: ws ? (index + 1) : ""
                            color: isActive ? QTServices.Theme.background : QTServices.Theme.color7

                            font.family: QTServices.Theme.fontFamily
                            font {
                                bold: isActive
                            }
                        }
                    }
                }
            }

            Row {
                id: moduelRight
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 16
                spacing: 8
                Text {
                    id: pw
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12
                    font.family: QTServices.Theme.fontFamily
                    color: QTServices.Theme.color7
                    property var defaultAudioSink: Pipewire.defaultAudioSink
                    property int volume: defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0
                    property bool volumeMuted: defaultAudioSink && defaultAudioSink.audio ? defaultAudioSink.audio.muted : false
                    PwObjectTracker {
                        objects: [Pipewire.defaultAudioSink]
                    }

                    Behavior on text {
                        SequentialAnimation {
                            NumberAnimation {
                                target: pw
                                property: "scale"
                                to: 1.15
                                duration: 80
                            }
                            NumberAnimation {
                                target: pw
                                property: "scale"
                                to: 1.0
                                duration: 100
                            }
                        }
                    }

                    text: {
                        if (volumeMuted)
                            return " " + (pw.volume + "%");
                        if (volume >= 30)
                            return " " + (pw.volume + "%");
                        if (volume >= 15)
                            return " " + (pw.volume + "%");
                        return " " + (pw.volume + "%");
                    }
                }

                Text {
                    id: bt
                    anchors.verticalCenter: parent.verticalCenter
                    readonly property var adapter: Bluetooth.defaultAdapter
                    readonly property var connectedDevices: Bluetooth.devices.values.filter(d => d.connected)
                    readonly property bool hasConnection: connectedDevices.length > 0
                    readonly property bool isEnabled: adapter?.enabled ?? false
                    readonly property string deviceName: hasConnection ? (connectedDevices[0]?.name ?? "Device") : ""
                    readonly property int deviceCount: connectedDevices.length
                    color: QTServices.Theme.color7
                    font.pixelSize: 16
                    font.family: QTServices.Theme.fontFamily
                    text: {
                        if (!isEnabled)
                            return "󰂲";
                        if (hasConnection)
                            return "󰂱";
                        return "󰂯";
                    }
                }

                Text {
                    id: wifi
                    property var network: 0
                    property var signal: 0
                    property var lines: 0
                    color: QTServices.Theme.color7
                    font.pixelSize: 16
                    font.family: QTServices.Theme.fontFamily
                    text: {
                        if (wifi.network == "Connected") {
                            if (wifi.signal > -50) {
                                return "󰤨";
                            }
                            if (wifi.signal > -70) {
                                return "󰤢";
                            }
                            return "󰤟";
                        } else
                            return "󰤭";
                    }

                    Process {
                        id: network
                        command: ["sh", "-c", "/home/last/.ml4w_custom/scripts/modules/iwctl.sh"]
                        stdout: SplitParser {
                            onRead: data => {
                                var parts = data.trim().split(' ');
                                wifi.network = parts[0];
                                wifi.signal = parts[1];
                            }
                        }
                        Component.onCompleted: running = true
                    }

                    Timer {
                        interval: 4000
                        running: true
                        repeat: true
                        onTriggered: network.running = true
                    }
                }
            }
        }
    }
}
