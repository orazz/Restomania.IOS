"use strict"
const gulp = require("gulp");
const format = require("gulp-format");

const _sources = [
    "./IOS Library/**/*.swift",
    "./Restomania.App.Kuzina/**/*.swift",
    "./FindMe/**/*.swift"
]

gulp.task("format", () => {
    return gulp.src(_sources)
               .pipe(format());
});

