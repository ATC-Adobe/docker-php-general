# WSL2 (Windows) Setup Instructions
Tested on Windows 10 and Windows 11.

## WSL2 Initial Setup

### Installing Windows Terminal (optional - installed by default on Windows 11)

1. Open Windows Store and search for `windows terminal`.
2. Install.

### Enabling Windows Subsystem for Linux and installing Ubuntu

1. Open elevated PowerShell (as Admin).
2. Execute `wsl --install`.
3. Reboot system.
4. After reboot Ubuntu installation should start automatically.

### Configuring Memory/Processors amount for WSL2

1. Go to Your Windows home directory. (`C:/Users/<your_username>`)
2. Edit `.wslconfig` file. (Create it if not exist)
3. Under `[wsl2]` You can specify memory and processors available for WLS2.

E.g:\
[wsl2]\
memory=8GB\
processors=4

### First Ubuntu startup

1. Open Ubuntu. (Thru Windows Terminal or as standalone app)
2. Wait for setup to finish.
3. Provide Your new Ubuntu username. (use lowercase letters)
4. Set up Your Ubuntu user password. (remember it as You will need it to perform SUDO operations)

### Install Docker-CE and SSH agent on WSL2

1. Execute `sudo apt-get update`.
2. Execute `sudo apt-get install ca-certificates curl gnupg lsb-release`.
3. Execute `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`.
4. Execute `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`.
5. Execute `sudo apt-get update`.
6. Execute `sudo apt-get install docker-ce docker-ce-cli containerd.io`.
7. Execute `sudo apt-get install ssh`.
8. Execute `sudo usermod -aG docker $USER`.
9. Execute `sudo ssh-keygen -A`.
10. Edit ~/.bashrc file to run docker and ssh services on WSL2 startup.
    1. Execute `nano ~/.bashrc`.
    2. Add following lines on bottom.
       1. `wsl.exe -u root service docker status > /dev/null || wsl.exe -u root service docker start > /dev/null`
       2. `wsl.exe -u root service ssh status > /dev/null || wsl.exe -u root service ssh start > /dev/null`
    3. `Ctrl + o` to save.
    4. `Ctrl + x` to exit.

### Restart WSL2

1. Close Ubuntu.
2. In Powershell CLI execute `wsl --shutdown`.
3. Open Ubuntu.

### WSL2 Ubuntu Host Sync

1. Copy `ubuntuWslHostSync.ps1` from repository `wslTools/ubuntuWslHostSync` folder to `C:\Scripts\ `.
2. Copy `ubuntuWslHostSync.cmd` from repository `wslTools/ubuntuWslHostSync` folder to desktop.

Now You can run `ubuntuWslHostSync.cmd` as Administrator to sync Ubuntu IP to Windows host file.\
Your host will be `localwsl.com`.\
**WSL2 IP changes with each restart of PC/WSL!**

## Using this docker setup

### Cloning repository

1. Create dir in your linux home directory. (You may choose the name, but I will use `docker`)
   1. Go to Your home directory (if You are not there already) by command `cd ~`.
   2. Create dir by command `mkdir docker`.
2. Go inside this folder by command `cd docker`.
3. Execute `git clone https://<github_username>:<github_token>@github.com/ATC-Adobe/docker-magento2-general.git .`.

### Creating volumes for persistent data

1. Change dir `/var/www` ownage to your user by command `sudo chown <your_linux_username>:<your_linux_username> /var/www`.
   1. If this dir do not exist You must create it first by command `sudo mkdir /var/www`.
2. Create dir `/var/www/php_php`. (this is where Your Magento instance will be living).
   1. Execute `mkdir /var/www/php_php`.
3. Create dir `/var/lib/php_mysql`. (this is where SQL data persists).
   1. Execute `sudo mkdir /var/lib/php_mysql`.

### Building images and running them

1. Go to dir with docker repository. (`cd ~/docker`)
2. Run `sudo wslTools/dnsSync`.
3. Run `docker/buildImages`.
4. Run `docker swarm init`.
5. Run `docker/run`. (If this command do not work. Run `docker/runAlt`)

## Troubleshooting

### Cannot reach localwsl.com from Windows browser or docker service is not starting

1. If your Ubuntu is using nftables instead of iptables (ex. 22.04) run following commands on it:
   1. `sudo update-alternatives --set iptables /usr/sbin/iptables-legacy`
   2. `sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy`
2. In Powershell as administrator run commands:
   1. `netsh winsock reset`
   2. `netsh int ip reset all`
   3. `netsh winhttp reset proxy`
   4. `ipconfig /flushdns`
   5. `netsh winsock reset`
3. Restart PC.

### Logon failure: the user has not been granted the requested logon type at this computer.

1. Restart vmcompute service.
   1. Open elevated PowerShell (as Admin)
   2. Execute `Get-Service vmcompute | Restart-Service`.

### DNS resolution problems / no internet access.

Run script `wslTools/dnsSync` that will sync DNS between Windows host and WSL2 instance.\
**Remember to run it with root privileges.**