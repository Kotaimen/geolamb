FROM lambci/lambda:build-python3.7

### Build PROJ.4

RUN \
  curl -L http://download.osgeo.org/proj/proj-4.9.3.tar.gz | tar zxf - -C /tmp

WORKDIR /tmp/proj-4.9.3

RUN \
  ./configure --prefix=/opt && \
  make -j $(nproc) && make install

### Build GEOS

RUN \
  curl http://download.osgeo.org/geos/geos-3.7.1.tar.bz2 | tar jxf - -C /tmp

WORKDIR /tmp/geos-3.7.1

RUN \
  ./configure --prefix=/opt && \
  make -j $(nproc) && make install


### Build GDAL
RUN \
  mkdir -p /tmp/gdal-dev && \
  curl -L https://github.com/OSGeo/gdal/archive/v2.3.2.tar.gz | tar zxf - -C /tmp/gdal-dev --strip-components=1

WORKDIR /tmp/gdal-dev/gdal
RUN \
  ./configure \
    --prefix=/opt \
    --datarootdir=/opt/share/gdal \
    --with-jpeg=internal \
    --without-qhull \
    --without-mrf \
    --without-grib \
    --without-pcraster \
    --without-png \
    --without-gif \
    --without-pcidsk && \
  make -j $(nproc) && \
  make install


### Copy and strip binaries, then install python packages

WORKDIR /opt

RUN \
  strip lib/libgdal.so && \
  strip lib/libgeos.so && \
  strip lib/libproj.so && \
  \
  pip install -U \
    gdal \
    numpy \
    pillow \
    shapely \
#    rasterio \
    -t /opt/python/lib/python3.7/site-packages/ && \
  \
  rm lib/*.a && \
  rm -rf include


### Create zip package

RUN zip -r9 --symlinks /tmp/layer.zip .
