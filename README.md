# Confluence space to github markdown pages
Convert a confluence space export in XML format to github markdown pages

## Installation Requirements

Requires
[xsltproc](https://gitlab.gnome.org/GNOME/libxslt/-/wikis/home) to be
installed, e.g. on Debian, Ubuntu or derivatives call with root
permissions:

```
apt install xsltproc
```

## To export a space from confluence
1. In confluence, navigate to Space Tools / Content Tools / Export and choose XML format
2. Download the export zip and unzip
3. Run generate.sh script
4. Review generated content under out/wiki
5. Copy content from out/wiki to your cloned github wiki and add/push

## Example of export / import commands
```bash
# git clone git@github.com:sjones4/confluence-to-github.git
# cd confluence-to-github
# unzip ~/Downloads/Confluence-export.zip
# ./generate.sh
# rm out/wiki/Services-Team-Space.md  # optionally delete space home page
# cp -pvr out/wiki/* ~/Work/eucalyptus.wiki/
# cd ~/Work/eucalyptus.wiki/
# git add *
# git commmit -m "Confluence services team space import"
```

