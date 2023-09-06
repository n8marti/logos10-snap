#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"

# Copy DLLs.
cp -vf --remove-destination "${script_dir}/syswow64/"* "$WINEPREFIX/drive_c/windows/syswow64"
cp -vf --remove-destination "${script_dir}/system32/"* "$WINEPREFIX/drive_c/windows/system32"

# Enable components.
base_path="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Media Foundation\HardwareMFT"
"$WINELOADER" reg add "$base_path" /v "EnableDecoders" /t REG_DWORD /d "00000000" /f
"$WINELOADER" reg add "$base_path" /v "EnableEncoders" /t REG_DWORD /d "00000001" /f
"$WINELOADER" reg add "$base_path" /v "EnableVideoProcessors" /t REG_DWORD /d "00000001" /f

# msmpeg2vdec.dll
dll_name="msmpeg2vdec"
vdecs=(
    "${dll_name}-H264VideoDecoderV2AddInEnable"
    "${dll_name}-H264VideoDecoderV2InSKU"
    "${dll_name}-MPEG2VideoDecoderV2AddInEnable"
    "${dll_name}-MPEG2VideoDecoderV2InSKU"        
)
for v in "${vdecs[@]}"; do
    "$WINELOADER" reg add "HKEY_LOCAL_MACHINE\Software\Wine\LicenseInformation" \
        /v "$v" /t REG_DWORD /d "00000001" /f
done

# msvproc.dll
base_path="HKEY_CLASSES_ROOT\CLSID\{7B82D688-3B9E-4090-8ECD-FC84E454C923}"
dll_name="msvproc"
# Add registry entries.
"$WINELOADER" reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v "$dll_name" /d native /f
"$WINELOADER" reg add "$base_path" /f
"${WINELOADER}64" reg add "$base_path" /f
"$WINELOADER" reg add "${base_path}\InProcServer32" \
    /t REG_EXPAND_SZ /ve /d "%SystemRoot%\\system32\\${dll_name}.dll" /f
"${WINELOADER}64" reg add "${base_path}\InProcServer32" \
    /t REG_EXPAND_SZ /ve /d "%SystemRoot%\\system32\\${dll_name}.dll" /f
"$WINELOADER" reg add "${base_path}\InProcServer32" \
    /v "ThreadingModel" /d "Both" /f
"${WINELOADER}64" reg add "${base_path}\InProcServer32" \
    /v "ThreadingModel" /d "Both" /f


# Edit Register Server entries.
#   Removed from objs: "msvproc"
objs=(
    "msmpeg2vdec"
)
for obj in "${objs[@]}"; do
    # "$WINELOADER" regsvr32 "${obj}.dll" # Unimplemented function error with msvproc & msmpeg2vdec
    "${WINELOADER}64" regsvr32 "${obj}.dll"
done
