# Multiple Crack Propagation in Dovetail Joint Structures

This repository provides the finite-element model archives used for the study of
multiple-crack propagation in dovetail joint structures. The files are published
to support reproducibility and further research.

## Download the model archives

The model files are attached to the
[`v1.0-models` GitHub Release](/YanXinlei011003/multiple-crack-propagation-in-dovetail-joint-structures/releases/tag/v1.0-models).

GitHub limits each Release asset to less than 2 GiB. Archives larger than 1,900
MiB are therefore stored as numbered binary parts. The split is lossless: after
the parts are concatenated in filename order, the result is the original ZIP
file.

| Original archive | Contents | Release form |
| --- | --- | --- |
| `corner_surface_crack.zip` | Corner/surface crack models | Original ZIP |
| `distance.zip` | Crack-distance parametric models | Multipart archive |
| `non_crack.zip` | Non-cracked reference model | Original ZIP |
| `single_corner_crack.zip` | Single corner-crack models | Multipart archive |
| `single_surface_crack.zip` | Single surface-crack models | Multipart archive |
| `size_ratio.zip` | Crack-size-ratio parametric models | Multipart archive |
| `thorough_thickness_crack.zip` | Through-thickness crack models | Original ZIP |

## Reassemble multipart archives

Download every part belonging to an archive into the same directory. Do not
extract the individual parts.

On Windows PowerShell:

```powershell
.\reassemble.ps1 -ArchiveName "size_ratio.zip" -AssetDirectory "C:\path\to\downloads"
```

On Linux or macOS:

```bash
cat size_ratio.zip.part* > size_ratio.zip
```

The same procedure applies to `distance.zip`, `single_corner_crack.zip`, and
`single_surface_crack.zip`.

## Verify file integrity

The Release includes:

- `SHA256SUMS.txt`: SHA-256 checksums for every downloaded Release asset.
- `SOURCE_SHA256SUMS.txt`: SHA-256 checksums for the seven original ZIP files.
- `MODEL_ARCHIVE_MANIFEST.csv`: mapping from every Release asset to its original
  archive, including sizes, part numbers, and checksums.

After reassembly, verify a ZIP on Windows:

```powershell
Get-FileHash -Algorithm SHA256 .\size_ratio.zip
```

On Linux or macOS:

```bash
sha256sum size_ratio.zip
```

Compare the result with the matching line in `SOURCE_SHA256SUMS.txt` before
extracting or using the model.

## Notes

- All archive parts must be downloaded before reassembly.
- The numbered parts are not independent ZIP files.
- The original local archives are not modified by the publishing process.
