
# Co-Authorship Network (VOSviewer)

This folder contains files used to generate a co-authorship network for the neonatal EEG pain scoping review using *VOSviewer*.

Installing Java is needed to run VOSviewer. If after installing Java, you still get an error message whenever you try to run VOSviewer, saying that Java environment could not be opened, do the following: 
(1) copy VOSviewer app manually from Downloads/VOSviewer/ to Applications/, and 
(2) type this in bash:
cd /Applications/VOSviewer.app/Contents/Java
java -jar VOSviewer.jar

## Folder contents

- `included_studies.ris`: Exported from EPPI-Reviewer (included references)
- `map_file1-3.csv`: VOSviewer map file (author positions and cluster assignments)
- `network_file1-3.csv`: VOSviewer network file (co-authorship links)

## How to use this folder


### Option 1: create the co-authorship network for the first time

If you are generating the co-authorship network for the first time, you would need to generate it from the .ris file provided. You can then save the map and network file, so the next time you would like to generate it again, you can generate it using the map and network files (see option 2). The map and network file are provided in this folder, but below are the steps to generate and save them from the .ris file:

1. Open *VOSviewer*
2. Select `Create` → `Create a map based on bibliographic data`
3. Choose `Read data from reference manager files` and select `included_studies_search1-3.ris`
4. On the analysis setup:
   - Type of analysis: `Co-authorship`
   - Counting method: `Full counting`
   - Deselect: `Ignore documents with a large number of authors`
5. Set “Minimum number of documents of an author” to `1`
6. Leave default on number of authors
7. When prompted about unconnected items, click `No`
8. Switch to the **Analysis** tab:
   - Set `Clustering Resolution` to `0.5` → click `Update Clustering`
   - Set `Normalization Method` to `No normalization` → click `Update Layout`
9. Go to `File` → `Save` → select the location to save the map and network files, and type in the name and choose 'Comma-separated values files (*.csv)' as the extension type. These are the names I used:
   - VOSviewer map file: `map_file1-3`
   - VOSviewer network file: `network_file1-3.csv`

### Option 2: create the co-authorship network from previously saved map and network files

- Open *VOSviewer* → `File` → `Open`
- Choose 'Files of Type:' 'Comma-separated values files (*.csv)'
- Load `map_file1-3` for 'VOSviewer map file' and `network_file1-3` for 'VOSviewer network file'

## Creating the simplified figure for publication

To prepare the final figure used in the paper:

1. On the right panel:
   - Visualization → Set `Scale` to `2` (maximum), `Weights` to `Documents`
   - Labels → Set `Size variation` to `0` (furthest left), `Max. length` to `0` (removes names)
   - Lines → `Size variation` to `0` (furthest left), `Max. lines` to `10000`

2. On the left panel:
   - Go to `File` → `Screenshot` → Save the image (e.g. as PNG or PDF)

## Output files and usage

- The `.ris` file is the raw input from EPPI-Reviewer
- The `.csv` files define the network layout and links
- The simplified image is not included here, but is used in the publication
- Full author names and clusters are listed in the supplementary material

## Summary

This folder enables reconstruction and exploration of the co-authorship network using *VOSviewer*, with clear steps to reproduce or adapt the network visualisation.
