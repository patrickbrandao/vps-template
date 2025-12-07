
# Preparar Debian para transformacao em template clonagem de maquina virtual

## Preparativos no VMWare ESXi

Adicionar no arquivo .vmx da vm (desregistrar, editar, registrar novamente):
```

guest_rpc.rpci.auth.cmd.info-get = "TRUE"
guest_rpc.rpci.auth.cmd.info-set = "FALSE"
guest_rpc.rpci.auth.cmd.info-list = "TRUE"
isolation.tools.guestOperations.enable = "TRUE"

```

## Instalar debian 12 ou 13 (recomendavel)

## Transferir scripts

```
	mkdir -p /usr/share/cloud/setups;

	# baixar scripts setup-***-xxxx

	# Rodar:
	cd /usr/share/cloud/setups;
	for script in setup*; do
		bash "$script";
	done;


	cd /usr/share/cloud/setups; rm -f rm /etc/.vps-setup; for script in setup*; do bash "$script"; done;


```

## Rodar scripts do projeto debian-vm-template


## Finalizar

desligue a VM e clone-a, preencha os atributos no arquivo VMX:
```
guestinfo.cfgv = "202512041916"
guestinfo.fqdn = "aluno120.starter.ispai.com.br"
guestinfo.ipv4 = "45.171.63.120"
```

## Para consultar variaveis VMX dentro do Linux:

```bash

vmtoolsd --cmd "info-get guestinfo.cfgv"

```

## Template de arquivo VMX

```
.encoding = "UTF-8"
config.version = "8"
virtualHW.version = "21"
vmci0.present = "TRUE"
floppy0.present = "FALSE"
numvcpus = "8"
memSize = "16384"
bios.bootRetry.delay = "10"
powerType.suspend = "soft"
tools.upgrade.policy = "manual"
sched.cpu.units = "mhz"
sched.cpu.affinity = "all"
vm.createDate = "1764869612198677"
sata0.present = "TRUE"
nvme0.present = "TRUE"
nvme0:0.fileName = "VPSNAME.vmdk"
sched.nvme0:0.shares = "normal"
sched.nvme0:0.throughputCap = "off"
nvme0:0.present = "TRUE"
ethernet0.virtualDev = "vmxnet3"
ethernet0.networkName = "vSwitchY-VLAN-1001"
ethernet0.addressType = "static"
ethernet0.wakeOnPcktRcv = "FALSE"
ethernet0.uptCompatibility = "TRUE"
ethernet0.present = "TRUE"
displayName = "VPSNAME"
guestOS = "debian12-64"
toolScripts.afterPowerOn = "TRUE"
toolScripts.afterResume = "TRUE"
toolScripts.beforeSuspend = "TRUE"
toolScripts.beforePowerOff = "TRUE"
tools.syncTime = "FALSE"
uuid.bios = "56 4d da 83 7f a7 e0 92-57 65 40 0d 86 7f VPSHEXID2"
uuid.location = "56 4d da 83 7f a7 e0 92-57 65 40 0d 86 7f VPSHEXID2"
vc.uuid = "52 da fc b6 e7 e8 6c 41-4f 80 01 20 33 52 VPSHEXID2"
sched.cpu.min = "0"
sched.cpu.shares = "normal"
sched.mem.min = "0"
sched.mem.minSize = "0"
sched.mem.shares = "normal"
firmware = "efi"
ethernet0.address = "VPSMAC"
vmci0.id = "-1529558856"
cleanShutdown = "TRUE"

tools.guest.desktop.autolock = "TRUE"
nvram = "VPSNAME.nvram"
svga.present = "TRUE"
pciBridge0.present = "TRUE"
pciBridge4.present = "TRUE"
pciBridge4.virtualDev = "pcieRootPort"
pciBridge4.functions = "8"
pciBridge5.present = "TRUE"
pciBridge5.virtualDev = "pcieRootPort"
pciBridge5.functions = "8"
pciBridge6.present = "TRUE"
pciBridge6.virtualDev = "pcieRootPort"
pciBridge6.functions = "8"
pciBridge7.present = "TRUE"
pciBridge7.virtualDev = "pcieRootPort"
pciBridge7.functions = "8"
hpet0.present = "TRUE"
RemoteDisplay.maxConnections = "-1"
sched.cpu.latencySensitivity = "normal"
svga.autodetect = "TRUE"
cpuid.coresPerSocket = "4"
vmxstats.filename = "VPSNAME.scoreboard"
numa.autosize.cookie = "80042"
numa.autosize.vcpu.maxPerVirtualNode = "8"
sched.swap.derivedName = "/vmfs/volumes/687a71ab-50abf3c4-b436-3cfdfe2d31a0/VPSNAME/VPSNAME-4bc10VPSID3.vswp"
Debian13-Template-1625969d.vswp"
pciBridge0.pciSlotNumber = "17"
pciBridge4.pciSlotNumber = "21"
pciBridge5.pciSlotNumber = "22"
pciBridge6.pciSlotNumber = "23"
pciBridge7.pciSlotNumber = "24"
ethernet0.pciSlotNumber = "160"
sata0.pciSlotNumber = "32"
nvme0.pciSlotNumber = "192"
vmotion.checkpointFBSize = "4194304"
vmotion.checkpointSVGAPrimarySize = "16777216"
vmotion.svga.mobMaxSize = "16777216"
vmotion.svga.graphicsMemoryKB = "16384"
nvme0.subnqnUUID = "52 2a c2 2f 68 64 25 a5-b1 8a 84 b8 fa 8d 2c b3"
monitor.phys_bits_used = "45"
softPowerOff = "TRUE"
svga.guestBackedPrimaryAware = "TRUE"
tools.capability.verifiedSamlToken = "TRUE"
guestInfo.detailed.data = "architecture='X86' bitness='64' distroAddlVersion='13 (trixie)' distroName='Debian GNU/Linux' distroVersion='13' familyName='Linux' kernelVersion='6.12.57+deb13-amd64' prettyName='Debian GNU/Linux 13 (trixie)'"
guest_rpc.rpci.auth.cmd.info-get = "TRUE"
guest_rpc.rpci.auth.cmd.info-set = "FALSE"
guest_rpc.rpci.auth.cmd.info-list = "TRUE"
isolation.tools.guestOperations.enable = "TRUE"
migrate.hostLog = "./VPSNAME-4bc10VPSID3.hlog"
guestinfo.fqdn = "VPSFQDN"
guestinfo.ipv4 = "VPSIPV4"
guestinfo.cfgv = "VPSCFGV"
nvme0:0.redo = ""
svga.vramSize = "16777216"

```

