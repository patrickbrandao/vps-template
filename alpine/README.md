
# Preparar Alpine para transformacao em template clonagem de maquina virtual

## Preparativos no VMWare ESXi

Adicionar no arquivo .vmx da vm (desregistrar, editar, registrar novamente):
```

guest_rpc.rpci.auth.cmd.info-get = "TRUE"
guest_rpc.rpci.auth.cmd.info-set = "FALSE"
guest_rpc.rpci.auth.cmd.info-list = "TRUE"
isolation.tools.guestOperations.enable = "TRUE"

```

## Instalar Alpine 3 (recomendavel)

Login padrao:
    suporte / Tulipa@2026
    root    / Tulipa@2026


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

## Rodar scripts do projeto alpine-vm-template


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
virtualHW.version = "20"
vmci0.present = "TRUE"
floppy0.present = "FALSE"
numvcpus = "8"
memSize = "16384"
bios.bootRetry.delay = "10"
powerType.suspend = "soft"
tools.upgrade.policy = "manual"
sched.cpu.units = "mhz"
sched.cpu.affinity = "all"
vm.createDate = "1770315127917670"
sata0.present = "TRUE"
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
uuid.bios = "56 4d f0 93 9b e4 bf 0a-fa a6 91 62 e3 70 VPSHEXID2"
uuid.location = "56 4d f0 93 9b e4 bf 0a-fa a6 91 62 e3 70 VPSHEXID2"
vc.uuid = "52 66 18 78 d5 8a 13 3f-2b de a1 5c 1b b0 VPSHEXID2"
sched.cpu.min = "0"
sched.cpu.shares = "normal"
sched.mem.min = "0"
sched.mem.minSize = "0"
sched.mem.shares = "normal"
precisionclock0.present = "TRUE"
ethernet0.generatedAddress = "00:0c:29:70:1c:00"
vmci0.id = "-479192064"
cleanShutdown = "TRUE"
nvme0.present = "TRUE"
sata0:1.fileName = "VPSNAME.vmdk"
sched.sata0:1.shares = "normal"
sched.sata0:1.throughputCap = "off"
sata0:1.present = "TRUE"
ethernet0.address = "VPSMAC"
cpuid.coresPerSocket = "4"
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
vmxstats.filename = "VPSNAME.scoreboard"
numa.autosize.cookie = "80042"
numa.autosize.vcpu.maxPerVirtualNode = "8"
sched.swap.derivedName = "/vmfs/volumes/6981307b-e4c8b963-c501-f8bc1221ff40/VPSNAME/VPSNAME-1565a082.vswp"
pciBridge0.pciSlotNumber = "17"
pciBridge4.pciSlotNumber = "21"
pciBridge5.pciSlotNumber = "22"
pciBridge6.pciSlotNumber = "23"
pciBridge7.pciSlotNumber = "24"
scsi0.pciSlotNumber = "-1"
ethernet0.pciSlotNumber = "192"
sata0.pciSlotNumber = "32"
scsi0.sasWWID = "50 05 05 63 9b e4 bf 00"
vmotion.checkpointFBSize = "4194304"
vmotion.checkpointSVGAPrimarySize = "16777216"
vmotion.svga.mobMaxSize = "16777216"
vmotion.svga.graphicsMemoryKB = "16384"
ethernet0.generatedAddressOffset = "0"
monitor.phys_bits_used = "45"
softPowerOff = "TRUE"
svga.guestBackedPrimaryAware = "TRUE"
isolation.tools.guestOperations.enable = "TRUE"
tools.remindInstall = "TRUE"
nvme0.pciSlotNumber = "224"
nvme0.subnqnUUID = "52 a9 ae 76 5e b9 af 11-7c f2 12 0c 03 d1 IDHEX2"
migrate.hostLog = "./VPSNAME-1565a082.hlog"
guest_rpc.rpci.auth.cmd.info-get = "TRUE"
guest_rpc.rpci.auth.cmd.info-set = "FALSE"
guest_rpc.rpci.auth.cmd.info-list = "TRUE"
guestinfo.fqdn = "VPSFQDN"
guestinfo.ipv4 = "VPSIPV4"
guestinfo.cfgv = "VPSCFGV"

```

