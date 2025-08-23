Development Guide
=================

The high resolution models produced using this project are largely generated
procedurally using various downloaded resources by Blender geometry nodes. This
document describes some of the processes involved. It is intended for advanced
users wishing to make changes to the model. If you simply want to 3D print it
yourself, please refer to the [Print Guide](printing.md).

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

The tectonic plate boundaries and tectonic plate shapes found in the raw mesh
data of the objects in the "Plate Boundaries" and "Tectonic Plates" collections
of the `tectonic-puzzle.blend` file (excluding all dynamic modifiers) are
imported (largely unmodified) from [Hugo Ahlenius' World tectonic plates and
boundaries repository](https://github.com/fraxen/tectonicplates.git).
- They're made available under the [Open Data Commons Attribution
  license](http://opendatacommons.org/licenses/by/1.0/).
- Attribution: James Hogan, Hugo Ahlenius, Nordpil and Peter Bird.
- Plates have been combined together, and joined when split across the
  international date line.


Blender File Details
====================

The parts are generated procedurally from image textures and tectonic plate
boundaries / shapes by Blender geometry nodes and modifiers. As such the main
Blender file, `tectonics-puzzle.blend` is relatively small compared to the
final high resolution meshes.


Model Configuration
-------------------

The "Configuration" collection contains a "Model Configuration" object, with
the following custom properties which control the generation of the models.

Each property has a description which can be seen by hovering the mouse over
it.

Changing these values may cause Blender to become unresponsive while modifiers
are recalculated, so you may want to disable all but a minimum of collections
in the view layer before making changes.


Collections
-----------

- "Configuration": Contains empty objects used purely for holding custom
  properties which various modifiers, geometry nodes, and properties are driven
  by.
- "Plate Boundaries": Contains objects relating to plate boundaries, which are
  made solid and cut out of the tectonic plate pieces to allow tolerance
  between plates and to cut trenches to show when microplates have been grouped
  into adjacent plates.
  - "Plate Boundaries Straight": Contains the raw plate boundaries.
    - "Minor Boundaries": Contains minor boundaries between plates which have
      been grouped together into single puzzle pieces.
    - "Major Boundaries": Contains major boundaries between tectonic plate
      pieces.
  - "Plate Boundaries Joined": Procedurally joins the above collections into
    single objects (one for minor, one for major plate boundaries).
  - "Plate Boundaries Joined & Modified": Procedurally extrudes and bevels the
    joined plate boundaries, and textures them, ready for boolean operations to
    cut out of the tectonic plate pieces.
- "Magnet Positions": Contains linked magnet slot meshes between the crust and
  mantle, contained within empties for easy orientation, and transformed
  according to the model configuration. Each magnet contains a custom property
  used to offset the magnet to align it to the crust-mantle boundary.
  - "Removed": Old magnets, now unused.
  - "Templates": Original magnet slot meshes, oriented to north, which others
    are linked from, allowing easy editing.
- "Negatives": Various collections of linked objects used by boolean modifiers.
  - "Negative Plate Boundaries": Contains linked plate boundary meshes from the
    "Plate Boundaries" collection.
  - "Negative Mantle Meshes": Contains linked magnet slot meshes between mantle
    segments.
  - "Negative Inner Core Meshes": Contains linked magnet slot meshes between
    the inner core hemispheres.
  - "Empty Temp": Empty collection, used as a temporary plate to put meshes
    when editing them.
  - "Negative Crust Magnets": Contains linked magnet slot meshes between the
    crust and mantle.
- "Core"
  - "Base": Contains global mantle, core, and inner core meshes, including
    slightly larger tolerant meshes used for boolean modifiers to allow for
    tolerance. The subdivision of these meshes depends on the "Mantle" object's
    "detailed" custom property.
  - "Labels": Contains label text objects and associated curves for the mantle,
    outer core, and inner core objects.
  - "Mantle Segments": Contains 8 segments of mantle, sliced from the meshes in
    the "Base" collection, with magnet slots cut out and with labels applied.
    These are exported as `mantle1.obj`..`mantle8.obj`.
  - "Core Segments": Contains a quadrant of outer core, sliced from the meshes
    in the "Base" collection and with labels applied. This is exported as
    `outer_core.obj`.
  - "Inner Core Segments": Contains a quadrant of outer core, sliced from the meshes
    in the "Base" collection, with a magnet slot cut out and with labels
    applied. This is exported as `inner_core.obj`.
- "Tectonic Plates": Contains tectonic plate shapes in longitude/latitude
  space, which are procedurally modified to construct the spherical, 3D,
  topographic plate pieces.
  - "Modifier Templates": Contains empty plates with modifiers which can be
    copied to other plates for different situations, for example by the export
    script.
  - "Unused Plates": Contains plates that are unused, e.g. microplates joined
    with other plates.
  - "Plates for Slicing": Contains major plates, which need slicing in half or
    thirds to minimise filament wastage.
  - "Plate Slices": Contains slice geometry used for slicing the above plates.
    The modifiers must be enabled for the slice to be calculated (which is
    taken care of by the export script). These are exported as
    `plate_$name$slice.obj`.
  - "Unsliced Plates": Contains minor plates which do not need slicing. These
    are exported as `plate_$name.obj`.
  - "Plates by mantle segment": Contains linked plates grouped by mantle
    segment (possibly out of date).
- "Stage": For rendering thumbnails of each exported part.
  - "Cameras": Cameras for each part for rendering thumbnails.


Generating High Resolution Models from Source
=============================================

You will also need a lot of RAM, blender will easily consume close to 32GB to
generate the high resolution tectonic place meshes, so you'll ideally want at
least 32GB or RAM, preferably 64GB or plenty of swap space, and will probably
want to ensure as many programs as possible are closed.

Run Blender from a terminal, so as to see progress of the export/render
scripts, since Blender will become unresponsive while recalculating modifiers.


Generating Core Segments
------------------------

- Open `tectonic-puzzle.blend` in Blender.
- Go to the "Scripting" workspace.
- Enable in the view layer, and make visible, the following collections in the
  "Core" collection:
  - "Base"
  - "Mantle Segments"
  - "Core Segments"
  - "Inner Core Segments"
- If generating placeholder meshes for `3mf/`, set `placeholder = True` in the
  script.
- Otherwise, select "Mantle" in the "Base" collection, and tick the object's
  custom property "detailed" (in the 3D viewport sidebar, or the properties
  panel). Expect Blender to become unresponsive while it recalculates the
  modifiers.
- Select all objects in the "Mantle Segments", "Core Segments", and "Inner Core
  Segments" collections.
- Run the export script. Observe progress in the terminal. The following `.obj`
  files will be created, along with corresponding `.mtl` files:
  - `core_inner.obj`
  - `core_outer.obj`
  - `mantle1.obj` .. `mantle8.obj`
- Undo setting the "Mantle" object's "detailed" custom property to true, or
  untick it again.


Generating Tectonic Plate Pieces
--------------------------------

- Open `tectonic-puzzle.blend` in Blender.
- Go to the "Scripting" workspace.
- Enable in the view layer, and make visible, the following collections in the
  "Tectonic Plates" collection:
  - "Modifier Templates"
  - "Plates for Slicing"
  - "Plate Slices"
  - "Unsliced Plates"
- Select all objects in the "Plate Slices" and "Unsliced Plates" collections.
- If generating placeholder meshes for `3mf/`, set `placeholder = True` in the
  script.
- Run the export script. Expect Blender to become unresponsive for while it
  repeatedly recalculates modifiers for each plate. Observe progress in the
  terminal. `plate_*.obj` files will be created, along with corresponding
  `plate_*.mtl` files.


Rendering OBJ Thumbnails
------------------------

- Open `tectonic-puzzle.blend` in Blender.
- Go to the "Scripting" workspace.
- Enable in the view layer, and make visible, the following collections:
  - "Stage"
  - "Stage/Cameras"
- Ensure all other objects are hidden or disabled in the view layer.
- Select all cameras in the "Cameras" collections.
- Run the render script. Expect Blender to become unresponsive for while it
  repeatedly imports the `.obj` files for each plate. Observe progress in the
  terminal. `.jpg` files will be created.


Importing the OBJ files into Orca Slicer
----------------------------------------

- Build the `tectonic-puzzle.3mf` file with small placeholder meshes using `make`:
```shell
$ make tectonic-puzzle.3mf
```
- Open `tectonic-puzzle.3mf` in Orca Slicer.
- Right click a build plate in the objects hierarchy.
- Select "Reload all". For each mesh object you will be asked to configure the
  mapping between colours and materials.
  - For every file, first use the quick set "Reset" and then "Color match".
  - `core_inner.obj`: set 1 to yellow, 2 to black.
  - `core_outer.obj`: set 1 to orange, 2 to black.
  - `mantle*.obj` (x8): set 1 to red, 2 to white.
  - `plate_*.obj` (x28): hopefully the "Color match" will select the correct
    colours, some combination of blue, green, red and dark grey.
- Some plate pieces may have the wrong colour back. To fix this:
  - Select all plate pieces.
  - Right-click the plates and set filament for the selected items to red.
- The mantle segments have magnet slots against the build plate, which do not
  need support. To fix this:
  - Select each mantle piece in turn.
  - Click the support painting tool.
  - Switch the paint tool to fill.
  - Right click in each of the segment's magnet holes against the base plate to
    disable supports. There are 3 downward facing faces where supports need
    disabling.
  - Exit the support painting tool.


3mf File Details
================

The 3mf files are exported from Orca Slicer. I have not tested them in any
other slicer. You should always verify that the supports do not intersect other
tectonic plate pieces.

Note: please download the final 3mf with high resolution models from a release
rather than using the files straight from the repository, unless you're an
advanced user wanting to make modifications.

The parts are laid out ready for 3D printing in a 3mf file, which is stored in
this repository in the `3mf/` directory, along with very low resolution
placeholder meshes. This can be zipped up into `tectonic-puzzle.3mf` using this
command:
```bash
$ make tectonic-puzzle.3mf
```

Updates can be written back into the `3mf/` directory (also stripping the
absolute paths from source meshes to allow easy reloading) using this command:
```bash
$ make 3mf
```
