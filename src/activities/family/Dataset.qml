/* GCompris - Dataset.qml
 *
 * Copyright (C) RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *   RUDRA NIL BASU <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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

QtObject {
    property real nodeWidth: background.nodeWidthRatio
    property real nodeHeight: background.nodeHeightRatio

    /*
     * Vertically, the screen is divided into three parts:
     * gen_1: stands for Generation 1
     * gen_2: stands for Generation 2
     * gen_3: stands for Generation 3
     */
    readonly property real gen_1: 0.10
    readonly property real gen_2: 0.40
    readonly property real gen_3: 0.70

    /*
     * Horizontally, the screen is divided into left, center
     * and right
     */
    readonly property real left: 0.2
    readonly property real center: 0.4
    readonly property real right: 0.6

    readonly property real left_1: 0.1
    readonly property real left_2: 0.3
    readonly property real right_1: 0.5
    readonly property real right_2: 0.7

    property var levelElements: [
        // level 1
        {
            edgeList: [
                [left + nodeWidth, gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, ((left + nodeWidth) + right) / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [center, gen_2]
            ],
            captions: [
                [center - nodeWidth, gen_2 + nodeHeight / 2],
                [left - nodeWidth / 2, gen_1]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
            currentState: ["activeTo", "deactive", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Father")],
            options: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]
        },
        // level 2
        {
            edgeList: [
                [0.37, 0.25, 0.64, 0.25],
                [0.51, 0.25, 0.51, 0.50]
            ],
            nodePositions: [
                [0.211, 0.20],
                [0.633, 0.20],
                [0.4, 0.50]
            ],
            captions: [
                [0.27, 0.57],
                [0.8283, 0.24]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
            currentState: ["deactive", "activeTo", "active"],
            edgeState:["married","others"],
            answer: [qsTr("Mother")],
            options: [qsTr("Mother"), qsTr("Grandmother"), qsTr("Aunt")]
        },
        // level 3
        {
            edgeList: [
                [0.37, 0.25, 0.64, 0.25],
                [0.51, 0.257, 0.42, 0.50],
                [0.51, 0.257, 0.63, 0.50]
            ],
            nodePositions: [
                [0.211, 0.20],
                [0.633, 0.20],
                [0.33, 0.50],
                [0.55, 0.50]
            ],
            captions:[
                [0.21, 0.59],
                [0.740, 0.595]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "boy2.svg"],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","others","others"],
            answer: [qsTr("Brother")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 4
        {
            edgeList: [
                [left + nodeWidth, gen_1 + nodeHeight / 2, right, gen_1 + nodeHeight / 2],//[0.37, 0.25, 0.64, 0.25],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, left + nodeWidth / 2, gen_2],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, center + nodeWidth / 2, gen_2],
                [((left + nodeWidth) + right) / 2, gen_1 + nodeHeight / 2, right + nodeWidth / 2, gen_2]
            ],
            nodePositions: [
                [left, gen_1],
                [right, gen_1],
                [left, gen_2],
                [center, gen_2],
                [right, gen_2]
            ],
            captions: [
                [left, (gen_2 + nodeHeight) * 1.1],
                [center + nodeWidth / 2, (gen_2 + nodeHeight) * 1.1]
            ],
            nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            currentState: ["deactive", "deactive", "active", "activeTo", "deactive"],
            edgeState:["married","others","others","others"],
            answer: [qsTr("Sister")],
            options: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
        },
        // level 5
        {
            edgeList: [
                [left_1 + nodeWidth, gen_1 + nodeHeight / 2, right_1, gen_1 + nodeHeight / 2],
                [((left_1 + nodeWidth) + right_1) / 2, gen_1 + nodeHeight / 2, ((left_1 + nodeWidth) + right_1) / 2, gen_2],
                [left_2 + nodeWidth, gen_2 + nodeHeight / 2, right, gen_2 + nodeHeight / 2],
                [((left_2 + nodeWidth) + right) / 2, gen_2 + nodeHeight / 2, ((left_2 + nodeWidth) + right) / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3 - nodeWidth / 4],
                [left + nodeWidth / 2, gen_3 - nodeWidth / 4, left + nodeWidth / 2, gen_3],
                [center + nodeWidth / 2, gen_3 - nodeWidth / 4, center + nodeWidth / 2, gen_3],
                [right + nodeWidth / 2, gen_3 - nodeWidth / 4, right + nodeWidth / 2, gen_3]
            ],
            nodePositions: [
                [left_1, gen_1],
                [right_1, gen_1],
                [left_2, gen_2],
                [right, gen_2],
                [left, gen_3],
                [center, gen_3],
                [right, gen_3]
            ],
            captions: [
                [left_1, gen_3 + nodeHeight / 4],
                [left_1, gen_1 + nodeHeight]//[0.20,0.17],
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
            currentState: ["activeTo", "deactive", "deactive", "deactive", "active", "deactive", "deactive"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandfather")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 6
        {
            edgeList: [
                [0.445, 0.17, 0.567, 0.17],
                [0.515, 0.17, 0.515, 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [0.515, 0.45, 0.515, 0.65],
                [0.33, 0.65, 0.70, 0.65],
                [0.33, 0.65, 0.33, 0.70],
                [0.515, 0.65, 0.515, 0.70],
                [0.70, 0.65, 0.70, 0.725]
            ],
            nodePositions: [
                [0.2911, 0.10],
                [0.553, 0.10],
                [0.251, 0.390],
                [0.588, 0.390],
                [0.22, 0.70],
                [0.43, 0.70],
                [0.65, 0.70]
            ],
            captions: [
                [0.85,0.76],
                [0.743,0.16]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            currentState: ["deactive", "activeTo", "deactive", "deactive", "deactive", "deactive", "active", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandmother")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")],
        },
        // level 7
        {
            edgeList: [
                [0.44, 0.17, 0.567, 0.17],
                [0.515, 0.17, 0.515, 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [0.515, 0.45, 0.515, 0.65],
                [0.33, 0.65, 0.70, 0.65],
                [0.33, 0.65, 0.33, 0.70],
                [0.525, 0.65, 0.525, 0.70],
                [0.70, 0.65, 0.70, 0.725]
            ],
            nodePositions: [
                [0.2911, 0.10],
                [0.553, 0.10],
                [0.251, 0.39],
                [0.588, 0.39],
                [0.22, 0.70],
                [0.43, 0.70],
                [0.65, 0.70]
            ],
            captions: [
                [0.17,0.17],
                [0.85,0.76]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
            currentState: ["active", "deactive", "deactive", "deactive", "deactive", "deactive", "activeTo"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Granddaughter")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 8
        {
            edgeList: [
                [0.44, 0.17, 0.567, 0.17],
                [0.515, 0.17, 0.515, 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [0.515, 0.45, 0.515, 0.65],
                [0.33, 0.65, 0.70, 0.65],
                [0.33, 0.65, 0.33, 0.70],
                [0.515, 0.65, 0.515, 0.70],
                [0.70, 0.65, 0.70, 0.725]
            ],
            nodePositions: [
                [0.2911, 0.10],
                [0.553, 0.10],
                [0.251, 0.39],
                [0.588, 0.39],
                [0.22, 0.70],
                [0.43, 0.70],
                [0.65, 0.70]
            ],
            captions: [
                [0.743,0.16],
                [0.85,0.76]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
            currentState: ["deactive", "active", "deactive", "deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","married","others","others","others","others","others" ],
            answer: [qsTr("Grandson")],
            options: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
        },
        // level 9
        {
            edgeList: [
                [(0.425 + nodeWidth / 2), (0.05 + nodeHeight), (0.425 + nodeWidth / 2), 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [(0.41 - nodeWidth / 2), (0.4 + nodeHeight ), (0.41 - nodeWidth / 2), (0.70 )],
                [(0.588 + nodeWidth / 2), (0.4 + nodeHeight ), (0.588 + nodeWidth / 2), (0.70 )]
            ],
            nodePositions: [
                [0.425, 0.05],
                [0.251, 0.40],
                [0.588, 0.40],
                [0.251, 0.70],
                [0.588, 0.70]
            ],
            captions: [
                [0.83,0.76],
                [0.118,0.76],
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg","boy2.svg"],
            currentState: ["deactive", "deactive", "deactive", "active","activeTo"],
            edgeState:["others","others","others","others"],
            answer: [qsTr("Cousin")],
            options: [qsTr("Brother"), qsTr("Sister"), qsTr("Cousin")]
        },
        // level 10
        {
            edgeList: [
                [(0.425 + nodeWidth / 2), (0.05 + nodeHeight), (0.425 + nodeWidth / 2), 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [(0.41 - nodeWidth / 2), (0.4 + nodeHeight ), (0.41 - nodeWidth / 2), (0.70 )]
            ],
            nodePositions: [
                [0.425, 0.05],
                [0.251, 0.40],
                [0.588, 0.40],
                [0.251, 0.70]
            ],
            captions: [
                [0.10,0.76],
                [0.77,0.45]
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            currentState: ["deactive", "deactive", "activeTo", "active"],
            edgeState:["others","others","others"],
            answer: [qsTr("Uncle")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 11
        {
            edgeList: [
                [(0.425 + nodeWidth / 2), (0.05 + nodeHeight), (0.425 + nodeWidth / 2), 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [(0.41 - nodeWidth / 2), (0.4 + nodeHeight ), (0.41 - nodeWidth / 2), (0.70 )]
            ],
            nodePositions: [
                [0.425, 0.05],
                [0.251, 0.40],
                [0.588, 0.40],
                [0.251, 0.70]
            ],
            captions: [
                [0.77,0.45],
                [0.118,0.76],
            ],
            nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
            currentState: ["deactive", "deactive", "active", "activeTo"],
            edgeState:["others","others","others"],
            answer: [qsTr("Nephew")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 12
        {
            edgeList: [
                [0.45, 0.17, 0.56, 0.17],
                [0.515, 0.17, 0.515, 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [(0.251 + nodeWidth / 2), (0.40 + nodeHeight ), (0.251 + nodeWidth / 2), 0.70]
            ],
            nodePositions: [
                [0.301, 0.10],
                [0.553, 0.10],
                [0.251, 0.40],
                [0.588, 0.40],
                [0.251, 0.70]
            ],
            captions: [
                [0.118,0.76],
                [0.83,0.45],
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
            currentState: ["deactive", "deactive", "deactive", "activeTo", "active"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Aunt")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 13
        {
            edgeList: [
                [0.44, 0.17, 0.55, 0.17],
                [0.505, 0.17, 0.505, 0.45],
                [0.41, 0.45, 0.60, 0.45],
                [(0.251 + nodeWidth / 2), (0.40 + nodeHeight ), (0.251 + nodeWidth / 2), 0.70]
            ],
            nodePositions: [
                [0.291, 0.10],
                [0.543, 0.10],
                [0.251, 0.40],
                [0.588, 0.40],
                [0.251, 0.70]
            ],
            captions: [
                [0.83,0.45],
                [0.118,0.76]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babygirl.svg"],
            currentState: ["deactive", "deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","siblings","others","others","others"],
            answer: [qsTr("Niece")],
            options: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
        },
        // level 14
        {
            edgeList: [
                [0.62, 0.16, 0.745, 0.16],
                [0.69, 0.16, 0.69, 0.70],
                [0.69, 0.52, 0.555, 0.52],
                [0.405, 0.53, 0.32, 0.53],
                [0.68, 0.695, 0.75, 0.695]
            ],
            nodePositions: [
                [0.463, 0.10],
                [0.733, 0.10],
                [0.400, 0.45],
                [0.150, 0.45],
                [0.733, 0.67]
            ],
            captions: [
                [0.02,0.51],
                [0.32,0.16]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentState: ["activeTo", "deactive", "deactive", "active", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Father-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 15
        {
            edgeList: [
                [0.62, 0.16, 0.745, 0.16],
                [0.69, 0.16, 0.69, 0.70],
                [0.69, 0.50, 0.555, 0.50],
                [0.405, 0.53, 0.32, 0.53],
                [0.68, 0.695, 0.75, 0.695]
            ],
            nodePositions: [
                [0.463, 0.10],
                [0.733, 0.10],
                [0.400, 0.45],
                [0.150, 0.45],
                [0.733, 0.67]
            ],
            captions: [
                [0.02,0.51],
                [0.80,0.365],
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentState: ["deactive", "activeTo", "deactive", "active", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Mother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 16
        {
            edgeList: [
                [0.4 + nodeWidth, 0.10 + nodeHeight / 2, 0.733, 0.10 + nodeHeight / 2],
                [(0.40 + nodeWidth + 0.733) / 2, 0.10 + nodeHeight / 2, (0.40 + nodeWidth + 0.733) / 2, 0.55 + nodeHeight / 2],
                [0.40 + nodeWidth, 0.55 + nodeHeight / 2, 0.68, 0.55 + nodeHeight / 2],
                [0.15 + nodeWidth, 0.55 + nodeHeight / 2, 0.40, 0.55 + nodeHeight / 2],
                [0.68, 0.55 + nodeHeight / 2, 0.733, 0.55 + nodeHeight / 2]
            ],
            nodePositions: [
                [0.400, 0.10],
                [0.733, 0.10],
                [0.400, 0.55],
                [0.150, 0.55],
                [0.733, 0.55]
            ],
            captions: [
                [0.02, 0.55],
                [0.733 + nodeWidth, 0.55 + nodeHeight / 2]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentState: ["deactive", "deactive", "deactive", "active", "activeTo"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Brother-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 17
        {
            edgeList: [
                [0.50, 0.16, 0.61, 0.16],
                [0.56, 0.16, 0.56, 0.70],
                [0.56, 0.50, 0.44, 0.50],
                [0.310, 0.53, 0.21, 0.53],
                [0.555, 0.695, 0.63, 0.695],
                [0.615, 0.765, 0.47, 0.765]
            ],
            nodePositions: [
                [0.343, 0.10],
                [0.603, 0.10],
                [0.300, 0.45],
                [0.040, 0.45],
                [0.603, 0.67],
                [0.30, 0.70]
            ],
            captions: [
                [0.10,0.34],
                [0.20,0.76]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg", "lady1.svg"],
            currentState: ["dective", "deactive", "deactive", "active", "deactive", "activeTo"],
            edgeState:["married","others","others","married","others","married"],
            answer: [qsTr("Sister-in-law")],
            options: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        },
        // level 18
        {
            edgeList: [
                [0.61, 0.16, 0.745, 0.16],
                [0.69, 0.16, 0.69, 0.70],
                [0.69, 0.50, 0.56, 0.50],
                [0.41, 0.53, 0.32, 0.53],
                [0.69, 0.695, 0.75, 0.695]
            ],
            nodePositions: [
                [0.463, 0.10],
                [0.733, 0.10],
                [0.400, 0.45],
                [0.150, 0.45],
                [0.733, 0.67]
            ],
            captions: [
                [0.32,0.15],
                [0.05,0.50]
            ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "lady2.svg", "man3.svg", "man1.svg"],
            currentState: ["active", "deactive", "deactive", "activeTo", "deactive", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Son-in-law")],
            options: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
        }
    ]
}