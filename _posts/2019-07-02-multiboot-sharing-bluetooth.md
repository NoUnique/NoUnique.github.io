---
title: "Dev: 멀티부팅 환경에서 블루투스장치 공유하기"
categories:
  - Development
tags:
  - Dev_setting
---

나는 효율적인 자원활용을 위해 OS별로 별도 HW의 개발환경을 구축하기보다 멀티부팅 환경을 설정하는 것을 선호하는 편이다.

주로 Windows와 Ubuntu 듀얼부팅 환경을 세팅하는데, 이런 멀티부팅 환경에서 불편한 점 중 하나는 한 운영체제에 연결된 블루투스 장치를 다른 OS에서 사용할 수 없다는 것이다.  
멀티 페어링 장치의 경우에는 페어링 전환 버튼을 눌러가며 사용할 수 있겠지만, 멀티페어링을 미지원하는 블루투스 장치의 경우나 자주 OS를 바꿔가며 사용하는 개발용 노트북의 경우에는 OS를 바꿀때마다 새로 페어링을 하거나 페어링버튼을 눌러가며 쓰는 것이 귀찮다.

<!--more-->

먼저 순서는 다음과 같다.

1. 우분투에서 블루투스 장치 페어링
2. 윈도우에서 동일 블루투스 장치 다시 페어링
3. 윈도우에서 [psexec](http://live.sysinternals.com/psexec.exe)를 이용하여 블루투스 페어링 정보 획득
4. 윈도우의 페어링 정보를 우분투의 블루투스 장치 정보에 입력
5. 블루투스 서비스 재시작 (`sudo service bluetooth restart`)

이미 인터넷에는 듀얼부팅 환경에서 블루투스장치를 공유하는 방법에 대한 글이 많이 있지만, 한국어 설명의 경우에는 일반 블루투스 장치(Bluetooth 4.0미만의 Bluetooth Classic 장치)에 대한 설명이 거의 대부분이고 BLE(Bluetooth Low Energy)장치를 공유하는 방법은 그것과 조금 다르기에 내가 겪었던 시행착오를 토대로 기록으로 남겨보고자 한다.  

영어로 검색해도 BLE 장치 멀티부팅 공유에 대해 잘 설명되어 있는 글은 드문 편인데, 내가 참고한 글은 다음과 같다.

[참고 사이트](http://console.systems/2014/09/how-to-pair-low-energy-le-bluetooth.html)[^1]

[^1]: http://console.systems/2014/09/how-to-pair-low-energy-le-bluetooth.html

사실 이 내용은 BLE뿐만 아니라 BR/EDR(Bluetooth Basic Rate/Enhanced Data Rate)에도 적용가능하며, 참고사이트의 내용 중에 일부 달라진 내용도 있고 부가설명이 필요한 내용도 있으므로 별도로 작성해본다.

내가 Workstation에서 사용하려는 장비들 중, 한성 GK888B minicoup 무접점 키보드, Logitech K600 TV 키보드와 MX Anywhere 2는 BLE 제품이며, Keychron K1은 BR/EDR 기기이다.  
이 장비들을 Windows10과 Ubuntu18.04에서 공유해서 사용해보자.

<br>
우선 우분투에 블루투스 장치를 페어링한다. 페어링이 완료되면 윈도우로 부팅하여 다시 페어링한다.  
(우분투에 먼저 페어링 하는 것은 블루투스 장치 연결정보를 먼저 생성하여 추후에 내용 수정만으로 장치와 연결할 수 있도록 하기 위함이다.)

우분투에 페어링 된 상태에서 다시 윈도우에 연결하게되면, 블루투스 장치는 이전 연결정보(우분투와의 페어링 정보)를 잃고 새로운 정보(윈도우와의 페어링 정보)를 저장하게 되는데 윈도우에 저장된 페어링 키들을 [psexec.exe](http://live.sysinternals.com/psexec.exe) 로 접근하여 ubuntu로 옮겨주면 멀티부팅 환경에서 다른 OS를 쓰더라도 블루투스 장치를 공유해서 사용할 수 있게된다.

<br>
먼저 다운받은 psexe.exe를 이용하여 감춰져있는 레지스트리에서 블루투스 페어링 키들을 추출해낸다.  
여기서 명령 프롬프트(cmd)나 파워쉘(powershell)은 관리자 권한으로 실행해야 한다.

```
> psexec.exe -s -i regedit /e C:\BTKeys.reg HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys
```

<br>
참고사이트는 키를 출력하는 데 그치지만, 레지스트리 내용을 스크린샷을 찍어 놓으면 더 편리하게 작업할 수 있다.  
페어링 키를 파일로 출력할 때와 동일하게 관리자 권한으로 psexec를 통해 레지스트리 에디터를 켜자.

```
> psexec.exe -s -i regedit
```

`HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys` 아래의 블루투스 수신기 아래에서 필요한 정보를 모두 스크린샷으로 찍자.  
여기서 `74c63b010204`는 블루투 수신기의 MAC주소고, `2180040073ec`는 블루투스 장치의 MAC주소다.

![bth_2](/assets/images/2019-07-02-multiboot-sharing-bluetooth_002.png)

블루투스 수신기 바로 아래에 있는 페어링 정보는 어차피 파일로 출력되었으므로
키가 별도로 저장되는 장치에 대한 스크린샷을 찍어두는 것 이 좋다.

<br>
출력된 내용(BTKeys.reg)은 다음과 같다.

{% highlight bat linenos %}
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys]

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204]
"MasterIRK"=hex:ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff,ff
"dc2c26c6cde3"=hex:e4,ab,55,b2,58,1d,ce,c8,4b,97,b6,a2,9e,a0,6d,01

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204\2180040073ec]
"LTK"=hex:d5,3e,d7,c6,ec,23,c0,1f,e5,60,a1,f9,ad,3b,9b,82
"KeyLength"=dword:00000000
"ERand"=hex(b):a3,6c,29,c3,0a,77,03,b7
"EDIV"=dword:0000a101
"IRK"=hex:c9,6e,6c,bc,1f,6d,db,ad,6d,9a,ae,97,d8,15,77,ec
"Address"=hex(b):ec,73,00,04,80,21,00,00
"AddressType"=dword:00000000
"MasterIRKStatus"=dword:00000001
"AuthReq"=dword:0000002d

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204\c473e8685a52]
"LTK"=hex:4d,5e,1b,f5,38,b7,f8,41,b2,80,5a,e8,5a,94,25,f9
"KeyLength"=dword:00000000
"ERand"=hex(b):29,0f,e1,9f,0f,bc,7a,f3
"EDIV"=dword:00000ede
"IRK"=hex:6d,1c,16,93,fb,e0,cb,c1,44,2c,7d,55,7a,9b,87,05
"Address"=hex(b):52,5a,68,e8,73,c4,00,00
"AddressType"=dword:00000001
"CSRK"=hex:48,1f,aa,fe,d0,f0,5a,6d,32,c3,10,d6,e8,6f,e6,1b
"OutboundSignCounter"=dword:00000000
"MasterIRKStatus"=dword:00000001
"AuthReq"=dword:0000002d

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204\d04fc337484c]
"LTK"=hex:e3,b4,51,7b,59,d5,64,ec,87,ff,b9,57,d8,7c,82,2c
"KeyLength"=dword:00000000
"ERand"=hex(b):12,9f,50,55,9b,15,53,f7
"EDIV"=dword:00008e54
"IRK"=hex:b4,fa,d1,c3,35,98,7e,59,b8,14,aa,25,60,3a,6d,c5
"Address"=hex(b):4c,48,37,c3,4f,d0,00,00
"AddressType"=dword:00000001
"MasterIRKStatus"=dword:00000001
"AuthReq"=dword:0000002d
{% endhighlight %}

<br>
이 정보를 우분투의 블루투스 정보 `/var/lib/bluetooth/{블루투스수신기MAC}`에 옮기면 윈도우에서 페어링 된 장비를 우분투에서 사용할 수 있다.

블루투스 종류가 다양하고 내용이 복잡하니 한 종류씩 살펴보자.

<br>

1. 페어링 키만 있는 경우

    해당 장치는 BR/EDR 장치인 Keychron K1이다.  
    Bluetooth 4.0 이전버전의 일반 블루투스 장치와 BR/EDR 장치들의 경우 페어링 키값만 존재한다.

    윈도우 레지스트리 값은 다음과 같다.

    ~~~
    [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204]
    "dc2c26c6cde3"=hex:e4,ab,55,b2,58,1d,ce,c8,4b,97,b6,a2,9e,a0,6d,01
    ~~~

    ![bth_1](/assets/images/2019-07-02-multiboot-sharing-bluetooth_001.png)

    우분투에서 이에 해당하는 장치의 블루투스 정보를 열면 다음과 같다.


    ```bash
    $ sudo vi /var/lib/bluetooth/74:C6:3B:01:02:04/DC:2C:26:C6:CD:E3/info
    ```

    `74:C6:3B:01:02:04`은 블루투스 수신기의 MAC주소이고, `DC:2C:26:C6:CD:E3`는 블루투스 장치의 MAC주소이다.

    ~~~
    [General]
    Name=K1-Keyboard
    Class=0x000540
    SupportedTechnologies=BR/EDR;
    Trusted=true
    Blocked=false
    Services=00001000-0000-1000-8000-00805f9b34fb;00001124-0000-1000-8000-00805f9b34fb;00001200-0000-1000-8000-00805f9b34fb;

    [LinkKey]
    Key=E4AB55B2581DCEC84B97B6A29EA06D01
    Type=4
    PINLength=0

    [DeviceID]
    Source=2
    Vendor=1452
    Product=597
    Version=283
    ~~~

    페어링 키만 있기 때문에 페어링키를 HEX형태로 그대로 복사하여 `[LinkKey]`아래의 `Key`에 구분자 없이 대문자로 입력해주면 사용할 수 있다.  
    설정 완료 후에는 `sudo service bluetooth restart`로 블루투스 서비스를 재시작해주어야 새 설정이 적용된다.


2. BLE with Public/Static Address

    블루투스 4.0 이후부터의 BLE(Bluetooth Low Energy) 장치의 연결 정보에는 페어링 키 외에도 많은 정보가 들어있다.  
    (LTK(Long Term Key), Key Length, ERand, EDiv, CSRK(Connection Signature Resolving Key) 등)

    이 섹션에서는 그 중 장치 주소 타입에 따른 차이만 알아보려고 한다.

    [Bluetooth Core Spec 4.0](https://www.bluetooth.org/docman/handlers/downloaddoc.ashx?doc_id=229737)의 Section 1.3을 보면 Device Address에 대한 내용이 있다.  
    Public Address는 블루투스의 MAC Address로, 고정된 값이다.
    Static(Random) Address는 페어링 시 일정한 규칙 하에 랜덤하게 생성되는 주소값으로, 보통 일반적인 장치들은 완전히 랜덤으로 생성되진 않고 내부 counter에 의해 순차적으로 생성되는 것 같다.

    윈도우에서는 AddressType 1(Ramdom), 0(Public) 으로 저장되고,
    우분투에서는 AddressType static(Random), public(Public)으로 저장된다.

    Ramdom Address의 차이점은 한가지밖에 없다. 페어링마다 블루투스 장치의 주소가 무작위로 저장된다는 것.  
    따라서 Random Address 속성을 지닌 장치의 경우에는 우분투에서 페어링 한 뒤 윈도우에서 페어링하면 두 OS에 저장된 블루투스 장치의 주소가 달라지기 때문에 다시 우분투로 부팅 한 뒤에 저장된 해당 장치의 주소를 윈도우에서 페어링 된 주소랑 동일하게 수정해 주어야 한다.

    ```bash
    $ mv /var/lib/bluetooth/74\:C6\:3B\:01\:02\:04/D0\:4F\:C3\:37\:48\:4B/ /var/lib/bluetooth/74\:C6\:3B\:01\:02\:04/D0\:4F\:C3\:37\:48\:4C/
    ```
    `74:C6:3B:01:02:04`은 블루투스 수신기의 MAC주소이고, `D0:4F:C3:37:48:4C`는 블루투스 장치의 최신 Static(Random) 주소이다.

    예시로 사용한 장치의 경우는 Logitech K600 TV 키보드이고, 해당 장치의(멀티페어링 가능 장치) 3번째 페어링 슬롯의 Static 주소는 페어링 할 때마다 순차적으로 끝자리가 `4A`, `4B`, `4C`로 할당 되었다.  
    (블루투스 스펙 상에는 랜덤 할당이라고 되어있지만 내부적으로는 카운터를 이용하여 순차적으로 배정하는 방식이 아닐까 추측해본다.)

    <br>
    윈도우에서의 페어링 정보는 다음과 같다.
    ~~~
    [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204\d04fc337484c]
    "LTK"=hex:e3,b4,51,7b,59,d5,64,ec,87,ff,b9,57,d8,7c,82,2c
    "KeyLength"=dword:00000000
    "ERand"=hex(b):12,9f,50,55,9b,15,53,f7
    "EDIV"=dword:00008e54
    "IRK"=hex:b4,fa,d1,c3,35,98,7e,59,b8,14,aa,25,60,3a,6d,c5
    "Address"=hex(b):4c,48,37,c3,4f,d0,00,00
    "AddressType"=dword:00000001
    "MasterIRKStatus"=dword:00000001
    "AuthReq"=dword:0000002d
    ~~~

    ![bth_4](/assets/images/2019-07-02-multiboot-sharing-bluetooth_004.png)

    <br>
    우분투에서 이에 해당하는 장치의 블루투스 정보를 열면 다음과 같다.

    ```bash
    $ sudo vi /var/lib/bluetooth/74:C6:3B:01:02:04/D0:4F:C3:37:48:4C/info
    ```

    ~~~
    [General]
    Name=Keyboard K600 TV
    Appearance=0x03c1
    AddressType=static
    SupportedTechnologies=LE;
    Trusted=true
    Blocked=false
    Services=00001800-0000-1000-8000-00805f9b34fb;00001801-0000-1000-8000-00805f9b34fb;0000180a-0000-1000-8000-00805f9b34fb;0000180f-0000-1000-8000-00805f9b34fb;00001812-0000-1000-8000-00805f9b34fb;00010000-0000-1000-8000-011f2000046d;
    
    [DeviceID]
    Source=2
    Vendor=1133
    Product=45907
    Version=21
    
    [ConnectionParameters]
    MinInterval=6
    MaxInterval=9
    Latency=44
    Timeout=216
    
    [IdentityResolvingKey]
    Key=B4FAD1C335987E59B814AA25603A6DC5
    
    [LongTermKey]
    Key=E3B4517B59D564EC87FFB957D87C822C
    Authenticated=1
    EncSize=16
    EDiv=36436
    Rand=17821611907330645778
    ~~~

    `LTK`는 `[LongTermKey]`의 `Key`,  
    `ERand` `[LongTermKey]`의 `Rand`
    `EDIV`는 `[LongTermKey]`의 `Ediv`
    `IRK`는 `[IdentityResolvingKey]`의 `Key`에 넣어주면 된다.

    Key들은 HEX값 그대로 구분자를 제거한 뒤 대문자로 변경해서 넣어주면 되는데 `EDiv`와 `Rand` 값의 경우는 조금 더 까다롭다.  
    `EDiv`의 경우는 HEX 값을 10진수로 변경해주어야 하고, `Rand`값의 경우는 HEX 값의 순서를 뒤집은 후 10진수로 변경해주어야 하는데, 이때 아까 저장해 둔 스크린샷이 빛을 발할 것이다.

    ![bth_4](/assets/images/2019-07-02-multiboot-sharing-bluetooth_004.png)

    regedit에는 `ERand`값과 `EDIV` 값이 괄호 안에 적절한 10진수 값으로 변환되어 있기 때문에 그 값을 그대로 입력하면 귀찮은 변경과정 없이 사용할 수 있다.

    * 참고사이트에서는 `KeyLength`값을 `EnvSize`에 넣어주라고 되어있었으나, 내 경우에는 그렇게 수정하면 작동하지 않았다.  
    참고사이트의 댓글에도 동일 증상을 호소하는 사람들이 있었고, Logitech 제품의 경우에는 EncSize를 수정하면 작동하지 않는다고 하니 참고하면 좋을것이다.  
    (참고로 내 경우에는 모든 블루투스 장치의 EncSize를 수정하지 않고 기본값(16)으로 사용해야 정상 작동했었다.)


3. BLE with CSRK
    
    BLE장치들 중에는 페어링 정보에 CSRK(Connection Signature Resolving Key)를 포함하는 장치도 있다.

    추가적인 정보가 있다는 것 외에는 일반적인 BLE 장치의 연결정보를 수정하는 것과 크게 다르지 않다.

    <br>
    윈도우에서의 페어링 정보는 다음과 같다.

    ~~~
    [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys\74c63b010204\c473e8685a52]
    "LTK"=hex:4d,5e,1b,f5,38,b7,f8,41,b2,80,5a,e8,5a,94,25,f9
    "KeyLength"=dword:00000000
    "ERand"=hex(b):29,0f,e1,9f,0f,bc,7a,f3
    "EDIV"=dword:00000ede
    "IRK"=hex:6d,1c,16,93,fb,e0,cb,c1,44,2c,7d,55,7a,9b,87,05
    "Address"=hex(b):52,5a,68,e8,73,c4,00,00
    "AddressType"=dword:00000001
    "CSRK"=hex:48,1f,aa,fe,d0,f0,5a,6d,32,c3,10,d6,e8,6f,e6,1b
    "OutboundSignCounter"=dword:00000000
    "MasterIRKStatus"=dword:00000001
    "AuthReq"=dword:0000002d
    ~~~

    ![bth_3](/assets/images/2019-07-02-multiboot-sharing-bluetooth_003.png)

    <br>
    우분투에서의 페어링 정보를 다음과 같이 수정하면 된다.

    ```bash
    $ sudo vi /var/lib/bluetooth/74:C6:3B:01:02:04/C4:73:E8:68:5A:52/info
    ```

    ~~~
    [General]
    Name=MX Anywhere 2
    Appearance=0x03c2
    AddressType=static
    SupportedTechnologies=LE;
    Trusted=true
    Blocked=false
    Services=00001800-0000-1000-8000-00805f9b34fb;00001801-0000-1000-8000-00805f9b34fb;0000180a-0000-1000-8000-00805f9b34fb;0000180f-0000-1000-8000-00805f9b34fb;00001812-0000-1000-8000-00805f9b34fb;00010000-0000-1000-8000-011f2000046d;
    
    [ConnectionParameters]
    MinInterval=6
    MaxInterval=9
    Latency=44
    Timeout=216
    
    [IdentityResolvingKey]
    Key=6D1C1693FBE0CBC1442C7D557A9B8705
    
    [LocalSignatureKey]
    Key=481FAAFED0F05A6D32C310D6E86FE61B
    Counter=0
    Authenticated=false
    
    [LongTermKey]
    Key=4D5E1BF538B7F841B2805AE85A9425F9
    Authenticated=0
    EncSize=16
    EDiv=3806
    Rand=17544542073668046633
    
    [DeviceID]
    Source=2
    Vendor=1133
    Product=45075
    Version=7
    ~~~

    `CSRK`는 `[LocalSignatureKey]`의 `Key`,  
    `OutboundSignCounter` `[LocalSignatureKey]`의 `Counter`에 넣어주면 된다.


모든 과정의 마지막에는 `sudo service bluetooth restart`로 블루투스 서비스를 재시작하여 저장한 정보가 적용되게 하자.

이제 멀티부팅환경에서 윈도우와 우분투 환경을 바꿔가며 사용해도 블루투스 장치 지속적으로 페어링 되어있을 것이다.
