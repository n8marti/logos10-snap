
### Extracting DLLs from an EXE installer
```
Executing cabextract -q -d /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp -L -F x86_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_9e6699276b03c38e/mf.dll /home/nate/snap/logos10-unofficial/common/.cache/winetricks/win7sp1/windows6.1-KB976932-X86.exe
Executing cp -f /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp/x86_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_9e6699276b03c38e/mf.dll /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/syswow64/mf.dll
Executing cabextract -q -d /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp -L -F amd64_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_fa8534ab236134c4/mf.dll /home/nate/snap/logos10-unofficial/common/.cache/winetricks/win7sp1/windows6.1-KB976932-X64.exe
Executing cp -f /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp/amd64_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_fa8534ab236134c4/mf.dll /home/nate/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/system32/mf.dll
Using native,builtin override for following DLLs: mf
Executing wine C:\windows\syswow64\regedit.exe C:\windows\Temp\override-dll.reg
Executing wine64 C:\windows\regedit.exe C:\windows\Temp\override-dll.reg
```

### msvproc.dll

Windows_MediaFeaturePack_x64_1903_V1 (msvproc.dll copied straight into Logos/System/ folder):
- amd64: `[0530/214316.465:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Module introuvable. (0x7E)`
- wow64: `[0530/214935.248:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Mauvais format EXE pour %1. (0xC1)`

Windows_MediaFeaturePack_x64_1809Oct:
- amd64: `[0531/080509.808:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Module introuvable. (0x7E)`

Windows_MediaFeaturePack_x64_1803:
- amd64: `[0531/100731.586:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Module introuvable. (0x7E)`

Executable is 64-bit:
```bash
$ file -b snap/logos10-unofficial/common/.wine/drive_c/users/nate/AppData/Local/Logos/System/Logos.exe 
PE32+ executable (GUI) x86-64, for MS Windows
```
So, presumably it needs a 64-bit DLL. Here is amd64/msvproc.dll's file output, which confirms matching file type to Logos.exe:
```bash
$ file -b win-mediafeaturepack/Windows_MediaFeaturePack_x64_1809Oct/microsoft-windows-mediafeaturepack-oob-package~31bf3856ad364e35/amd64_microsoft-windows-vidproc_31bf3856ad364e35_10.0.17763.1_none_ba2eb71bcebf27bd/msvproc.dll 
PE32+ executable (DLL) (console) x86-64, for MS Windows
```
