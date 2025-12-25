# Prepare Filesystem
## Wipe Filesystem
```bash 
sudo wipefs -a /dev/vda
sudo sgdisk -Z /dev/vda
```

## Create Partitions
```bash 
sudo parted /dev/vda -- mklabel gpt
```

### EFI Partition (512 MiB)
```bash 
sudo parted /dev/vda -- mkpart primary fat32 1MiB 513MiB
sudo parted /dev/vda -- set 1 esp on
```

### Root Partition (Rest)
```bash 
sudo parted /dev/vda -- mkpart primary ext4 513MiB 100%
```

# Create Filesystem
```bash
mkfs.fat -F 32 /dev/vda1
mkfs.ext4 /dev/sda2
```

# Run Setup
```bash
git clone https://github.com/krizi/home-nixos.git /mnt/etc/nixos
```


# Fetch KUBECONFIG
```bash
scp kubernetes@k8s-master-01:/etc/rancher/k3s/k3s.yaml $HOME/.kube/config
```