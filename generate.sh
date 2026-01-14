#!/bin/bash
########################################################################
# Generate github markdown pages from confluence export
########################################################################

# From https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e

echo "Creating output directories"
mkdir -pv out/page-xml
mkdir -pv out/wiki/images

echo "Generating page xmls and image mapping"
xsltproc --stringparam dtd-path "$SCRIPT_DIR/page.dtd" $SCRIPT_DIR/entities.xsl entities.xml

echo "Copying images from attachments"
xsltproc $SCRIPT_DIR/image-mappings.xsl out/image-mappings.xml | bash


echo "Convert page xmls to github markdown"
for PAGE_PATH in out/page-xml/*.xml; do 
   PAGE_XML=${PAGE_PATH##out/page-xml/}
   PAGE_MD=${PAGE_XML%%.xml}.md
   xsltproc --path . $SCRIPT_DIR/page.xsl "${PAGE_PATH}" > "out/wiki/${PAGE_MD}"
done

echo "Content generated to out/wiki"

