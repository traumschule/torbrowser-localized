#!/usr/bin/env bash
set -e
languages="de fr"
domain="start-tor-browser"
dir="$(dirname $0)/.."
cd $dir || exit 1

# Bail out without argument
if [ -z "$1" ] ; then
  echo "Usage: $(basename $0) [update_po|generate_mo]"
  exit 1
fi

# Update .po and .pot files
if [ "x$1" == "xupdate_po" ] ; then

echo "Updating locale/$domain.pot"
bash --dump-po-strings Browser/$domain > locale/$domain.pot
for lang in $languages ; do
  langdir="locale/$lang"
  pofile="locale/$lang/$domain.po"
  [ -d "$langdir" ] || mkdir "$langdir"
  if [ -f  $pofile ] ; then
    echo -n "Updating $pofile"
    msgmerge --update $pofile "locale/$domain.pot"
  else
    cp locale/$domain.pot $pofile
    echo "Created $pofile."
  fi
done
echo "Done. Now go translating."

# Create .mo files
else if [ "x$1" == "xgenerate_mo" ] ; then
echo "Regenerating .mo files"
for lang in $languages ; do
  langdir="locale/$lang"
  [ -d "$langdir" ] || mkdir "$langdir"
  [ -d "$langdir/LC_MESSAGES" ] || mkdir "$langdir/LC_MESSAGES"
  echo -n "$lang: "
  msgfmt -o "$langdir/LC_MESSAGES/$domain.mo" "locale/$lang/$domain.po"
  echo "Done."
done
fi; fi
