---
title: "Dev: 우분투 - 저장장치 자동마운트하기(fstab)"
categories:
  - Development
tags:
  - Dev_setting
---

저장장치를 설치하고 포맷하기만 하면 자동으로 사용가능한 상태가 되는 윈도우와는 달리, 우분투에서는 직접 어느 위치에서 사용할 것인지 마운트를 시켜줘야 한다.

최근 우분투 버전에서는 /media로의 자동마운트를 지원하긴 하나, 귀찮은 건 마찬가지다.  
매 부팅때마다 마운트하는 귀찮음을 해결하기 위해 fstab파일을 수정하여 자동마운트를 시켜보자

<!--more-->

우분투에 저장장치를 자동마운트 시키는 방법은 여러가지가 있다.
그 중 널리 쓰이는 것이 autofs와 fstab인데, autofs의 경우에는 편리하긴 하지만 별도의 패키지 설치가 필요한데다가 지금 마운트시키고자 하는 저장장치의 경우에는 본체 내에 설치된 드라이브이므로 간단하게 fstab을 통해 마운트 시키려고 한다.  
(autofs의 경우에는 해당 경로 최초 접근 시 자동마운트를 지원하며, 이 때문에 NFS(Network File System)의 마운트용도로 널리 사용된다)


우선 fstab 파일을 열어보자.

```bash
$ sudo vi /etc/fstab
```

{% highlight bash linenos %}
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda5 during installation
UUID=31dfbb32-39e1-425b-a96d-179b8c83ae56 /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/sda2 during installation
UUID=AA0E-3159  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0
{% endhighlight %}

<br>
앞으로 해야할 일에 대해 매우 친절하게 설명해주고 있다.  
blkid를 통해 드라이브 장치의 UUID(Universally Unique IDentifier)를 확인해보자

```bash
$ sudo blkid

/dev/loop0: TYPE="squashfs"
/dev/loop1: TYPE="squashfs"
/dev/loop2: TYPE="squashfs"
/dev/loop3: TYPE="squashfs"
/dev/loop4: TYPE="squashfs"
/dev/loop5: TYPE="squashfs"
/dev/loop6: TYPE="squashfs"
/dev/loop7: TYPE="squashfs"
/dev/sda1: LABEL="M-kM-3M-5M-jM-5M-," UUID="8CD00D9DD00D8F20" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="bb7af43a-085a-4abc-b1b2-7bffd5580832"
/dev/sda2: UUID="AA0E-3159" TYPE="vfat" PARTLABEL="EFI system partition" PARTUUID="95be13ef-12ec-43a8-91ce-1bf3f9a8fb1c"
/dev/sda3: PARTLABEL="Microsoft reserved partition" PARTUUID="6dc54e45-b381-42ab-85ad-62070f4fbadd"
/dev/sda4: UUID="2E741AF9741AC40D" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="fa0f9f6e-a188-4c73-9948-e64c58d9ca9c"
/dev/sda5: UUID="8250CD7050CD6B8B" TYPE="ntfs" PARTUUID="2129c674-f922-4a22-b3dd-8b860adf3ab8"
/dev/sda6: UUID="31dfbb32-39e1-425b-a96d-179b8c83ae56" TYPE="ext4" PARTUUID="8049b811-d616-44b0-bcb5-f5a79a8d7182"
/dev/sdb: TYPE="isw_raid_member"
/dev/sdc: TYPE="isw_raid_member"
/dev/md126: PTUUID="7d2e33a9-96a8-4238-8366-e0c4ff8157ed" PTTYPE="gpt"
/dev/sdd: TYPE="isw_raid_member"
/dev/md126p1: LABEL="dbstore" UUID="5DD1E56565A8C646" TYPE="ntfs" PTTYPE="dos" PARTUUID="c015ee53-7e8f-4efb-84e2-608971c5b478"
/dev/loop8: TYPE="squashfs"
/dev/loop9: TYPE="squashfs"
/dev/loop10: TYPE="squashfs"
/dev/loop11: TYPE="squashfs"
/dev/loop12: TYPE="squashfs"
/dev/loop13: TYPE="squashfs"
/dev/loop14: TYPE="squashfs"
/dev/loop15: TYPE="squashfs"
/dev/loop16: TYPE="squashfs"
/dev/loop17: TYPE="squashfs"
/dev/loop18: TYPE="squashfs"
/dev/loop19: TYPE="squashfs"
```

SNAP을 통해 설치한 것들 때문에 loop 디바이스가 엄청나게 나온다.

UUID를 통해 마운트해야 디스크변경(물리적인 디스크 제거, 변경, 재설치, 추가 등)이 있었을 때에도 안정적으로 마운트되지만, RAID시킨 드라이브를 변경할 일은 없으므로 그냥 장치명으로 마운트 하기로 한다.

<br>
/etc/fstab에 다음 두 줄을 추가해준다.  
(두 드라이브 전부 NTFS 파일시스템을 사용하므로 ntfs-3g로 마운트 해 준다)

{% highlight bash linenos %}
/dev/sda4    /windows ntfs-3g defaults 0 1 
/dev/md126p1 /dbstore ntfs-3g defaults 0 1
{% endhighlight %}


{% highlight bash linenos %}
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda5 during installation
UUID=31dfbb32-39e1-425b-a96d-179b8c83ae56 /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/sda2 during installation
UUID=AA0E-3159  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0

/dev/sda4    /windows ntfs-3g defaults 0 1 
/dev/md126p1 /dbstore ntfs-3g defaults 0 1
{% endhighlight %}

재부팅 후 성공적으로 마운트된 볼륨을 사용하면 된다.