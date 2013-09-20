#!/bin/bash -ex

cabal-dev configure
cabal-dev build
strip dist/build/Ahblog/Ahblog
rm -rf static/tmp
cp bootstrap-select/bootstrap-select.min.js static/js/bootstrap-select.min.js
cp bootstrap-select/bootstrap-select.min.css static/css/bootstrap-select.min.css
tar czfv Ahblog.keter dist/build/Ahblog/Ahblog page config static/{css,files/uploaded_image_dir,img,js}
