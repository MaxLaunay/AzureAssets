Add-Type -Assembly System.IO.Compression.FileSystem
$sourceDir = $PSScriptRoot + "\..\PHP_Site"
$destFile = $PSScriptRoot + "\..\phpsite.zip"
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   write-host $destFile
   if(test-path $destFile){
    remove-item $destFile -Force
   }
  [System.IO.Compression.ZipFile]::CreateFromDirectory($sourceDir,
        $destFile, $compressionLevel, $false)