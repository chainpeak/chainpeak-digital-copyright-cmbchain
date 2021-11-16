// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.5.17;

import "@openzeppelin/contracts/drafts/Strings.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./BitMath.sol";
import "./Base64.sol";
import "./HexStrings.sol";

library NFTSvg {
    using Strings for uint256;
    using SafeMath for uint256;
    using SafeMath for uint160;
    using SafeMath for uint8;
    using HexStrings for uint256;

    struct SVGParams {
        string color0;
        string color1;
        string color2;
        string color3;
        string x1;
        string y1;
        string x2;
        string y2;
        string x3;
        string y3;
    }

    function generateSVG(
        uint256 tokenId,
        string memory name,
        uint256 amount,
        string memory unit
    ) internal view returns (string memory svg) {
        uint256 random0 = getRandom(tokenId);
        uint256 random1 = getRandom(tokenId);
        SVGParams memory params = SVGParams({
            color0: tokenToColorHex(random0, 136),
            color1: tokenToColorHex(random1, 136),
            color2: tokenToColorHex(random0, 0),
            color3: tokenToColorHex(random1, 0),
            x1: scale(getCircleCoord(random0, 16, tokenId), 0, 255, 16, 274),
            y1: scale(getCircleCoord(random1, 16, tokenId), 0, 255, 100, 484),
            x2: scale(getCircleCoord(random0, 32, tokenId), 0, 255, 16, 274),
            y2: scale(getCircleCoord(random1, 32, tokenId), 0, 255, 100, 484),
            x3: scale(getCircleCoord(random0, 48, tokenId), 0, 255, 16, 274),
            y3: scale(getCircleCoord(random1, 48, tokenId), 0, 255, 100, 484)
        });
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGBorderText(name),
                    generateSVGCardMantle(name),
                    generateSVGLogo(),
                    generateSVGPositionDataAndLocationCurve(tokenId.fromUint256(), unit, amount),
                    "</svg>"
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="290" height="500" viewBox="0 0 290 500" xmlns="http://www.w3.org/2000/svg"',
                " xmlns:xlink='http://www.w3.org/1999/xlink'>",
                "<defs>",
                '<filter id="f1"><feImage result="p0" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><rect width='290px' height='500px' fill='#",
                            params.color0,
                            "'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p1" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x1,
                            "' cy='",
                            params.y1,
                            "' r='120px' fill='#",
                            params.color1,
                            "'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p2" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x2,
                            "' cy='",
                            params.y2,
                            "' r='120px' fill='#",
                            params.color2,
                            "'/></svg>"
                        )
                    )
                ),
                '" />',
                '<feImage result="p3" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x3,
                            "' cy='",
                            params.y3,
                            "' r='100px' fill='#",
                            params.color3,
                            "'/></svg>"
                        )
                    )
                ),
                '" /><feBlend mode="overlay" in="p0" in2="p1" /><feBlend mode="exclusion" in2="p2" /><feBlend mode="overlay" in2="p3" result="blendOut" /><feGaussianBlur ',
                'in="blendOut" stdDeviation="42" /></filter> <clipPath id="corners"><rect width="290" height="500" rx="42" ry="42" /></clipPath>',
                '<path id="text-path-a" d="M40 12 H250 A28 28 0 0 1 278 40 V460 A28 28 0 0 1 250 488 H40 A28 28 0 0 1 12 460 V40 A28 28 0 0 1 40 12 z" />',
                '<path id="minimap" d="M234 444C234 457.949 242.21 463 253 463" />',
                '<filter id="top-region-blur"><feGaussianBlur in="SourceGraphic" stdDeviation="24" /></filter>',
                '<linearGradient id="grad-up" x1="1" x2="0" y1="1" y2="0"><stop offset="0.0" stop-color="white" stop-opacity="1" />',
                '<stop offset=".9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<linearGradient id="grad-down" x1="0" x2="1" y1="0" y2="1"><stop offset="0.0" stop-color="white" stop-opacity="1" /><stop offset="0.9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-up" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-up)" /></mask>',
                '<mask id="fade-down" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-down)" /></mask>',
                '<mask id="none" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="white" /></mask>',
                '<linearGradient id="grad-symbol"><stop offset="0.7" stop-color="white" stop-opacity="1" /><stop offset=".95" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-symbol" maskContentUnits="userSpaceOnUse"><rect width="290px" height="200px" fill="url(#grad-symbol)" /></mask></defs>',
                '<g clip-path="url(#corners)">',
                '<rect fill="',
                params.color0,
                '" x="0px" y="0px" width="290px" height="500px" />',
                '<rect style="filter: url(#f1)" x="0px" y="0px" width="290px" height="500px" />',
                ' <g style="filter:url(#top-region-blur); transform:scale(1.5); transform-origin:center top;">',
                '<rect fill="none" x="0px" y="0px" width="290px" height="500px" />',
                '<ellipse cx="50%" cy="0px" rx="180px" ry="120px" fill="#000" opacity="0.85" /></g>',
                '<rect x="0" y="0" width="290" height="500" rx="42" ry="42" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" /></g>'
            )
        );
    }

    function generateSVGBorderText(string memory name) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                name,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                name,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>',
                '<textPath startOffset="50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                "chainpeak • cmbchain",
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"',
                ' repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                "chainpeak • cmbchain",
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGCardMantle(string memory name) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g mask="url(#fade-symbol)"><rect fill="none" x="0px" y="0px" width="290px" height="200px" /> <text y="70px" x="32px" fill="white" font-family="\'Courier New\', monospace" font-weight="200" font-size="30px">',
                name,
                "</text>",
                "</g>",
                '<rect x="16" y="16" width="258" height="468" rx="26" ry="26" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" />'
            )
        );
    }

    function generateSVGLogo() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<image id="cmbc" width="100px" height="100px" x="30px" y="200px" ',
                'xlink:href="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNTVweCIgaGVpZ2h0PSI1NXB4IiB2aWV3Qm94PSIwIDAgNTUgMzgiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICAgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgogICAgPHRpdGxlPmNtYmNoYWluIGxvZ288L3RpdGxlPgogICAgPGRlZnM+CiAgICAgICAgPHBvbHlnb24gaWQ9InBhdGgtMSIKICAgICAgICAgICAgcG9pbnRzPSIwLjA2OTI1NzYwNzIgMC4wMTg1MDQyNjMxIDQ2LjE4OTM5NjggMC4wMTg1MDQyNjMxIDQ2LjE4OTM5NjggMzYuMTA2NzE5NiAwLjA2OTI1NzYwNzIgMzYuMTA2NzE5NiI+CiAgICAgICAgPC9wb2x5Z29uPgogICAgICAgIDxwb2x5Z29uIGlkPSJwYXRoLTMiIHBvaW50cz0iMCAwLjAxNjIzMDQzOTEgNy4xMzQ1NDg0OCAwLjAxNjIzMDQzOTEgNy4xMzQ1NDg0OCA3LjE1MDc4MTM3IDAgNy4xNTA3ODEzNyI+CiAgICAgICAgPC9wb2x5Z29uPgogICAgICAgIDxwb2x5Z29uIGlkPSJwYXRoLTUiCiAgICAgICAgICAgIHBvaW50cz0iMC4wNTgwNTYwMjkyIDAuMDcyNDQ3MjU5NCAyMS42MTAxNzMgMC4wNzI0NDcyNTk0IDIxLjYxMDE3MyAyMS42MjQ0NzY1IDAuMDU4MDU2MDI5MiAyMS42MjQ0NzY1Ij4KICAgICAgICA8L3BvbHlnb24+CiAgICAgICAgPHBvbHlnb24gaWQ9InBhdGgtNyIKICAgICAgICAgICAgcG9pbnRzPSIwLjAxMTY4MTM2NDIgMC4wNzA3MjgzOCAzLjk4MDAxMjY3IDAuMDcwNzI4MzggMy45ODAwMTI2NyA2LjQwMTk0ODg0IDAuMDExNjgxMzY0MiA2LjQwMTk0ODg0Ij4KICAgICAgICA8L3BvbHlnb24+CiAgICAgICAgPHBvbHlnb24gaWQ9InBhdGgtOSIKICAgICAgICAgICAgcG9pbnRzPSIwLjAzMzY0MDkyNTcgMC4wNzA3MjgzOCA0LjMzNTEzNjY2IDAuMDcwNzI4MzggNC4zMzUxMzY2NiA2LjQwMTk0ODg0IDAuMDMzNjQwOTI1NyA2LjQwMTk0ODg0Ij4KICAgICAgICA8L3BvbHlnb24+CiAgICAgICAgPHBvbHlnb24gaWQ9InBhdGgtMTEiCiAgICAgICAgICAgIHBvaW50cz0iMC4wNjYyMjk0NzYyIDAuMDcwNzI4MzggNC4wMzQ1NjA3OCAwLjA3MDcyODM4IDQuMDM0NTYwNzggNi40MDE5NDg4NCAwLjA2NjIyOTQ3NjIgNi40MDE5NDg4NCI+CiAgICAgICAgPC9wb2x5Z29uPgogICAgICAgIDxwb2x5Z29uIGlkPSJwYXRoLTEzIiBwb2ludHM9IjAgMzYuMjAwNzQwNiAxNDMuOTQ4Nzg0IDM2LjIwMDc0MDYgMTQzLjk0ODc4NCAwLjA4NzY5NzkyOTQgMCAwLjA4NzY5NzkyOTQiPgogICAgICAgIDwvcG9seWdvbj4KICAgIDwvZGVmcz4KICAgIDxnIGlkPSJjbWJjLWluZGV4IiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4KICAgICAgICA8ZyBpZD0iY21iYy1pbmRleC1yZWQyIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMTYwLjAwMDAwMCwgLTE0LjAwMDAwMCkiPgogICAgICAgICAgICA8ZyBpZD0iYmlhbnp1IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxNjAuMDAwMDAwLCAxNC4wMDAwMDApIj4KICAgICAgICAgICAgICAgIDxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDQuMjA5NTAxLCAwLjA2OTE5NCkiPgogICAgICAgICAgICAgICAgICAgIDxtYXNrIGlkPSJtYXNrLTIiIGZpbGw9IndoaXRlIj4KICAgICAgICAgICAgICAgICAgICAgICAgPHVzZSB4bGluazpocmVmPSIjcGF0aC0xIj48L3VzZT4KICAgICAgICAgICAgICAgICAgICA8L21hc2s+CiAgICAgICAgICAgICAgICAgICAgPGcgaWQ9IkNsaXAtMiI+PC9nPgogICAgICAgICAgICAgICAgICAgIDxwYXRoCiAgICAgICAgICAgICAgICAgICAgICAgIGQ9Ik0yNC45MjMyMDc4LDI4Ljk3MzU0NTQgTDIxLjMxNDA4NzIsMjguOTczNTQ1NCBMMjMuMTE3ODU4MiwyNS42MzgwNDI0IEwyNC45MjMyMDc4LDI4Ljk3MzU0NTQgWiBNNDUuNzU4NzQ0OSwyMi40NzQ3NzgxIEwzNC41ODIzNDU0LDIuMjA1NjgxODUgQzM0LjI1OTc5MjQsMS42MDk5NDk4MiAzMy43OTIxODcxLDEuMTQyODcwNjUgMzMuMjQ2OTY5MSwwLjgyNDUyNzE2MiBDMzMuMDc2MjIxMiwwLjY4NTM1MDU0OCAzMi44OTA1NjQ3LDAuNTU5MzI4NjI0IDMyLjY4OTczNjQsMC40NTA0OTU0OTMgQzMwLjk1Nzk2NTQsLTAuNDg3NjA5MjU3IDI4Ljc5Mzc1NTksMC4xNTY1MzIwMzQgMjcuODU2OTY2NiwxLjg4ODkxNjkzIEwyMy4xMTc4NTgyLDEwLjY1Mjc0NjQgTDE4LjM3Mzc1MSwxLjg4ODAzOTk1IEMxNy40MzYxNzI1LDAuMTU1NjU1MDU1IDE1LjI3MTc4NzYsLTAuNDg4NDg2MjM2IDEzLjUzOTQ5MDQsMC40NDkxODAwMjQgQzEzLjMwMzY3MDYsMC41NzY4NjgyMSAxMy4wODg3MjMsMC43Mjc4ODQwNDQgMTIuODk0NDcyMSwwLjg5Njg3Nzk1NCBDMTIuMzk5NTkyNywxLjIxMTk3NjYxIDExLjk3NTM5NzgsMS42NTMyNzI1OSAxMS42NzYzNDc5LDIuMjA1NjgxODUgTDAuNDk5OTQ4MzU2LDIyLjMxNTk1NzEgQy0wLjQzNzcxNzkwNSwyNC4wNDgyNTQzIDAuMjA2NTExMDg0LDI2LjIxMjYzOTIgMS45Mzg4MDgyOCwyNy4xNTAzMDU1IEMzLjY3MTEwNTQ4LDI4LjA4Nzg4NCA1LjgzNTU3ODA4LDI3LjQ0Mzc0MjggNi43NzMxNTY2NCwyNS43MTE0NDU2IEwxNS4xMTEwMzczLDEwLjg0NTMzMTEgTDE5LjA2NDE5NjgsMTguMTQ4ODE0NiBMMTIuNDI2MjUyOSwzMC40MjQwNjkyIEMxMi4zMjYxODk1LDMwLjYwODkzNjQgMTIuMjQ1NDE5NywzMC43OTg5Nzc4IDEyLjE4MDc4NjQsMzAuOTkxODI1NiBDMTEuOTU0Nzg4OCwzMS40NjAxMzI1IDExLjgyODA2NTMsMzEuOTg1MzU1NCAxMS44MjgwNjUzLDMyLjU0MDEzMjUgTDExLjgyODA2NTMsMzIuNTQwMjIwMiBDMTEuODI4MDY1MywzNC41MDk5MTU3IDEzLjQyNDg2OTIsMzYuMTA2NzE5NiAxNS4zOTQ2NTI0LDM2LjEwNjcxOTYgTDMwLjg0OTgzMzksMzYuMTA2NzE5NiBDMzIuODE5NjE3MSwzNi4xMDY3MTk2IDM0LjQxNjQyMSwzNC41MDk5MTU3IDM0LjQxNjQyMSwzMi41NDAyMjAyIEwzNC40MTY0MjEsMzIuNTQwMTMyNSBDMzQuNDE2NDIxLDMxLjk4Njc1ODYgMzQuMjkwMzk5LDMxLjQ2MjkzODkgMzQuMDY1NDUzOCwzMC45OTU1OTY2IEMzNC4wMDA0Njk3LDMwLjgwMDExNzkgMzMuOTE4NTU5OCwzMC42MDc0NDU2IDMzLjgxNzE4MSwzMC40MjAwMzUxIEwyNy4xNzE1MTk2LDE4LjE0MTc5ODggTDMxLjEzMjM5NjYsMTAuODE3MTggTDM5LjQ4NTUzNjcsMjUuODcwMjY2NSBDNDAuNDIzMTE1MiwyNy42MDI1NjM3IDQyLjU4NzU4NzgsMjguMjQ2NzkyNyA0NC4zMTk4ODUsMjcuMzA5MTI2NCBDNDYuMDUyMTgyMiwyNi4zNzE1NDc5IDQ2LjY5NjMyMzUsMjQuMjA3MDc1MyA0NS43NTg3NDQ5LDIyLjQ3NDc3ODEgTDQ1Ljc1ODc0NDksMjIuNDc0Nzc4MSBaIgogICAgICAgICAgICAgICAgICAgICAgICBpZD0iRmlsbC0xIiBmaWxsPSIjQzgxNTJEIiBtYXNrPSJ1cmwoI21hc2stMikiPjwvcGF0aD4KICAgICAgICAgICAgICAgIDwvZz4KICAgICAgICAgICAgICAgIDxwYXRoCiAgICAgICAgICAgICAgICAgICAgZD0iTTU0LjI0NzAyNzUsMzAuODA3NjU5OSBMNTQuMjQ3MDI3NSwzMC44MDc2NTk5IEM1My4zMDk0NDksMjkuMDc1Mjc1IDUxLjE0NDk3NjQsMjguNDMxMDQ2IDQ5LjQxMjY3OTIsMjkuMzY4NzEyMyBDNDcuNjgwMzgyLDMwLjMwNjM3ODYgNDcuMDM2MTUzLDMyLjQ3MDc2MzUgNDcuOTczODE5MiwzNC4yMDMwNjA3IEM0OC45MTEzOTc4LDM1LjkzNTM1NzkgNTEuMDc1ODcwNCwzNi41Nzk0OTkxIDUyLjgwODA3OTksMzUuNjQxOTIwNiBDNTQuNTQwNDY0OCwzNC43MDQzNDIgNTUuMTg0NjA2MSwzMi41Mzk4Njk0IDU0LjI0NzAyNzUsMzAuODA3NjU5OSIKICAgICAgICAgICAgICAgICAgICBpZD0iRmlsbC0zIiBmaWxsPSIjQzgxNTJEIj48L3BhdGg+CiAgICAgICAgICAgICAgICA8ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwLjAwMDAwMCwgMjguOTIxODEyKSI+CiAgICAgICAgICAgICAgICAgICAgPG1hc2sgaWQ9Im1hc2stNCIgZmlsbD0id2hpdGUiPgogICAgICAgICAgICAgICAgICAgICAgICA8dXNlIHhsaW5rOmhyZWY9IiNwYXRoLTMiPjwvdXNlPgogICAgICAgICAgICAgICAgICAgIDwvbWFzaz4KICAgICAgICAgICAgICAgICAgICA8ZyBpZD0iQ2xpcC02Ij48L2c+CiAgICAgICAgICAgICAgICAgICAgPHBhdGgKICAgICAgICAgICAgICAgICAgICAgICAgZD0iTTUuMjY0OTk3ODEsMC40NDY4ODIzMzkgQzMuNTMyNzAwNjEsLTAuNDkwNjk2MjI0IDEuMzY4MjI4MDEsMC4xNTM0NDUwNjcgMC40MzA2NDk0NTIsMS44ODU3NDIyNyBMMC40MzA2NDk0NTIsMS44ODU4Mjk5NiBDLTAuNTA2OTI5MTExLDMuNjE4MDM5NDYgMC4xMzcyMTIxOCw1Ljc4MjUxMjA2IDEuODY5NTA5MzgsNi43MjAwOTA2MiBDMy42MDE4MDY1OCw3LjY1Nzc1Njg4IDUuNzY2Mjc5MTcsNy4wMTM1Mjc4OSA2LjcwMzg1NzczLDUuMjgxMjMwNjkgQzcuNjQxNTI0LDMuNTQ4OTMzNSA2Ljk5NzI5NTAxLDEuMzg0NTQ4NiA1LjI2NDk5NzgxLDAuNDQ2ODgyMzM5IgogICAgICAgICAgICAgICAgICAgICAgICBpZD0iRmlsbC01IiBmaWxsPSIjQzgxNTJEIiBtYXNrPSJ1cmwoI21hc2stNCkiPjwvcGF0aD4KICAgICAgICAgICAgICAgIDwvZz4KICAgICAgICAgICAgPC9nPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+" />',
                '<line x1="0" y1="0" x2="25" y2="25" style="stroke:#4d4849;stroke-width:4;transform:translate(140px, 235px)" />',
                '<line x1="25" y1="0" x2="0" y2="25" style="stroke:#4d4849;stroke-width:4;transform:translate(140px, 235px)" />',
                '<image id="image10" width="70" height="80" x="180" y="210" '
                'xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzc1IiBoZWlnaHQ9IjQyOCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBjbGFzcz0ibGF5ZXIiPjx0aXRsZT5MYXllciAxPC90aXRsZT48cmVjdCBmaWxsPSIjMDAwMDAwIiBmaWxsLW9wYWNpdHk9IjAiIGhlaWdodD0iMSIgaWQ9InN2Z182IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTUiIHdpZHRoPSIwIiB4PSIxMDUiIHk9IjU4Ii8+PHBvbHlnb24gZmlsbD0iIzAwMDAwMCIgaWQ9InN2Z18xNCIvPjxwb2x5Z29uIGZpbGw9IiMwMDAwMDAiIGlkPSJzdmdfMTUiLz48cG9seWdvbiBmaWxsPSIjMDAwMDAwIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMTgiIHBvaW50cz0iMTMwLjY2NTEzMDYxNTIzNDM4LDE0MS40MDY4NDUwOTI3NzM0NCA5Ny45OTkyMzcwNjA1NDY4OCwxOTcuOTg1ODA5MzI2MTcxODggMzIuNjY3NDgwNDY4NzUsMTk3Ljk4NTgwOTMyNjE3MTg4IDAuMDAxNTU2Mzk2ODMzNjIwOTY1NSwxNDEuNDA2ODQ1MDkyNzczNDQgMzIuNjY3NDgwNDY4NzUsODQuODI3ODczMjI5OTgwNDcgOTcuOTk5MjM3MDYwNTQ2ODgsODQuODI3ODczMjI5OTgwNDcgMTMwLjY2NTEzMDYxNTIzNDM4LDE0MS40MDY4NDUwOTI3NzM0NCAiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLXdpZHRoPSIxNSIgdHJhbnNmb3JtPSJyb3RhdGUoODkuOTMyOCA2NS4zMzMzIDE0MS40MDcpIi8+PHBvbHlnb24gZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzIwIiBwb2ludHM9IjM3Ni42NjUxNjExMzI4MTI1LDI4Mi43NDAxNzMzMzk4NDM3NSAzNDMuOTk5MjY3NTc4MTI1LDMzOS4zMTkxNTI4MzIwMzEyNSAyNzguNjY3NTEwOTg2MzI4MSwzMzkuMzE5MTUyODMyMDMxMjUgMjQ2LjAwMTYxNzQzMTY0MDYyLDI4Mi43NDAxNzMzMzk4NDM3NSAyNzguNjY3NTEwOTg2MzI4MSwyMjYuMTYxMTc4NTg4ODY3MiAzNDMuOTk5MjY3NTc4MTI1LDIyNi4xNjExNzg1ODg4NjcyIDM3Ni42NjUxNjExMzI4MTI1LDI4Mi43NDAxNzMzMzk4NDM3NSAiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLXdpZHRoPSIxNSIgdHJhbnNmb3JtPSJyb3RhdGUoODkuOTMyOCAzMTEuMzM0IDI4Mi43NDEpIi8+PHBvbHlnb24gZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzIxIiBwb2ludHM9IjI1My45OTg0NzQxMjEwOTM3NSwzNTEuNDA2ODI5ODMzOTg0NCAyMjEuMzMyNTgwNTY2NDA2MjUsNDA3Ljk4NTgwOTMyNjE3MTkgMTU2LjAwMDgyMzk3NDYwOTM4LDQwNy45ODU4MDkzMjYxNzE5IDEyMy4zMzQ5MzA0MTk5MjE4OCwzNTEuNDA2ODI5ODMzOTg0NCAxNTYuMDAwODIzOTc0NjA5MzgsMjk0LjgyNzg1MDM0MTc5NjkgMjIxLjMzMjU4MDU2NjQwNjI1LDI5NC44Mjc4NTAzNDE3OTY5IDI1My45OTg0NzQxMjEwOTM3NSwzNTEuNDA2ODI5ODMzOTg0NCAiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLXdpZHRoPSIxNSIgdHJhbnNmb3JtPSJyb3RhdGUoODkuOTMyOCAxODguNjY3IDM1MS40MDcpIi8+PHBvbHlnb24gZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzIyIiBwb2ludHM9IjEzMC4zMzE4MzI4ODU3NDIyLDI4My40MDY4Mjk4MzM5ODQ0IDk3LjY2NTkzOTMzMTA1NDY5LDMzOS45ODU4MDkzMjYxNzE5IDMyLjMzNDE4MjczOTI1NzgxLDMzOS45ODU4MDkzMjYxNzE5IC0wLjMzMTc0MTMzMzAwNzgxMjUsMjgzLjQwNjgyOTgzMzk4NDQgMzIuMzM0MTgyNzM5MjU3ODEsMjI2LjgyNzg1MDM0MTc5Njg4IDk3LjY2NTkzOTMzMTA1NDY5LDIyNi44Mjc4NTAzNDE3OTY4OCAxMzAuMzMxODMyODg1NzQyMiwyODMuNDA2ODI5ODMzOTg0NCAiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLXdpZHRoPSIxNSIgdHJhbnNmb3JtPSJyb3RhdGUoODkuOTMyOCA2NSAyODMuNDA3KSIvPjxyZWN0IGZpbGw9IiMwMDAwMDAiIGZpbGwtb3BhY2l0eT0iMCIgaGVpZ2h0PSIxMTIuNjY2NjciIGlkPSJzdmdfMjMiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxNSIgd2lkdGg9Ijk0IiB4PSIxNDEuMzMzMzMiIHk9IjE1NyIvPjxwb2x5Z29uIGZpbGw9IiMwMDAwMDAiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18yNSIgcG9pbnRzPSIyNTMuMzMxODE3NjI2OTUzMTIsNzUuMDczNTA5MjE2MzA4NiAyMjAuNjY1OTI0MDcyMjY1NjIsMTMxLjY1MjQ2NTgyMDMxMjUgMTU1LjMzNDE2NzQ4MDQ2ODc1LDEzMS42NTI0NjU4MjAzMTI1IDEyMi42NjgyMTI4OTA2MjUsNzUuMDczNTA5MjE2MzA4NiAxNTUuMzM0MTY3NDgwNDY4NzUsMTguNDk0NTQ0OTgyOTEwMTU2IDIyMC42NjU5MjQwNzIyNjU2MiwxOC40OTQ1NDQ5ODI5MTAxNTYgMjUzLjMzMTgxNzYyNjk1MzEyLDc1LjA3MzUwOTIxNjMwODYgIiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS13aWR0aD0iMTUiIHRyYW5zZm9ybT0icm90YXRlKDg5LjkzMjggMTg4IDc1LjA3MzUpIi8+PHBvbHlnb24gZmlsbD0iIzAwMDAwMCIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzI2IiBwb2ludHM9IjM3NS45OTg1MDQ2Mzg2NzE5LDE0My40MDY4NDUwOTI3NzM0NCAzNDMuMzMyNjExMDgzOTg0NCwxOTkuOTg1Nzk0MDY3MzgyOCAyNzguMDAwODU0NDkyMTg3NSwxOTkuOTg1Nzk0MDY3MzgyOCAyNDUuMzM0ODk5OTAyMzQzNzUsMTQzLjQwNjg0NTA5Mjc3MzQ0IDI3OC4wMDA4NTQ0OTIxODc1LDg2LjgyNzg4MDg1OTM3NSAzNDMuMzMyNjExMDgzOTg0NCw4Ni44Mjc4ODA4NTkzNzUgMzc1Ljk5ODUwNDYzODY3MTksMTQzLjQwNjg0NTA5Mjc3MzQ0ICIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2Utd2lkdGg9IjE1IiB0cmFuc2Zvcm09InJvdGF0ZSg4OS45MzI4IDMxMC42NjcgMTQzLjQwNykiLz48cGF0aCBkPSJtMTkyLjUxMzM0LDc1LjQxMjIxbC01My4xNzA3NiwtMjkuMjM2MzUiIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z183IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiLz48cGF0aCBkPSJtMjM4LjUxMzM0LDc0Ljc0NTU0bC01My4xNzA3NiwtMjkuMjM2MzUiIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18xMSIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2UtZGFzaGFycmF5PSJudWxsIiBzdHJva2UtbGluZWNhcD0ibnVsbCIgc3Ryb2tlLWxpbmVqb2luPSJudWxsIiBzdHJva2Utd2lkdGg9IjEwIiB0cmFuc2Zvcm09InJvdGF0ZSgtNTkuNDE1MyAyMTEuOTI4IDYwLjEyNzQpIi8+PGxpbmUgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzEyIiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiIHgxPSIxODkiIHgyPSIxODkiIHkxPSI3MS42NjY2NyIgeTI9IjEzMy4wMDI5OCIvPjxwYXRoIGQ9Im0zMTQuODIyMzYsMTQzLjIzODEybC01My4xNzA3NiwtMjkuMjM2MzUiIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18xOSIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2UtZGFzaGFycmF5PSJudWxsIiBzdHJva2UtbGluZWNhcD0ibnVsbCIgc3Ryb2tlLWxpbmVqb2luPSJudWxsIiBzdHJva2Utd2lkdGg9IjEwIi8+PHBhdGggZD0ibTM2MC44MjIzNiwxNDIuNTcxNDVsLTUzLjE3MDc2LC0yOS4yMzYzNSIgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzE3IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiIHRyYW5zZm9ybT0icm90YXRlKC01OS40MTUzIDMzNC4yMzcgMTI3Ljk1MykiLz48bGluZSBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMTYiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgeDE9IjMxMS4zMDkwMiIgeDI9IjMxMS4zMDkwMiIgeTE9IjEzOS40OTI1NyIgeTI9IjIwMC44Mjg4OCIvPjxwYXRoIGQ9Im0zMTQuODIyMzYsMjgzLjIzODEybC01My4xNzA3NiwtMjkuMjM2MzUiIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18yOCIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2UtZGFzaGFycmF5PSJudWxsIiBzdHJva2UtbGluZWNhcD0ibnVsbCIgc3Ryb2tlLWxpbmVqb2luPSJudWxsIiBzdHJva2Utd2lkdGg9IjEwIi8+PHBhdGggZD0ibTM2MC44MjIzNiwyODIuNTcxNDVsLTUzLjE3MDc2LC0yOS4yMzYzNSIgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzI3IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiIHRyYW5zZm9ybT0icm90YXRlKC01OS40MTUzIDMzNC4yMzcgMjY3Ljk1MykiLz48bGluZSBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMjQiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgeDE9IjMxMS4zMDkwMiIgeDI9IjMxMS4zMDkwMiIgeTE9IjI3OS40OTI1NyIgeTI9IjM0MC44Mjg4OCIvPjxwYXRoIGQ9Im0xOTIuMTU1NywzNTEuOTA0NzhsLTUzLjE3MDc2LC0yOS4yMzYzNSIgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzMxIiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiLz48cGF0aCBkPSJtMjM4LjE1NTY5LDM1MS4yMzgxMmwtNTMuMTcwNzYsLTI5LjIzNjM1IiBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMzAiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgdHJhbnNmb3JtPSJyb3RhdGUoLTU5LjQxNTMgMjExLjU3IDMzNi42MikiLz48bGluZSBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMjkiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgeDE9IjE4OC42NDIzNSIgeDI9IjE4OC42NDIzNSIgeTE9IjM0OC4xNTkyNCIgeTI9IjQwOS40OTU1NSIvPjxwYXRoIGQ9Im02OS4xNTU2OSwyODMuMjM4MTJsLTUzLjE3MDc2LC0yOS4yMzYzNSIgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzM0IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiLz48cGF0aCBkPSJtMTE1LjE1NTY5LDI4Mi41NzE0NWwtNTMuMTcwNzYsLTI5LjIzNjM1IiBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMzMiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgdHJhbnNmb3JtPSJyb3RhdGUoLTU5LjQxNTMgODguNTcwNCAyNjcuOTUzKSIvPjxsaW5lIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18zMiIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2UtZGFzaGFycmF5PSJudWxsIiBzdHJva2UtbGluZWNhcD0ibnVsbCIgc3Ryb2tlLWxpbmVqb2luPSJudWxsIiBzdHJva2Utd2lkdGg9IjEwIiB4MT0iNjUuNjQyMzUiIHgyPSI2NS42NDIzNSIgeTE9IjI3OS40OTI1OCIgeTI9IjM0MC44Mjg4OSIvPjxwYXRoIGQ9Im02OC44MjIzNiwxNDEuOTA0NzhsLTUzLjE3MDc2LC0yOS4yMzYzNSIgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzM3IiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiLz48cGF0aCBkPSJtMTE0LjgyMjM1LDE0MS4yMzgxMmwtNTMuMTcwNzYsLTI5LjIzNjM1IiBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMzYiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgdHJhbnNmb3JtPSJyb3RhdGUoLTU5LjQxNTMgODguMjM3IDEyNi42MikiLz48bGluZSBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMzUiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgeDE9IjY1LjMwOTAyIiB4Mj0iNjUuMzA5MDIiIHkxPSIxMzguMTU5MjQiIHkyPSIxOTkuNDk1NTUiLz48bGluZSBmaWxsPSJub25lIiBmaWxsLW9wYWNpdHk9IjAiIGlkPSJzdmdfMzgiIHN0cm9rZT0iIzczODNmZiIgc3Ryb2tlLWRhc2hhcnJheT0ibnVsbCIgc3Ryb2tlLWxpbmVjYXA9Im51bGwiIHN0cm9rZS1saW5lam9pbj0ibnVsbCIgc3Ryb2tlLXdpZHRoPSIxMCIgdHJhbnNmb3JtPSJyb3RhdGUoOTAgMTg5LjY2NyAxODcuNjY3KSIgeDE9IjE4OS42NjY2NSIgeDI9IjE4OS42NjY2NSIgeTE9IjE0Ni4zMzE4NCIgeTI9IjIyOS4wMDE0OCIvPjxsaW5lIGZpbGw9Im5vbmUiIGZpbGwtb3BhY2l0eT0iMCIgaWQ9InN2Z18zOSIgc3Ryb2tlPSIjNzM4M2ZmIiBzdHJva2UtZGFzaGFycmF5PSJudWxsIiBzdHJva2UtbGluZWNhcD0ibnVsbCIgc3Ryb2tlLWxpbmVqb2luPSJudWxsIiBzdHJva2Utd2lkdGg9IjEwIiB0cmFuc2Zvcm09InJvdGF0ZSg5MCAxODkuNjY3IDIxNS42NjcpIiB4MT0iMTg5LjY2NjY1IiB4Mj0iMTg5LjY2NjY1IiB5MT0iMTc0LjMzMTg0IiB5Mj0iMjU3LjAwMTQ4Ii8+PGxpbmUgZmlsbD0ibm9uZSIgZmlsbC1vcGFjaXR5PSIwIiBpZD0ic3ZnXzQwIiBzdHJva2U9IiM3MzgzZmYiIHN0cm9rZS1kYXNoYXJyYXk9Im51bGwiIHN0cm9rZS1saW5lY2FwPSJudWxsIiBzdHJva2UtbGluZWpvaW49Im51bGwiIHN0cm9rZS13aWR0aD0iMTAiIHRyYW5zZm9ybT0icm90YXRlKDkwIDE4NyAyNDIuMzMzKSIgeDE9IjE4Ni45OTk5OSIgeDI9IjE4Ni45OTk5OSIgeTE9IjIwMC45OTg1MSIgeTI9IjI4My42NjgxNSIvPjwvZz48L3N2Zz4=" />'
            )
        );
    }

    function generateSVGPositionDataAndLocationCurve(
        string memory tokenId,
        string memory unit,
        uint256 amount
    ) private pure returns (string memory svg) {
        string memory amountStr = amount.fromUint256();
        uint256 str1length = bytes(tokenId).length + 4;
        uint256 str2length = bytes(amountStr).length + 6;
        svg = string(
            abi.encodePacked(
                ' <g style="transform:translate(29px, 384px)">',
                '<rect width="',
                uint256(7 * (str1length + 4)).fromUint256(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">ID: </tspan>',
                tokenId,
                "</text></g>",
                ' <g style="transform:translate(29px, 414px)">',
                '<rect width="',
                uint256(7 * (str2length + 6)).fromUint256(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">数量: </tspan>',
                amountStr,
                " ",
                unit,
                "</text></g>"
            )
        );
    }

    function scale(
        uint256 n,
        uint256 inMn,
        uint256 inMx,
        uint256 outMn,
        uint256 outMx
    ) private pure returns (string memory) {
        return (n.sub(inMn).mul(outMx.sub(outMn)).div(inMx.sub(inMn)).add(outMn)).fromUint256();
    }

    function tokenToColorHex(uint256 token, uint256 offset) internal pure returns (string memory str) {
        return string((token >> offset).toHexStringNoPrefix(3));
    }

    function getCircleCoord(
        uint256 tokenAddress,
        uint256 offset,
        uint256 tokenId
    ) internal pure returns (uint256) {
        return (uint256(uint8(tokenAddress >> offset)) * tokenId) % 255;
    }

    function getRandom(uint256 tokenId) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, tokenId)));
    }
}
