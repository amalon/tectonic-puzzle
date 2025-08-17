Tectonic Plates Puzzle for 3D Printing
======================================

This project aims to create a 20cm diameter 3D printable globe puzzle of the
Earth's tectonic plates and internal structure.


Sources
=======

The following image textures are downloaded by the `Makefile` into
`downloads/`, converted/renamed into `textures/` and referenced by the
`tectonic-puzzle.blend` file:
- `unavco_moho.tif`
  - Based on `mohoGOCE180.nc` from
    [unavco.org](https://www.unavco.org/software/visualization/idv/IDV_datasource_Moho.html).
  - This is the default Moho data used, and requires offsetting from bathymetry
    data (using `bathy_moho.tif`).
  - Better raw data is available (see `gemma_moho.tif` below).
- `gemma_moho.tif`, based on `moho.zip/t6.asc` from
  [GOCE OWS data service](http://gocedata.como.polimi.it/)
  - D. Sampietro, M. Reguzzoni, M. Negretti (2013). The GEMMA crustal model:
    first validation and data distribution. In: Proceedings of the ESA Living
    Planet Symposium, 9-13 September 2013, Edinburgh (UK), ESA SP-722
  - This appears to be better raw data, and doesn't need offsetting.
  - Magnet positions & 3mf build plate layout not updated, and 3d printing not
    tested.
- `bathy.tif` and `bathy_moho.tif`, based on `gebco_bathy.5400x2700_16bit.tif`
  from [SBCODE Tutorials](https://sbcode.net/topoearth/gebco-heightmap-5400x2700/).
  - Attribution: Heightmaps based on GEBCO 2020 Grid and preprocessed by Sean
    Bradley : https://sbcode.net/topoearth/gebco-heightmap-5400x2700/#license
  - Resampled down to to 4k and 720x360 (for offsetting `unavco_moho.tif`)
    respectively.
- `earth_specular.tif`, `earth_map.tif`
  - based on `8k_earth_specular_map.tif` and `8k_earth_daymap.jpg` from
    [Solar System Scope](https://www.solarsystemscope.com/textures/).
  - Distributed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/)
  - Resampled down to 4k.
