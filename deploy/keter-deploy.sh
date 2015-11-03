#!/bin/bash -ex

stack build
mkdir -p dist/build/Ahblog/
cp .stack-work/install/x86_64-linux/lts-3.11/7.10.2/bin/Ahblog dist/build/Ahblog/Ahblog
strip dist/build/Ahblog/Ahblog
rm -rf static/tmp
cp bootstrap-select/bootstrap-select.min.js static/js/bootstrap-select.min.js
cp bootstrap-select/bootstrap-select.min.css static/css/bootstrap-select.min.css
tar czfv Ahblog.keter dist/build/Ahblog/Ahblog page config static/{css,files,img,fonts,js}
