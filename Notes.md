
## Extracting DLLs from an EXE installer
```
Executing cabextract -q -d ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp -L -F x86_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_9e6699276b03c38e/mf.dll ~/snap/logos10-unofficial/common/.cache/winetricks/win7sp1/windows6.1-KB976932-X86.exe
Executing cp -f ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp/x86_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_9e6699276b03c38e/mf.dll ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/syswow64/mf.dll
Executing cabextract -q -d ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp -L -F amd64_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_fa8534ab236134c4/mf.dll ~/snap/logos10-unofficial/common/.cache/winetricks/win7sp1/windows6.1-KB976932-X64.exe
Executing cp -f ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/temp/amd64_microsoft-windows-mediafoundation_31bf3856ad364e35_6.1.7601.17514_none_fa8534ab236134c4/mf.dll ~/snap/logos10-unofficial/common/.wine/dosdevices/c:/windows/system32/mf.dll
Using native,builtin override for following DLLs: mf
Executing wine C:\windows\syswow64\regedit.exe C:\windows\Temp\override-dll.reg
Executing wine64 C:\windows\regedit.exe C:\windows\Temp\override-dll.reg
```

## Media playback

Logos needs Media Foundation files for media playback:
- msmpeg2vdec.dll
- msvproc.dll

e.g.:
```
[0905/161614.126:ERROR:dxva_video_decode_accelerator_win.cc(1458)] DXVAVDA fatal error: could not LoadLibrary: msmpeg2vdec.dll: Module introuvable. (0
x7E)
[0905/161614.129:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Module introuvable. (0x7E)
```
### Download options

- KB2703761 (Windows 8)
  - https://download.microsoft.com/download/7/A/D/7AD12930-3AA6-4040-81CF-350BF1E99076/Windows6.2-KB2703761-x86.msu
  - 64-bit: ???
- Windows Media Feature Pack Win10-1903
  - https://software.download.prss.microsoft.com/dbazure/Windows_MediaFeaturePack_x64_1903_V1.msu?t=6240e73b-4d2f-41d7-86ac-a4c960a767dd&e=1694013976&h=c567e97dce400d9a3b4210dd289692e3dd181532eb63777bad6f7dbed3ab7f3b
  - https://software.download.prss.microsoft.com/dbazure/Windows_MediaFeaturePack_x32_1903_V1.msu?t=6240e73b-4d2f-41d7-86ac-a4c960a767dd&e=1694013976&h=5349a356467975cddd65310f0283629c2b72f9d5c90719edc5cb3e850b78b2f5

### Using Windows Media Feature Pack Win10-1903

Copy `msvproc.dll` to 32-bit and 64-bit locations in WINE prefix:
```bash
$ cd ~/.local/share/logos
$ cp ~/Téléchargements/Windows_MediaFeaturePack_x64_1903_V1/package/amd64_microsoft-windows-vidproc_31bf3856ad364e35_10.0.18362.1_none_9bc63d31f3ce2aa1/msvproc.dll .wine/drive_c/windows/system32/
$ cp ~/Téléchargements/Windows_MediaFeaturePack_x32_1903_V1/package/x86_microsoft-windows-vidproc_31bf3856ad364e35_10.0.18362.1_none_3fa7a1ae3b70b96b/msvproc.dll .wine/drive_c/windows/syswow64/
$ find -name msvproc.dll -exec file {} \; # check file format; PE32 is 32-bit, PE32+ is 64-bit
./.wine/drive_c/windows/syswow64/msvproc.dll: PE32 executable (DLL) (console) Intel 80386, for MS Windows
./.wine/drive_c/windows/system32/msvproc.dll: PE32+ executable (DLL) (console) x86-64, for MS Windows
```

Still produces "Module not found" error:
```
[0906/070811.886:ERROR:dxva_video_decode_accelerator_win.cc(1458)] DXVAVDA fatal error: could not LoadLibrary: msmpeg2vdec.dll: Module introuvable. (0
x7E)
[0906/070811.914:ERROR:dxva_video_decode_accelerator_win.cc(1466)] DXVAVDA fatal error: could not LoadLibrary: msvproc.dll: Module introuvable. (0x7E)
```

Executable is 64-bit:
```bash
$ file -b snap/logos10-unofficial/common/.wine/drive_c/users/me/AppData/Local/Logos/System/Logos.exe 
PE32+ executable (GUI) x86-64, for MS Windows
```

Register DLL and attempt to register the service (necessary?):
```bash
$ data/install-mf-files.sh 
'~/g/logos10-snap/data/syswow64/CompPkgSup.dll' -> '~/.local/share/logos/.wine/drive_c/windows/syswow64/CompPkgSup.dll'
'~/g/logos10-snap/data/syswow64/mfperfhelper.dll' -> '~/.local/share/logos/.wine/drive_c/windows/syswow64/mfperfhelper.dll'
'~/g/logos10-snap/data/syswow64/msmpeg2vdec.dll' -> '~/.local/share/logos/.wine/drive_c/windows/syswow64/msmpeg2vdec.dll'
'~/g/logos10-snap/data/syswow64/msvproc.dll' -> '~/.local/share/logos/.wine/drive_c/windows/syswow64/msvproc.dll'
'~/g/logos10-snap/data/system32/CompPkgSup.dll' -> '~/.local/share/logos/.wine/drive_c/windows/system32/CompPkgSup.dll'
'~/g/logos10-snap/data/system32/mfperfhelper.dll' -> '~/.local/share/logos/.wine/drive_c/windows/system32/mfperfhelper.dll'
'~/g/logos10-snap/data/system32/msmpeg2vdec.dll' -> '~/.local/share/logos/.wine/drive_c/windows/system32/msmpeg2vdec.dll'
'~/g/logos10-snap/data/system32/msvproc.dll' -> '~/.local/share/logos/.wine/drive_c/windows/system32/msvproc.dll'
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
reg : L'opération s'est terminée avec succès
regsvr32 : Impossible de charger la DLL « msvproc.dll »
regsvr32 : DLL « msmpeg2vdec.dll » enregistrée avec succès
```

So msvproc.dll still fails to register and is still not found at runtime. Why?
