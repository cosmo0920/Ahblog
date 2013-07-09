#!/bin/bash -ex

cabal-dev configure
cabal-dev build
strip dist/build/Ahblog/Ahblog
rm -rf static/tmp
tar czfv Ahblog.keter dist/build/Ahblog/Ahblog page config static/{css,files/uploaded_image_dir,img,js}
