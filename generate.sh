#!/bin/bash
########################################################################
# Generate github markdown pages from confluence export
########################################################################

set -e

echo "Creating output directories"
mkdir -pv out/page-xml
mkdir -pv out/wiki/images

echo "Generating page xmls and image mapping"
xsltproc entities.xsl entities.xml

echo "Copying images from attachments"
xsltproc image-mappings.xsl out/image-mappings.xml | bash


echo "Convert page xmls to github markdown"
for PAGE_PATH in out/page-xml/*.xml; do 
   PAGE_XML=${PAGE_PATH##out/page-xml/}
   PAGE_MD=${PAGE_XML%%.xml}.md
   xsltproc --path . page.xsl "${PAGE_PATH}" > "out/wiki/${PAGE_MD}"
done

echo "Content generated to out/wiki"

