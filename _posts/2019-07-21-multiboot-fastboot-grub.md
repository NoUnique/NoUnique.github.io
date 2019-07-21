---
title: "Dev: 멀티부팅 환경 부팅속도 최적화(GRUB)"
categories:
  - Development
tags:
  - Dev_setting
---

멀티부팅 환경에서 GRUB 설정을 변경하여 부팅속도를 빠르게 최적화해보자.

<!--more-->

Windows 설치 후 Ubuntu를 설치하게 되면 GRUB 부트로더에 의해서 부팅할 운영체제를 선택하게 되는데, WOL을 통한 원격부팅의 경우 default OS가 선택 될 때까지 10초를 기다려야하기 때문에 부팅까지 걸리는 시간이 늦어지게 되고, 수동으로 선택하는 경우에도 수동선택까지의 시간이 추가되기 때문에 이를 줄여주면 좀더 빠른 부팅이 가능할 것이다.

우선 GRUB 설정을 열자.

```bash
$ sudo vi /etc/default/grub
```

{% highlight bash linenos %}
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
{% endhighlight %}

시간을 0초로 하면 OS 선택 화면 자체가 뜨지 않으므로 TIMEOUT을 1로 설정해주도록 하자.

변경된 GRUB 설정을 적용하려면 update를 시켜줘야 한다.

```bash
sudo update-grub
```

OS 선택 대기시간이 1초라 부팅이 빠르고, OS 변경이 필요할 시에도 키보드를 통해 충분히 다른 OS로 부팅이 가능하다.