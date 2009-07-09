#!/bin/sh -e

UPSTREAM_VERSION=${UPSTREAM_VERSION:-"$2"}
DEBIAN_SOURCE_VERSION=${DEBIAN_SOURCE_VERSION:-"$2+ds1"}

DESTDIR=$PWD/..
UPSTREAM_SOURCE="$DESTDIR/apache-solr-$UPSTREAM_VERSION.tgz"
UPSTREAM_URL="http://archive.apache.org/dist/lucene/solr/$UPSTREAM_VERSION/apache-solr-$UPSTREAM_VERSION.tgz"
DEBIAN_SOURCE="$DESTDIR/solr_$DEBIAN_SOURCE_VERSION.orig.tar.gz"

# Test if the upstream tarball needs to be downloaded
if [ ! -r $UPSTREAM_SOURCE ]; then
  wget -O "$UPSTREAM_SOURCE" "$UPSTREAM_URL"
fi

# Repackage upstream source file without the third party jars
TEMPDIR="solr-$DEBIAN_SOURCE_VERSION"
mkdir "$TEMPDIR"
echo "Unpacking into tempdir $TEMPDIR..."
tar xzf $UPSTREAM_SOURCE -C $TEMPDIR --strip 1

echo "Removing third party jars, wars, and generated API docs..."
find $TEMPDIR -name \*.jar -exec rm {} \;
find $TEMPDIR -name \*.war -exec rm {} \;
rm -rf $TEMPDIR/dist
rm -rf $TEMPDIR/docs/api

echo "Packing new orig source tarball $DEBIAN_SOURCE..."
# uscan may have already put the symlink there
rm -f $DEBIAN_SOURCE
GZIP=--best tar czf $DEBIAN_SOURCE $TEMPDIR

echo "Removing tempdir $TEMPDIR..."
rm -rf "$TEMPDIR"
