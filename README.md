# VSCodePSX
A basic setup to get coding for PSX on Win 10 64bit with VS Code  
Use modern day GCC with the unofficial official based SDK  
Guide by NDR008, many many contributors to this!

## Step 0: Get work folder ready:  
- Clone this repo somewhere (if you want to skip git stuff for now.. just download the zip from the github).
- Unzip: Unzip http://psx.arthus.net/sdk/Psy-Q/psyq-4.7-converted-full.7z into the third_party folder  


## Step 1: Install WSL and base extension:
a) https://code.visualstudio.com/  
b) https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl  

## Step 2: Get WSL and Ubuntu Ready  
a) Winkey + R and type:    powershell start-process PowerShell -verb runas  
b) In Powershell Type:    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart  
c) Restart just in case  
d) Install: https://www.microsoft.com/en-us/p/ubuntu-2004-lts/9n6svws3rx71?SilentAuth=1&wa=wsignin1.0&activetab=pivot:overviewtab  
e) Winkey + R and type:    wsl  
f) Follow the instructions to setup a username and passowrd  
g) When Ubuntu is ready type:  
  ```
  sudo apt-get update
  sudo apt-get install -y g++-mipsel-linux-gnu  
  sudo apt-get install -y make
```   
h) When above installations are done type "code ."  
(wait for some stuff to happen)  
  
VSCode should have launched connected to WSL  
  
## Step 3: Start Coding  
a) In VSCode: File, Open folder, and choose the "get_started" folder  
  
## Step 4: Compile  
a) From the menu, Terminal, New Terminal (unless a Terminal is already open)  
b) Type "make"  
c) If all went well an exe should appear that you can load into an emulator.  

## Optional step :
If you want to also debug with step functions and pcsx-redux than also:  
in WSL:   
```sudo apt-get install -y gdb-multiarch  ```  
and install this extension in VSCode (install in WLS too):  
https://marketplace.visualstudio.com/items?itemName=webfreak.debug  
