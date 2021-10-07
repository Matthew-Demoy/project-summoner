"use strict";
exports.__esModule = true;
var get_pixels_1 = require("get-pixels");
var mapName = process.env.MAP_NAME;
(0, get_pixels_1["default"])("../maps/" + mapName, function (err, pixels) {
    if (err) {
        console.log("err " + err);
    }
    console.log(pixels);
});
