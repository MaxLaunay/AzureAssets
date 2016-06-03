Add-Type -Assembly System.IO.Compression.FileSystem
$sourcedir = (get-location).Path
$destFile = $sourcedir + "\..\phpsite.zip"
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   write-host $destFile
  [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $destFile, $compressionLevel, $false)