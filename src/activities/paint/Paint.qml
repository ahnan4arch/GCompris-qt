/* GCompris - paint.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import "../../core"
import "paint.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

// TODO1: undo/redo
// TODO: (optional): Shape creator: press on the canvas to draw lines; at the end, press on the starting point to create a shape

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#add8e6"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        property bool started: false

        // When the width/height is changed, paint the last image on the canvas
        onWidthChanged: {
            if (items.background.started) {
                items.widthHeightChanged = true
                Activity.initLevel()
            }
        }
        onHeightChanged: {
            if (items.background.started) {
                items.widthHeightChanged = true
                Activity.initLevel()
            }
        }

        File {
            id: file
            onError: console.error("File error: " + msg);
        }

        Timer {
            id: timer
            interval: 1
            running: true
            repeat: true

            property int index: 0

            onTriggered: {
                index ++

                if (index >= 10)
                    stop()

                brushSelectCanvas.requestPaint()
            }
        }

        function reloadSelectedPen() {
            timer.index = 0
            timer.start()
        }

        SaveToFilePrompt {
            id: saveToFilePrompt
            z: -1

            onYes: {
                Activity.saveToFile(true)
                if (main.x == 0)
                    load.opacity = 0
                activity.home()
            }
            onNo: {
                if (main.x == 0)
                    load.opacity = 0
                activity.home()
            }
            onCancel: {
                saveToFilePrompt.z = -1
                saveToFilePrompt.opacity = 0
                main.opacity = 1
            }
        }

        SaveToFilePrompt {
            id: saveToFilePrompt2
            z: -1

            onYes: {
                cancel()
                Activity.saveToFile(true)
                Activity.initLevel()
            }
            onNo: {
                cancel()
                Activity.initLevel()
            }
            onCancel: {
                saveToFilePrompt2.z = -1
                saveToFilePrompt2.opacity = 0
                main.opacity = 1
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias canvas: canvas
            //property alias colorTools: colorTools
            property alias rightPanel: rightPanel
            property alias timer: timer
            property alias area: area
            property alias inputText: inputTextFrame.inputText
            property alias inputTextFrame: inputTextFrame
            property alias parser: parser
            property alias gridView2: loadSavedPainting.gridView2
            property alias file: file
            property alias load: load
            property alias mainRegion: main
            property alias shape: shape
            property alias colorPalette: colorPalette
            property alias brushSelectCanvas: brushSelectCanvas
            property int activeColorIndex: 1
            property var colors: [
                /*blue*/    "#33B5E5", "#1a53ff", "#0000ff", "#0000b3",
                /*green*/   "#bfff00", "#99CC00", "#86b300", "#608000",
                /*orange*/  "#FFBB33",
                /*red*/     "#ff9999", "#FF4444", "#ff0000", "#cc0000",
                /*pink*/    "#ff00ff",
                /*yellow*/  "#ffff00",
                /*white*/   "#ffffff",
                /*black*/   "#000000",
                /*free spots*/
                "#c2c2d6"
            ]
            property color paintColor: Activity.colors[items.activeColorIndex]
            property var urlImage
            property bool next: false
            property bool next2: false
            property bool loadSavedImage: false
            property bool initSave: false
            property bool nothingChanged: true
            property bool widthHeightChanged: false
            property bool mainAnimationOnX: true
            property bool undoRedo: false
            property int sizeS: 20
            property int index: 0
            property string toolSelected: "pencil"
            property string patternType: "dot"
            property string lastUrl
            property string lastToolSelected: "pencil"
        }

        JsonParser {
            id: parser
            onError: console.error("Paint: Error parsing JSON: " + msg);
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: {
                if (!items.nothingChanged) {
                    saveToFilePrompt.text = qsTr("Do you want to save your painting?")
                    main.opacity = 0.5
                    saveToFilePrompt.opacity = 1
                    saveToFilePrompt.z = 200
                } else {
                    if (main.x == 0)
                        load.opacity = 0
                    activity.home()
                }
            }
            onReloadClicked: {
                if (!items.nothingChanged) {
                    saveToFilePrompt2.text = qsTr("Do you want to save your painting before reseting the board?")
                    main.opacity = 0.5
                    saveToFilePrompt2.opacity = 1
                    saveToFilePrompt2.z = 200
                } else {
                    Activity.initLevel()
                }
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        function hideExpandedTools () {
            if (selectBrush.z > 0)
                hideAnimation.start()
            if (selectSize.z > 0)
                hideSelectSizeAnimation.start()

            // hide the inputTextFrame
            items.inputTextFrame.opacity = 0
            items.inputTextFrame.z = -1
            items.inputText.text = ""
        }

        Rectangle {
            id: main
            width: parent.width
            height: parent.height

            color: background.color

            Behavior on x {
                enabled: items.mainAnimationOnX
                NumberAnimation {
                    target: main
                    property: "x"
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }

            Behavior on y {
                NumberAnimation {
                    target: main
                    property: "y"
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }

            // Text input box.
            TextInputTool {
                id: inputTextFrame
            }

            //Rectangle {
            //                id: canvasBackground
            //                z: 1
            //                anchors.fill: parent
            //                anchors.margins: 8

            //                color: "green"

            Canvas {
                id: canvas
                anchors.fill: parent

                property real lastX
                property real lastY

                // for brush
                property var lastPoint
                property var currentPoint

                property var ctx
                property string url: ""

                GCText {
                    id: onBoardText
                    text: ""
                    color: items.paintColor
                    // font.pointSize: (ApplicationSettings.baseFontSize + 32) * ApplicationInfo.fontRatio
                    font.pointSize: items.sizeS * 10
                    z: -1
                    opacity: 0
                }


                function clearCanvas() {
                    // clear all drawings from the board
                    var ctx = getContext('2d')
                    ctx.beginPath()
                    ctx.clearRect(0, 0, canvas.width, canvas.height);

                    paintWhite()
                    canvas.ctx.strokeStyle = "#ffffff"
                }

                function paintWhite() {
                    canvas.ctx = getContext("2d")
                    canvas.ctx.fillStyle = "#ffffff"
                    canvas.ctx.beginPath()
                    canvas.ctx.moveTo(0, 0)
                    canvas.ctx.lineTo(background.width, 0)
                    canvas.ctx.lineTo(background.width, background.height)
                    canvas.ctx.lineTo(0, background.height)
                    canvas.ctx.closePath()
                    canvas.ctx.fill()
                }

                onImageLoaded: {
                    // load images from files
                    if (canvas.url != "") {
                        canvas.clearCanvas()

                        if (items.loadSavedImage) {
                            canvas.ctx.drawImage(canvas.url, 0, 0, canvas.width, canvas.height)
                        } else {
                            canvas.ctx.drawImage(canvas.url, canvas.width / 2 - canvas.height / 2, 0, canvas.height, canvas.height)
                        }

                        // mark the loadSavedImage as finished
                        items.loadSavedImage = false
                        requestPaint()
                        items.lastUrl = canvas.url
                        unloadImage(canvas.url)
                        items.mainAnimationOnX = true
                        canvas.url = ""

                        // undo and redo
                    } else if (items.undoRedo) {
                        ctx.drawImage(items.urlImage,0,0)
                        requestPaint()
                        items.lastUrl = canvas.url
                        unloadImage(items.urlImage)
                        items.undoRedo = false
                    }
                }

                function resetShape () {
                    area.currentShape.rotationn = 0
                    area.currentShape.x = 0
                    area.currentShape.y = 0
                    area.currentShape.width = 0
                    area.currentShape.height = 0
                    area.endX = 0
                    area.endY = 0
                    canvas.lastX = 0
                    canvas.lastY = 0
                }

                function midPointBtw(p1, p2) {
                    return {
                        x: p1.x + (p2.x - p1.x) / 2,
                        y: p1.y + (p2.y - p1.y) / 2
                    };
                }

                function distanceBetween(point1, point2) {
                    return Math.sqrt(Math.pow(point2.x - point1.x, 2) + Math.pow(point2.y - point1.y, 2));
                }

                function angleBetween(point1, point2) {
                    return Math.atan2( point2.x - point1.x, point2.y - point1.y );
                }

                function getRandomInt(min, max) {
                    return Math.floor(Math.random() * (max - min + 1)) + min;
                }

                function removeShadow() {
                    // remove the shadow effect
                    canvas.ctx.shadowColor = 'rgba(0,0,0,0)'
                    canvas.ctx.shadowBlur = 0
                    canvas.ctx.shadowOffsetX = 0
                    canvas.ctx.shadowOffsetY = 0
                }

                onPaint: {
                    canvas.ctx = getContext('2d')
                }

                MouseArea {
                    id: area
                    anchors.fill: parent

                    hoverEnabled: false
                    property var mappedMouse: mapToItem(parent, mouseX, mouseY)
                    property var currentShape: items.toolSelected == "circle" ? circle : rectangle
                    property var originalX
                    property var originalY
                    property real endX
                    property real endY

                    Timer {
                        id: moveOnBoardText
                        interval: 1
                        repeat: true
                        running: false
                        triggeredOnStart: {
                            onBoardText.x = area.realMouseX
                            onBoardText.y = area.realMouseY - onBoardText.height * 0.8
                        }
                    }

                    property real realMouseX: mouseX
                    property real realMouseY: mouseY

                    onPressed: {

                        if (items.nothingChanged)
                            items.nothingChanged = false

                        background.hideExpandedTools()
                        mappedMouse = mapToItem(parent, mouseX, mouseY)

                        print("tools: ",items.toolSelected)

                        if (items.toolSelected == "rectangle" || items.toolSelected == "circle" || items.toolSelected == "lineShift") {
                            // set the origin coordinates for current shape
                            currentShape.x = mapToItem(parent, mouseX, mouseY).x
                            currentShape.y = mapToItem(parent, mouseX, mouseY).y

                            originalX = currentShape.x
                            originalY = currentShape.y

                            // set the current color for the current shape
                            currentShape.color = items.paintColor
                        } else if (items.toolSelected == "line") {
                            // set the origin coordinates for current shape
                            currentShape.x = mapToItem(parent, mouseX, mouseY).x
                            currentShape.y = mapToItem(parent, mouseX, mouseY).y

                            originalX = currentShape.x
                            originalY = currentShape.y

                            currentShape.height = items.sizeS

                            // set the current color for the current shape
                            currentShape.color = items.paintColor
                        } else if (items.toolSelected == "text") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                        } else if (items.toolSelected == "pattern") {
                            canvas.ctx.strokeStyle = "#ffffff"  // very important!
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            Activity.points.push({x: mouseX, y: mouseY})
                        } else if (items.toolSelected == "spray") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                        } else if (items.toolSelected == "eraser") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            canvas.ctx.strokeStyle = "#ffefff"
                        } else if (items.toolSelected == "pencil") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                        } else if (items.toolSelected == "brush3") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            canvas.lastPoint = { x: mouseX, y: mouseY }
                        } else if (items.toolSelected == "brush4") {
                            canvas.ctx.strokeStyle = "#ffefff"
                            Activity.points.push({x: mouseX, y: mouseY})
                        } else if (items.toolSelected == "brush5") {
                            Activity.connectedPoints.push({x: mouseX, y: mouseY})
                        } else if (items.toolSelected == "blur") {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                        } else {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            print("ON Pressed - tool not known")
                        }
                    }

                    onReleased: {
                        // for line tool
                        mappedMouse = mapToItem(parent, mouseX, mouseY)
                        area.endX = mappedMouse.x
                        area.endY = mappedMouse.y

                        // Reset text elements:
                        // hide the text
                        onBoardText.opacity = 0
                        onBoardText.z = -1

                        // stop the text following the cursor
                        if (moveOnBoardText.running)
                            moveOnBoardText.stop()

                        // disable hover
                        area.hoverEnabled = false

                        if (items.toolSelected == "line") {
                            canvas.removeShadow()
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.beginPath()

                            var angleRad = (360 - area.currentShape.rotationn) * Math.PI / 180
                            var auxX = items.sizeS * Math.sin(angleRad)
                            var auxY = items.sizeS * Math.cos(angleRad)

                            canvas.ctx.moveTo(area.currentShape.x,area.currentShape.y)
                            canvas.ctx.lineTo(area.endX,area.endY)
                            canvas.ctx.lineTo(area.endX + auxX,area.endY + auxY)
                            canvas.ctx.lineTo(area.currentShape.x + auxX,area.currentShape.y + auxY)
                            canvas.ctx.closePath()
                            canvas.ctx.fill()

                            canvas.resetShape()
                            canvas.requestPaint()
                        }

                        if (items.toolSelected == "circle") {
                            canvas.removeShadow()
                            canvas.ctx = canvas.getContext('2d')
                            canvas.ctx.beginPath();
                            canvas.ctx.arc(area.currentShape.x + area.currentShape.width / 2,
                                           area.currentShape.y + area.currentShape.width / 2,
                                           area.currentShape.width / 2, 0, 2 * Math.PI, false);
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.fill();
                            canvas.resetShape()
                            canvas.requestPaint()

                        }

                        if (items.toolSelected == "rectangle" || items.toolSelected == "lineShift") {
                            canvas.removeShadow()
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(area.currentShape.x,area.currentShape.y)
                            canvas.ctx.lineTo(area.currentShape.x + area.currentShape.width,area.currentShape.y)
                            canvas.ctx.lineTo(area.currentShape.x + area.currentShape.width,area.currentShape.y + area.currentShape.height)
                            canvas.ctx.lineTo(area.currentShape.x,area.currentShape.y + area.currentShape.height)
                            canvas.ctx.closePath()
                            canvas.ctx.fill()
                            canvas.resetShape()
                            canvas.requestPaint()
                        }

                        // Todo: Remove use of onBoardText and use items.sizeS for font size!
                        if (items.toolSelected == "text" && onBoardText.text != "") {
                            canvas.removeShadow()
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.font = "15px" + ApplicationSettings.font
                            console.log(ApplicationSettings.font)
                            //canvas.ctx.font = items.sizeS * 10 + "pt sans-serif"
                            canvas.ctx.strokeText(onBoardText.text,area.realMouseX,area.realMouseY)
                            onBoardText.text = ""

                            canvas.requestPaint()
                        }

                        // reset the "points" array
                        if (items.toolSelected == "pattern" ||
                                items.toolSelected == "brush4")
                            Activity.points = []

                        if (items.toolSelected == "brush5")
                            Activity.connectedPoints = []


                        // push the state of the current board on UNDO stack
                        items.urlImage = canvas.toDataURL()
                        items.lastUrl = items.urlImage
                        Activity.undo = Activity.undo.concat(items.urlImage)

                        if (Activity.redo.length != 0) {
                            print("resetting redo array!")
                            Activity.redo = []
                        }

                        if (items.toolSelected != "circle" &&
                                items.toolSelected != "rectangle" &&
                                items.toolSelected != "line" &&
                                items.toolSelected != "lineShift")
                            items.next = true
                        else items.next = false

                        // print("undo: " + Activity.undo.length + " redo: " + Activity.redo.length)
                        area.hoverEnabled = false
                    }

                    onPositionChanged: {
                        canvas.ctx = canvas.getContext('2d')
                        canvas.ctx.strokeStyle = items.toolSelected == "eraser" ? "#ffffff" :
                                                                                  items.toolSelected == "pattern" ? canvas.ctx.createPattern(shape.toDataURL(), 'repeat') :
                                                                                                                    items.toolSelected == "brush4" ? "black" :
                                                                                                                                                     items.paintColor

                        if (items.toolSelected == "pencil" || items.toolSelected == "eraser") {
                            canvas.removeShadow()
                            canvas.ctx = canvas.getContext('2d')
                            canvas.ctx.lineWidth = items.toolSelected == "eraser" ?
                                        items.sizeS * 4 : items.sizeS
                            canvas.ctx.lineCap = 'round'
                            canvas.ctx.lineJoin = 'round'
                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(canvas.lastX, canvas.lastY)
                            canvas.lastX = area.mouseX
                            canvas.lastY = area.mouseY
                            canvas.ctx.lineTo(canvas.lastX, canvas.lastY)
                            canvas.ctx.stroke()

                            canvas.requestPaint()
                        } else if (items.toolSelected == "rectangle") {
                            mappedMouse = mapToItem(parent, mouseX, mouseY)
                            var width = mappedMouse.x - area.originalX
                            var height = mappedMouse.y - area.originalY

                            if (Math.abs(width) > Math.abs(height)) {
                                if (width < 0) {
                                    currentShape.x = area.originalX + width
                                    currentShape.y = area.originalY
                                }
                                if (height < 0)
                                    currentShape.y = area.originalY + height

                                currentShape.width = Math.abs(width)
                                currentShape.height = Math.abs(height)
                            } else {
                                if (height < 0) {
                                    currentShape.x = area.originalX
                                    currentShape.y = area.originalY + height
                                }
                                if (width < 0)
                                    currentShape.x = area.originalX + width

                                currentShape.height = Math.abs(height)
                                currentShape.width = Math.abs(width)
                            }
                        } else if (items.toolSelected == "circle") {
                            mappedMouse = mapToItem(parent, mouseX, mouseY)
                            var width = mappedMouse.x - area.originalX
                            var height = mappedMouse.y - area.originalY

                            if (height < 0 && width < 0) {
                                currentShape.x = area.originalX - currentShape.width
                                currentShape.y = area.originalY - currentShape.height
                            } else if (height < 0) {
                                currentShape.x = area.originalX
                                currentShape.y = area.originalY - currentShape.height
                            } else if (width < 0) {
                                currentShape.x = area.originalX - currentShape.width
                                currentShape.y = area.originalY
                            } else {
                                currentShape.x = area.originalX
                                currentShape.y = area.originalY
                            }

                            currentShape.height = currentShape.width = Math.max(Math.abs(width), Math.abs(height))
                        } else if (items.toolSelected == "line") {
                            mappedMouse = mapToItem(parent, mouseX, mouseY)
                            var width = mappedMouse.x - area.originalX
                            var height = mappedMouse.y - area.originalY

                            var distance = Math.sqrt( Math.pow(width,2) + Math.pow(height,2) )

                            var p1x = area.originalX
                            var p1y = area.originalY

                            var p2x = area.originalX + 200
                            var p2y = area.originalY

                            var p3x = mappedMouse.x
                            var p3y = mappedMouse.y

                            var p12 = Math.sqrt(Math.pow((p1x - p2x),2) + Math.pow((p1y - p2y),2))
                            var p23 = Math.sqrt(Math.pow((p2x - p3x),2) + Math.pow((p2y - p3y),2))
                            var p31 = Math.sqrt(Math.pow((p3x - p1x),2) + Math.pow((p3y - p1y),2))

                            var angleRad = Math.acos((p12 * p12 + p31 * p31 - p23 * p23) / (2 * p12 * p31))
                            var angleDegrees

                            if (height < 0)
                                angleDegrees = angleRad * 180 / Math.PI
                            else angleDegrees = 360 - angleRad * 180 / Math.PI

                            currentShape.rotationn = 360 - angleDegrees
                            currentShape.width = distance
                        } else if (items.toolSelected == "lineShift") {
                            mappedMouse = mapToItem(parent, mouseX, mouseY)
                            var width = mappedMouse.x - area.originalX
                            var height = mappedMouse.y - area.originalY

                            if (Math.abs(width) > Math.abs(height)) {
                                if (height < 0)
                                    currentShape.y = area.originalY
                                if (width < 0) {
                                    currentShape.x = area.originalX + width
                                    currentShape.y = area.originalY
                                }
                                currentShape.width = Math.abs(width)
                                currentShape.height = items.sizeS
                            } else {
                                if (width < 0)
                                    currentShape.x = area.originalX
                                if (height < 0) {
                                    currentShape.x = area.originalX
                                    currentShape.y = area.originalY + height
                                }
                                currentShape.height = Math.abs(height)
                                currentShape.width = items.sizeS
                            }
                        } else if (items.toolSelected == "pattern") {
                            canvas.removeShadow()
                            Activity.points.push({x: mouseX, y: mouseY})
                            canvas.ctx = canvas.getContext('2d')
                            canvas.ctx.lineWidth = items.sizeS * 5
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round'

                            var p1 = Activity.points[0]
                            var p2 = Activity.points[1]

                            if (!p1 || !p2)
                                return

                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(p1.x, p1.y)

                            for (var i = 1, len = Activity.points.length; i < len; i++) {
                                var midPoint = canvas.midPointBtw(p1, p2);
                                canvas.ctx.quadraticCurveTo(p1.x, p1.y, midPoint.x, midPoint.y);
                                p1 = Activity.points[i];
                                p2 = Activity.points[i+1];
                            }
                            canvas.ctx.lineTo(p1.x, p1.y);
                            canvas.ctx.stroke();
                            canvas.requestPaint()
                        } else if (items.toolSelected == "spray") {
                            canvas.removeShadow()
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            canvas.ctx = canvas.getContext('2d')
                            canvas.ctx.lineWidth = items.sizeS * 5
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round'
                            canvas.ctx.moveTo(canvas.lastX, canvas.lastY)
                            canvas.ctx.fillStyle = items.paintColor

                            for (var i = 50; i--; i >= 0) {
                                var radius = items.sizeS * 5;
                                var offsetX = canvas.getRandomInt(-radius, radius);
                                var offsetY = canvas.getRandomInt(-radius, radius);
                                canvas.ctx.fillRect(canvas.lastX + offsetX, canvas.lastY + offsetY, 1, 1);
                            }

                            canvas.requestPaint()
                        } else if (items.toolSelected == "brush3") {
                            canvas.removeShadow()
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            canvas.ctx.lineWidth = items.sizeS * 1.2
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round';

                            canvas.ctx.beginPath();

                            canvas.ctx.globalAlpha = 1;
                            canvas.ctx.moveTo(canvas.lastPoint.x, canvas.lastPoint.y);
                            canvas.ctx.lineTo(canvas.lastX, canvas.lastY);
                            canvas.ctx.stroke();

                            canvas.ctx.moveTo(canvas.lastPoint.x - 3, canvas.lastPoint.y - 3);
                            canvas.ctx.lineTo(canvas.lastX - 3, canvas.lastY - 3);
                            canvas.ctx.stroke();

                            canvas.ctx.moveTo(canvas.lastPoint.x - 2, canvas.lastPoint.y - 2);
                            canvas.ctx.lineTo(canvas.lastX - 2, canvas.lastY - 2);
                            canvas.ctx.stroke();

                            canvas.ctx.moveTo(canvas.lastPoint.x + 2, canvas.lastPoint.y + 2);
                            canvas.ctx.lineTo(canvas.lastX + 2, canvas.lastY + 2);
                            canvas.ctx.stroke();

                            canvas.ctx.moveTo(canvas.lastPoint.x + 3, canvas.lastPoint.y + 3);
                            canvas.ctx.lineTo(canvas.lastX + 3, canvas.lastY + 3);
                            canvas.ctx.stroke();

                            canvas.lastPoint = { x: canvas.lastX, y: canvas.lastY };

                            canvas.requestPaint()
                        } else if(items.toolSelected == "brush4") {
                            canvas.removeShadow()
                            Activity.points.push({x: mouseX, y: mouseY})
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round'
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.lineWidth = items.sizeS / 4
                            for (var i = 0; i < Activity.points.length; i++) {
                                canvas.ctx.beginPath();
                                canvas.ctx.arc(Activity.points[i].x, Activity.points[i].y, 5 * items.sizeS, 0, Math.PI * 2, false);
                                canvas.ctx.fill();
                                canvas.ctx.stroke();
                            }
                            canvas.requestPaint()
                        } else if(items.toolSelected == "brush5") {
                            canvas.removeShadow()
                            Activity.connectedPoints.push({x: mouseX, y: mouseY})
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round';
                            canvas.ctx.lineWidth = 1

                            var p1 = Activity.connectedPoints[0]
                            var p2 = Activity.connectedPoints[1]

                            if (!p1 || !p2)
                                return

                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(p1.x, p1.y)

                            for (var i = 1, len = Activity.connectedPoints.length; i < len; i++) {
                                var midPoint = canvas.midPointBtw(p1, p2)
                                canvas.ctx.quadraticCurveTo(p1.x, p1.y, midPoint.x, midPoint.y)
                                p1 = Activity.connectedPoints[i]
                                p2 = Activity.connectedPoints[i+1]
                            }
                            canvas.ctx.lineTo(p1.x, p1.y)
                            canvas.ctx.stroke()

                            for (var i = 0; i < Activity.connectedPoints.length; i++) {
                                var dx = Activity.connectedPoints[i].x - Activity.connectedPoints[Activity.connectedPoints.length-1].x;
                                var dy = Activity.connectedPoints[i].y - Activity.connectedPoints[Activity.connectedPoints.length-1].y;
                                var d = dx * dx + dy * dy;

                                if (d < 1000) {
                                    canvas.ctx.beginPath();
                                    canvas.ctx.strokeStyle = 'rgba(0,0,0,0.8)';
                                    canvas.ctx.moveTo( Activity.connectedPoints[Activity.connectedPoints.length-1].x + (dx * 0.1),
                                                      Activity.connectedPoints[Activity.connectedPoints.length-1].y + (dy * 0.1));
                                    canvas.ctx.lineTo( Activity.connectedPoints[i].x - (dx * 0.1),
                                                      Activity.connectedPoints[i].y - (dy * 0.1));
                                    canvas.ctx.stroke();
                                }
                            }
                            canvas.requestPaint()
                        } else if (items.toolSelected == "blur") {
                            canvas.ctx = canvas.getContext('2d')
                            canvas.ctx.lineJoin = canvas.ctx.lineCap = 'round';
                            canvas.ctx.shadowBlur = 10
                            canvas.ctx.shadowColor = items.paintColor
                            canvas.ctx.lineWidth = items.sizeS
                            canvas.ctx.strokeStyle = items.paintColor
                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(canvas.lastX, canvas.lastY)
                            canvas.lastX = area.mouseX
                            canvas.lastY = area.mouseY
                            canvas.ctx.lineTo(canvas.lastX, canvas.lastY)
                            canvas.ctx.stroke()

                            canvas.requestPaint()
                        }
                    }

                    onClicked: {
                        if (items.toolSelected == "fill") {
                            canvas.removeShadow()
                            canvas.ctx.fillStyle = items.paintColor
                            canvas.ctx.beginPath()
                            canvas.ctx.moveTo(0, 0)
                            canvas.ctx.lineTo(background.width, 0)
                            canvas.ctx.lineTo(background.width, background.height)
                            canvas.ctx.lineTo(0, background.height)
                            canvas.ctx.closePath()
                            canvas.ctx.fill()
                            canvas.requestPaint()
                        }
                    }
                }

                Rectangle {
                    id: rectangle
                    color: items.paintColor
                    enabled: items.toolSelected == "rectangle" || items.toolSelected == "line"|| items.toolSelected == "lineShift"
                    opacity: items.toolSelected == "rectangle" || items.toolSelected == "line"|| items.toolSelected == "lineShift" ? 1 : 0

                    property real rotationn: 0

                    transform: Rotation {
                        id: rotationRect
                        origin.x: 0
                        origin.y: 0
                        angle: rectangle.rotationn
                    }
                }

                Rectangle {
                    id: circle
                    radius: width / 2
                    color: items.paintColor
                    enabled: items.toolSelected == "circle"
                    opacity: items.toolSelected == "circle" ? 1 : 0
                    property real rotationn: 0
                }
            }
            // }

            Rectangle {
                id: selectSize
                height: row.height * 1.1
                width: row.width * 1.2

                x: rightPanelFrame.x + rightPanelFrame.width
                y: rightPanelFrame.y - height / 2 + sizeTool.height * 1.5 +
                   rightPanel.spacing * 2 + rightPanel.anchors.topMargin
                z: -10

                radius: width * 0.05
                opacity: 0
                color: background.color

                SequentialAnimation {
                    id: hideSelectSizeAnimation
                    PropertyAction { target: selectSize; property: "z"; value: 2 }
                    NumberAnimation {
                        target: selectSize
                        property: "x"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: rightPanelFrame.x - selectSize.width
                        to: rightPanelFrame.x + rightPanelFrame.width
                    }
                    PropertyAction { target: selectSize; property: "opacity"; value: 0 }
                    PropertyAction { target: selectSize; property: "z"; value: -10 }
                }

                SequentialAnimation {
                    id: showSelectSizeAnimation
                    PropertyAction { target: selectSize; property: "opacity"; value: 0.9 }
                    PropertyAction { target: selectSize; property: "z"; value: 2 }
                    NumberAnimation {
                        target: selectSize
                        property: "x"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: rightPanelFrame.x + rightPanelFrame.width
                        to: rightPanelFrame.x - selectSize.width
                    }
                }

                Row {
                    id: row
                    height: 90

                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    spacing: 10

                    Thickness { lineSize: 0.15 }
                    Thickness { lineSize: 0.3 }
                    Thickness { lineSize: 0.45 }
                    Thickness { lineSize: 0.6 }
                }
            }

            Rectangle {
                id: selectBrush
                height: row2.height * 1.15
                width: row2.width * 1.05

                x: rightPanelFrame.x + rightPanelFrame.width
                y: rightPanelFrame.y - height / 2 + 20 //eraser.height * 3.5 +
                   + rightPanel.spacing * 3 + rightPanel.anchors.topMargin

                radius: width * 0.02
                opacity: 0

                z: -10
                color: background.color

                SequentialAnimation {
                    id: hideAnimation
                    PropertyAction { target: selectBrush; property: "z"; value: 2 }
                    NumberAnimation {
                        target: selectBrush
                        property: "x"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: rightPanelFrame.x - selectBrush.width
                        to: rightPanelFrame.x + rightPanelFrame.width
                    }
                    PropertyAction { target: selectBrush; property: "opacity"; value: 0 }
                    PropertyAction { target: selectBrush; property: "z"; value: -10 }
                }

                SequentialAnimation {
                    id: showAnimation
                    PropertyAction { target: selectBrush; property: "opacity"; value: 0.9 }
                    PropertyAction { target: selectBrush; property: "z"; value: 2 }
                    NumberAnimation {
                        target: selectBrush
                        property: "x"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: rightPanelFrame.x + rightPanelFrame.width
                        to: rightPanelFrame.x - selectBrush.width
                    }
                }

                property alias showSelected: showSelected

                Rectangle {
                    id: showSelected
                    width: 70; height: 70
                    color: "#ffffb3"
                    opacity: 0.7
                    x: pencil.x + row2.spacing; y: pencil.y + row2.spacing / 2
                    z: 3
                    radius: width * 0.1
                }


                Row {
                    id: row2
                    height: pencil.height

                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    z: 5
                    spacing: 10

                    ToolItem { id: pencil; source: Activity.url + "pencil.png"; name: "pencil" }
                    ToolItem {
                        name: "dot"
                        source: Activity.url + "pattern1.png"
                        opacity: items.toolSelected == "pattern" && items.patternType == "dot"  ? 1 : 0.6
                        onClick: {
                            items.toolSelected = "pattern"
                            items.patternType = "dot"
                            items.lastToolSelected = "pattern"
                            Activity.getPattern()
                            background.reloadSelectedPen()
                        }
                    }
                    ToolItem {
                        name: "pattern2"
                        source: Activity.url + "pattern2.png"
                        opacity: items.toolSelected == "pattern" && items.patternType == "horizLine"  ? 1 : 0.6
                        onClick: {
                            items.toolSelected = "pattern"
                            items.patternType = "horizLine"
                            items.lastToolSelected = "pattern"
                            Activity.getPattern2()
                            background.reloadSelectedPen()
                        }
                    }
                    ToolItem {
                        name: "pattern3"
                        source: Activity.url + "pattern3.png"
                        opacity: items.toolSelected == "pattern" && items.patternType == "vertLine"  ? 1 : 0.6
                        onClick: {
                            items.toolSelected = "pattern"
                            items.patternType = "vertLine"
                            items.lastToolSelected = "pattern"
                            Activity.getPattern3()
                            background.reloadSelectedPen()
                        }
                    }

                    ToolItem { name: "spray"; source: Activity.url + "spray.png"}
                    ToolItem { name: "brush3";source: Activity.url + "brush3.png"}
                    ToolItem { name: "brush4";source: Activity.url + "brush4.png"}
                    ToolItem { name: "brush5";source: Activity.url + "brush5.png"}
                    ToolItem { name: "blur";  source: Activity.url + "blur.png"}
                }
            }

            // tools from the right panel
            Rectangle {
                id: rightPanelFrame
                width: rightPanel.width + rightPanel.anchors.margins * 2
                anchors {
                    right: parent.right
                    //top: colorTools.bottom
                    bottom: parent.bottom
                    margins: 0
                }
                z: 3
                color: background.color

                Column {
                    id: rightPanel
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                        margins: 8
                    }

                    property real dime: (background.height) / 14 - 10 //(background.height - colorTools.height) / 14 - 10

                    spacing: 15

                    property alias sizeTool: sizeTool

                    // select size
                    Image {
                        id: sizeTool
                        width: rightPanel.dime; height: rightPanel.dime
                        source: Activity.url + "size.PNG"
                        opacity: 0.6

                        MouseArea {
                            id: toolArea
                            anchors.fill: parent
                            onClicked: {
                                if (selectSize.z > 0) {
                                    hideSelectSizeAnimation.start()
                                } else showSelectSizeAnimation.start()

                                hideAnimation.start()
                            }
                        }
                    }

                    Canvas {
                        id: brushSelectCanvas
                        width: rightPanel.dime
                        height: rightPanel.dime
                        function c(x) {
                            return width * x / 510
                        }

                        onPaint: {
                            var brushContext = items.brushSelectCanvas.getContext("2d")
                            brushContext.clearRect(0, 0, brushSelectCanvas.width, brushSelectCanvas.height)

                            brushContext.save()

                            brushContext.strokeStyle = 'transparent'

                            if (items.toolSelected == "blur") {
                                brushContext.shadowBlur = 10
                                brushContext.shadowColor = items.paintColor
                                brushContext.strokeStyle = items.paintColor
                                brushContext.lineWidth = 8
                            } else {
                                brushContext.shadowColor = 'rgba(0,0,0,0)'
                                brushContext.shadowBlur = 0
                                brushContext.shadowOffsetX = 0
                                brushContext.shadowOffsetY = 0
                            }

                            // create a triangle as clip region
                            brushContext.beginPath()

                            brushContext.moveTo( c(17), c(494))
                            brushContext.lineTo( c(53), c(320))
                            if (items.toolSelected != "pencil") {
                                brushContext.lineTo(c(336),  c(40))
                                brushContext.lineTo(c(390),  c(11))
                                brushContext.lineTo(c(457),  c(41))
                                brushContext.lineTo(c(497), c(107))
                                brushContext.lineTo(c(475), c(155))
                            }
                            brushContext.lineTo(c(160), c(405))
                            brushContext.lineTo( c(17), c(494))


                            brushContext.closePath()
                            brushContext.stroke()

                            brushContext.clip()  // create clip from triangle path

                            if (items.toolSelected == "pattern") {
                                if (items.patternType == "dot")
                                    Activity.getPattern()
                                if (items.patternType == "horizLine")
                                    Activity.getPattern2()
                                if (items.patternType == "vertLine")
                                    Activity.getPattern3()

                                brushContext.fillStyle = brushContext.createPattern(items.shape.toDataURL(), 'repeat')
                            } else if (items.toolSelected == "pencil") {
                                brushContext.fillStyle = items.paintColor
                            } else if (items.toolSelected == "spray") {
                                Activity.getSprayPattern()
                                brushContext.fillStyle = brushContext.createPattern(items.shape.toDataURL(), 'repeat')
                            } else if (items.toolSelected == "brush3") {
                                brushContext.fillStyle = items.paintColor
                            } else if (items.toolSelected == "brush4") {
                                Activity.getCirclePattern()
                                brushContext.fillStyle = brushContext.createPattern(items.shape.toDataURL(), "repeat")
                            } else if (items.toolSelected == "brush5") {
                                brushContext.strokeStyle = items.paintColor
                                brushContext.lineWidth = 2
                                brushContext.beginPath()
                                brushContext.moveTo(0,0)
                                brushContext.lineTo(brushSelectCanvas.width,brushSelectCanvas.height)
                                brushContext.lineTo(brushSelectCanvas.width/2,0)
                                brushContext.lineTo(0, brushSelectCanvas.height)
                                brushContext.lineTo(brushSelectCanvas.width, brushSelectCanvas.height * 0.1)
                                brushContext.lineTo(0, brushSelectCanvas.height * 0.5)
                                brushContext.lineTo(brushSelectCanvas.width,brushSelectCanvas.height * 0.5)
                                brushContext.lineTo(brushSelectCanvas.width * 0.5, 0)
                                brushContext.lineTo(brushSelectCanvas.width * 0.5, brushSelectCanvas.height)
                                brushContext.closePath()
                                brushContext.stroke()
                            } else if (items.toolSelected == "blur") {
                                brushContext.fillStyle = items.paintColor
                            } else {
                                // set the color of the tool to white
                                brushContext.fillStyle = "#ffffff"
                            }

                            if (items.toolSelected != "brush5") {
                                brushContext.fillRect(0, 0, 100,100)
                            }

                            brushContext.restore()
                            brushContext.drawImage(Activity.url + "pen.svg", 0, 0,rightPanel.dime,rightPanel.dime)
                        }

                        MouseArea {
                            anchors.fill: parent

                            onPressAndHold: {
                                showAnimation.start()

                                selectSize.opacity = 0
                                selectSize.z = -1
                            }

                            onClicked: {
                                items.toolSelected = items.lastToolSelected
                                background.hideExpandedTools()
                                background.reloadSelectedPen()
                            }
                        }

                        Image {
                            x: 0; y: 0
                            source: Activity.url + "pen.svg"
                            sourceSize.width: rightPanel.dime; sourceSize.height: rightPanel.dime
                            width: rightPanel.dime; height: rightPanel.dime
                        }
                    }

                    // draw a circle
                    Rectangle { // border of the circle
                        width: rightPanel.dime; height: rightPanel.dime
                        color: "transparent"
                        opacity: items.toolSelected == "circle" ? 1 : 0.6

                        Rectangle {
                            width: parent.width * 0.9; height: parent.height  * 0.9
                            radius: width / 2
                            color: items.toolSelected == "circle" ? items.paintColor : "white"
                            border.color: "black"
                            border.width: 2
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                items.toolSelected = "circle"
                                background.hideExpandedTools()
                                background.reloadSelectedPen()
                            }
                        }
                    }

                    // draw a rectangle
                    Rectangle { // border of the rectangle
                        width: rightPanel.dime; height: rightPanel.dime
                        color: "transparent"
                        opacity: items.toolSelected == "rectangle" ? 1 : 0.6

                        Rectangle { // actual rectangle
                            width: parent.width * 0.9; height: parent.height * 0.65
                            border.color: "black"
                            border.width: 2
                            color: items.toolSelected == "rectangle" ? items.paintColor : "white"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                items.toolSelected = "rectangle"
                                background.hideExpandedTools()
                                background.reloadSelectedPen()
                            }
                        }
                    }

                    // draw a line
                    Rectangle { // border of the line
                        width: rightPanel.dime; height: rightPanel.dime * 0.7
                        color: "transparent"
                        opacity: items.toolSelected == "line" ? 1 : 0.6

                        Rectangle { // actual line
                            width: parent.width * 0.9; height: parent.height * 0.3
                            rotation: -30
                            border.color: "black"
                            border.width: 2
                            color: items.toolSelected == "line" ? items.paintColor : "#ffffff"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                items.toolSelected = "line"
                                background.hideExpandedTools()
                                background.reloadSelectedPen()
                            }
                        }
                    }

                    // draw a line
                    Rectangle { // border of the line
                        width: rightPanel.dime; height: rightPanel.dime * 0.7
                        color: "transparent"
                        opacity: items.toolSelected == "lineShift" ? 1 : 0.6

                        Rectangle { // actual line
                            width: parent.width * 0.9; height: parent.height * 0.3
                            border.color: "black"
                            border.width: 2
                            color: items.toolSelected == "lineShift" ? items.paintColor : "#ffffff"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                items.toolSelected = "lineShift"
                                background.hideExpandedTools()
                                background.reloadSelectedPen()
                            }
                        }
                    }
                }
            }
        }

        LoadDrawings {
            id: load
        }

        LoadSavedDrawings {
            id: loadSavedPainting
        }

        ColorDialog {
            id: colorDialog
            title: qsTr("Please choose a color")
            currentColor: items.colors[items.activeColorIndex]
            visible: false

            onAccepted: {
                items.colors[items.activeColorIndex] = colorDialog.color
                items.paintColor = colorDialog.color
                colorPalette.visible = false
                //   if you want to save the custom colors for the next session;
                //     update the array from js
                // Activity.colors[items.index] = items.paintColor
                //     then add it to the saved file containing the paintings
                console.log("You chose: " + colorDialog.color)
                console.log(items.colors)
            }
            onRejected: {
                console.log("Canceled")
            }
        }

        Canvas {
            id: shape
            opacity: 0
        }

        FoldablePanels {
            id: foldablePanels
            visible: true
        }

        ColorPalette {
            id: colorPalette
            visible: false
        }
    }
}
