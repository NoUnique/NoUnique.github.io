---
title: "Dev: 멀티부팅 환경에서 NTFS 드라이브 쓰기불가 문제해결"
categories:
  - Development
tags:
  - Dev_setting
---

멀티부팅 환경에서 우분투에 NTFS 드라이브 마운트 시 파일 쓰기가 불가능한 문제의 해결방법을 적어본다.

<!--more-->

[멀티부팅환경에서 NTFS 파티션을 마운트](../ubuntu-automount-fstab)하더라도 사용하지 못하는 경우가 있는
<br>
문제 해결을 위해 긴 시간의 검색을 통해 알아낸 해당 문제의 원인은 윈도우의 최대절전모드였다.

윈도우의 최대절전모드(Hibernate)로 인해 생성되는 `hiberfil.sys`파일로 인해 우분투로 부팅한 이후에도 NTFS 드라이브에 대한 쓰기권한을 획득할 수 없는  것이다.


<br>
이를 해결할 수 있는 방법은 두가지가 있다.

1. 윈도우 단에서 해결
2. 우분투 단에서 해결

첫 번째 방법은 윈도우에서 최대절전모드를 해제하는 것이다.
<br>
윈도우에서 관리자 권한으로 cmd를 실행한 뒤 다음 중 하나의 명령어를 입력하여 최대절전모드를  해제하면 해당 문제를 해결할 수 있다.

```
> powercfg -hibernate off
```
```
> powercfg -h off
```
```
> powercfg /hibernate off
```
```
> powercfg /h off
```

<br>
두 번째 방법은 우분투에서 fstab을 통한 자동마운트 시에 ntfs-3g의 옵션 중 hiberfile을 제거하는 옵션을 통해 해결하는 것이다.

<br>
우선 ntfs-3g의 매뉴얼을 확인해보면 다음과 같다.

```bash
$ man
```
```
       remove_hiberfile
              When the NTFS volume is hibernated, a read-write mount is denied
              and a read-only mount is forced. One needs either to resume Win‐
              dows  and  shutdown  it  properly, or use this option which will
              remove the Windows hibernation file.  Please  note,  this  means
              that the saved Windows session will be completely lost. Use this
              option under your own responsibility.
```

<br>
나는 윈도우 최대절전모드와 우분투 듀얼부팅의 공존이 가능한 두 번째 방법을 통해 해당 문제를 해결했다.

```bash
$ vi /etc/fstab
```

<br>
fstab 파일의 ntfs-3g 옵션에 `remove_hiberfile`을 추가하면 매 우분투 부팅시마다 hiberfile(hiberfil.sys)을 강제로 삭제하게 된다.

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

/dev/sda4    /windows ntfs-3g defaults,remove_hiberfile 0 1 
/dev/md126p1 /dbstore ntfs-3g defaults,remove_hiberfile 0 1
{% endhighlight %}
