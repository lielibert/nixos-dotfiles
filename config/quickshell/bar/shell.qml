// @ pragma UseQApplication

import Quickshell
import QtQuick
import Quickshell.Services.Notifications
import "./modules/bar/"

ShellRoot {
    id: root
    
    Loader {
        active: true
        sourceComponent: Bar {}
    }
}
