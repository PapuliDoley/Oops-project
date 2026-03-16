import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: root
    width: 900
    height: 850
    visible: true
    title: "Clinic Management System"

    readonly property color bgLight: "#FFF5F7"
    readonly property color borderPink: "#E1B1BC"
    readonly property color deepText: "#6D4C54"
    readonly property color softMauve: "#D8A7B1"

    FontLoader { id: logoFont; source: "qrc:/fonts/Pacifico-Regular.ttf" }

    StackView {
        id: mainStack
        anchors.fill: parent
        initialItem: selectionPage
    }

    // --- PAGE 1: COMPACT SELECTION ---
    Component {
        id: selectionPage
        Rectangle {
            color: bgLight
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "Register Yourself"
                    font { family: logoFont.name; pixelSize: 48 }
                    color: deepText
                }

                Row {
                    spacing: 20
                    Repeater {
                        model: ["Patient", "Doctor"]
                        Button {
                            text: modelData
                            width: 150; height: 50
                            onClicked: mainStack.push(modelData === "Patient" ? patientDashboard : doctorDashboard)
                            background: Rectangle { color: softMauve; radius: 10 }
                            contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        }
                    }
                }
            }
        }
    }

    // --- PAGE 2: COMPACT PATIENT DASHBOARD ---
    Component {
        id: patientDashboard
        Rectangle {
            color: bgLight

            Button {
                text: "← Back"; anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 20
                flat: true; onClicked: mainStack.pop()
            }

            // THIS IS THE COMPACT BOX
            Rectangle {
                id: formBox
                width: 380  // Instagram-style width
                height: childrenRect.height + 40
                anchors.centerIn: parent
                color: "white"
                radius: 15
                border.color: borderPink
                border.width: 1

                ColumnLayout {
                    width: parent.width - 40
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        text: "Patient Registration"
                        font.family: logoFont.name; font.pixelSize: 32
                        color: deepText; Layout.alignment: Qt.AlignHCenter; Layout.bottomMargin: 10
                    }

                    TextField {
                        placeholderText: "First Name"; Layout.fillWidth: true
                        background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink }
                    }
                    TextField {
                        placeholderText: "Last Name"; Layout.fillWidth: true
                        background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink }
                    }

                    RowLayout {
                        spacing: 10
                        TextField { placeholderText: "Age"; Layout.preferredWidth: 60; background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink } }
                        TextField { placeholderText: "Sex"; Layout.fillWidth: true; background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink } }
                    }

                    // Medical History Section
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 5
                        Text { text: "Medical History?"; font.pixelSize: 13; color: deepText; Layout.alignment: Qt.AlignHCenter }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 20
                            RadioButton { id: hYes; text: "Yes" }
                            RadioButton { id: hNo; text: "No"; checked: true }
                        }
                    }

                    // Hidden fields that appear when 'Yes' is clicked
                    ColumnLayout {
                        visible: hYes.checked; Layout.fillWidth: true; spacing: 8
                        TextArea {
                            placeholderText: "Describe..."; Layout.fillWidth: true; Layout.preferredHeight: 60
                            background: Rectangle { radius: 5; border.color: borderPink; color: "#FAFAFA" }
                        }
                        Button {
                            text: "Upload File"; Layout.fillWidth: true; Layout.preferredHeight: 35
                            background: Rectangle { color: "#F0F0F0"; radius: 5 }
                        }
                    }

                    Button {
                        text: "Continue"
                        Layout.fillWidth: true; Layout.preferredHeight: 45; Layout.topMargin: 10
                        background: Rectangle { color: softMauve; radius: 5 }
                        contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    }
                }
            }
        }
    }

    // --- PAGE 3: DOCTOR DASHBOARD ---
    Component {
        id: doctorDashboard
        Rectangle {
            color: bgLight
            Button {
                text: "← Back"; anchors.top: parent.top; anchors.left: parent.left; anchors.margins: 20
                flat: true; onClicked: mainStack.pop()
            }

            Rectangle {
                width: 380; height: childrenRect.height + 40
                anchors.centerIn: parent
                color: "white"; radius: 15; border.color: borderPink; border.width: 1

                ColumnLayout {
                    width: parent.width - 40
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        text: "Doctor Login"; font.family: logoFont.name; font.pixelSize: 32
                        color: deepText; Layout.alignment: Qt.AlignHCenter; Layout.bottomMargin: 10
                    }

                    TextField { placeholderText: "License ID"; Layout.fillWidth: true; background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink } }
                    TextField { placeholderText: "Password"; echoMode: TextInput.Password; Layout.fillWidth: true; background: Rectangle { implicitHeight: 40; radius: 5; border.color: borderPink } }

                    Button {
                        text: "Sign In"; Layout.fillWidth: true; Layout.preferredHeight: 45; Layout.topMargin: 10
                        background: Rectangle { color: softMauve; radius: 5 }
                        contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                         onClicked:{
                             mainStack.push(appointmentListPage)
                         }
                    }
                }
            }
        }
    }
    Component {
        id: appointmentListPage
        Rectangle {
            color: bgLight

            // --- PRESCRIPTION DIALOG ---
            Dialog {
                id: prescribeDialog
                title: "Prescribe Medicine"
                anchors.centerIn: parent
                width: 320
                modal: true
                standardButtons: Dialog.Ok | Dialog.Cancel

                property int currentPatientId: 0

                ColumnLayout {
                    width: parent.width - 20
                    Text { text: "Medicine Details:"; font.bold: true; color: deepText }
                    TextField {
                        id: medicineInput
                        placeholderText: "...." // Matches your screenshot typing
                        Layout.fillWidth: true
                        background: Rectangle { implicitHeight: 40; border.color: borderPink; radius: 5 }
                    }
                }
                onAccepted: {
                    backend.updatePrescription(currentPatientId, medicineInput.text)
                    medicineInput.clear()
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Header Tabs
                RowLayout {
                    spacing: 20
                    Text { text: "Pending Appointments"; font.bold: true; color: deepText; font.pixelSize: 16 }
                    Text { text: "Completed Appointments"; color: "gray"; font.pixelSize: 16 }
                }

                // The ListView (The Scrollable List)
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 10
                    model: ListModel {
                        ListElement { pId: 1; name: "Fortnite Mr Beast"; date: "12th April" }
                        ListElement { pId: 2; name: "Fortnite Mr Beast"; date: "12th April" }
                        ListElement { pId: 3; name: "Fortnite Mr Beast"; date: "12th April" }
                    }

                    delegate: Rectangle {
                        width: listView.width
                        height: 90
                        color: "white"
                        radius: 12
                        border.color: borderPink
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 15

                            Rectangle { width: 40; height: 40; radius: 20; color: "#F0F0F0"; Text { text: "👤"; anchors.centerIn: parent } }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Text { text: "Patient"; font.pixelSize: 10; color: "gray" }
                                Text { text: model.name; font.bold: true; color: deepText }
                                Text { text: model.date; font.pixelSize: 11; color: "gray" }
                            }

                            ColumnLayout {
                                Text {
                                    text: "Mark Done"; color: "#3498db"; font.pixelSize: 12
                                    MouseArea { anchors.fill: parent; onClicked: backend.markAsCompleted(model.pId) }
                                }
                                Text {
                                    text: "Prescribe"; color: "#3498db"; font.bold: true; font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            prescribeDialog.currentPatientId = model.pId
                                            prescribeDialog.open()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button {
                text: "← Back"; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.margins: 20
                flat: true; onClicked: mainStack.pop(null)

            }
        }
    }
}
