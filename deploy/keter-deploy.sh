#!/bin/bash -ex

cabal configure
cabal build
strip dist/build/Ahblog/Ahblog
rm -rf static/tmp
tar czfv Ahblog.keter dist/build/Ahblog/Ahblog page config static/{css,files/uploaded_image_dir,img,js}
