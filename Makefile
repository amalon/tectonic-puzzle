UNZIP=unzip
GDAL_TRANSLATE=gdal_translate
TIF_OPTS=-co COMPRESS=DEFLATE

DOWNLOAD_DIR=downloads
TEXTURES_DIR=textures

BLEND_DEPS += ${TEXTURES_DIR}/bathy.tif
BLEND_DEPS += ${TEXTURES_DIR}/bathy_moho.tif
BLEND_DEPS += ${TEXTURES_DIR}/earth_specular.tif
BLEND_DEPS += ${TEXTURES_DIR}/earth_map.tif
BLEND_DEPS += ${TEXTURES_DIR}/unavco_moho.tif
BLEND_DEPS += ${TEXTURES_DIR}/gemma_moho.tif

all: ${BLEND_DEPS}

# Download sources.
# See README.md for details and attribution.
# Modified dates need updating (with touch) on downloaded/extracted files for
# dependencies to work.

${DOWNLOAD_DIR}/mohoGOCE180.nc:
	mkdir -p ${DOWNLOAD_DIR}
	wget -O $@ 'https://www.unavco.org/software/visualization/idv/display_images/mohoGOCE180.nc'
	touch $@

${DOWNLOAD_DIR}/moho.zip:
	mkdir -p ${DOWNLOAD_DIR}
	wget -O $@ 'http://gocedata.como.polimi.it/moho.zip'
	touch $@

${DOWNLOAD_DIR}/moho/t6.asc: ${DOWNLOAD_DIR}/moho.zip
	mkdir -p ${DOWNLOAD_DIR}/moho
	rm -f $@
	${UNZIP} $< t6.asc -d ${DOWNLOAD_DIR}/moho
	touch $@

${DOWNLOAD_DIR}/8k_earth_specular_map.tif:
	mkdir -p ${DOWNLOAD_DIR}
	wget -O $@ 'https://www.solarsystemscope.com/textures/download/8k_earth_specular_map.tif'
	touch $@

${DOWNLOAD_DIR}/8k_earth_daymap.jpg:
	mkdir -p ${DOWNLOAD_DIR}
	wget -O $@ 'https://www.solarsystemscope.com/textures/download/8k_earth_daymap.jpg'
	touch $@

${DOWNLOAD_DIR}/gebco_bathy.5400x2700_16bit.tif:
	mkdir -p ${DOWNLOAD_DIR}
	wget -O $@ 'https://sbcode.net/topoearth/downloads/gebco_bathy.5400x2700_16bit.tif'
	touch $@

# Generate textures required by tectonic-puzzle.blend in textures/ from soruces/.

# Downsample bathymetry data to 4k.
${TEXTURES_DIR}/bathy.tif: ${DOWNLOAD_DIR}/gebco_bathy.5400x2700_16bit.tif
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} -outsize 4096 2048 $< $@

# Downsample bathymetry data to same resolution as Moho depth.
${TEXTURES_DIR}/bathy_moho.tif: ${DOWNLOAD_DIR}/gebco_bathy.5400x2700_16bit.tif
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} -outsize 720 360 $< $@

# Downsample specular map to 4k.
${TEXTURES_DIR}/earth_specular.tif: ${DOWNLOAD_DIR}/8k_earth_specular_map.tif
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} -outsize 4096 2048 $< $@

# Downsample map to 4k.
${TEXTURES_DIR}/earth_map.tif: ${DOWNLOAD_DIR}/8k_earth_daymap.jpg
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} -outsize 4096 2048 $< $@

# Convert moho depth from NetCDF.
${TEXTURES_DIR}/unavco_moho.tif: ${DOWNLOAD_DIR}/mohoGOCE180.nc
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} $< $@

# Convert GEMMA mantle from ASCII Gridded.
${TEXTURES_DIR}/gemma_moho.tif: ${DOWNLOAD_DIR}/moho/t6.asc
	mkdir -p ${TEXTURES_DIR}
	${GDAL_TRANSLATE} ${TIF_OPTS} $< $@
