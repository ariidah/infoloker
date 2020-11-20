# InfoLoker notification pack
Script ini secara fungsi hanya membaca halaman awal dari situs [InfoLoker Karawang](https://infoloker.karawangkab.go.id/) menyimpan ringkasan lowongan kedalam file, lalu mendownload laman kriteria dari lowongan (fungsi ini ada sebab web sering overload). Proses ini disebut crawling, menurut saya script ini masih boleh, sebab hanya beberapa laman, selain itu buat apa web dibuat publik kalau tidak bisa diakses, tapi ngak baik juga kalau terlalu banyak request, gunakan dengan bijak.

**Saya tidak bertanggungjawab atas segala kerugian yang telah dan mungkin ditimbulkan dari script ini**

## Instalasi di Android dan tidak ingin ribet, baca section ini
Sesuai judulnya, perlu diperhatikan size repositori ini mungkin kecil, tapi package yang perlu diunduh bisa kisaran 100-200 MB dan proses ini melibatkan compiling, jadi persiapkan waktu dan kuota anda.
1. Download Termux dan Termux:API di Play Store.
2. Nonaktifkan penghematan baterai untuk Termux dan Termux:API.

	Buka menu Manajemen Aplikasi -> Daftar Aplikasi -> Cari Termux dan Termux:API -> (apapun itu namanya) Cari Penggunaan Baterai -> (apapun itu namanya) Izinkan aktiviitas latar belakang/Nonaktifkan penghematan baterai.
2. Install `git` buka Termux dan ketik commmand :
	```
	pkg install -y git
	```
3. Clone repositori ini, pada Termux ketik command :
	```
	git clone https://github.com/ariidah/infoloker
	```
4. Pindah ke direktori repositori ini, dengan commmand :
	```
	cd infoloker
	```
5. Eksekusi file termux_install.sh dengan command :
	```
	bash termux_install.sh
	```
6. Tunggu dan ikuti perintah yang ditampilkan.

	Bila anda BARU menggunakan Termux dan terjadi error baca output yang tampil di layar, beberapa dialog **permission request** akan tampil, **ACCEPT/ALLOW** permintaan izin yang ditampilkan kecuali anda ingin mengulang atau ingin melakukannya secara manual, anda bisa meninggalkan Termux (running di background, tanpa menutup aplikasi) dan membuka aplikasi lain.

## Eksekusi
### Troubleshooting
Intruksi selanjutnya mengandalkan file $HOME/infoloker.sh file itu **HARUS** ada bila tidak ada ikuti prosedur berikut :

1. Copy file infoloker.sh dari direktori repositori `/sdcard/infoloker/infoloker.sh` file tidak ada? unduh dari repositori ini [infoloker.sh](./infoloker.sh) ke folder $HOME degan command :
	```
	cp /sdcard/infoloker/infoloker.sh ~/
	```
2. Ubah permission dari file $HOME/infoloker.sh :
	```
	chmod 700 ~/infoloker.sh
	```
3. Cek symlink (detail bisa searching sendiri) :
	```
	which infoloker
	```
4. Apabila hasil dari point 4 tidak ada apa-apa kosong, lakukan langkah ini dan coba lagi :
	```
	ln -s $HOME/infoloker.sh $HOME/../usr/bin/infoloker
	```
5. Test run, output akan sedikit berantakan karena opsi LOG_LEVEL pada `settings.py` :
	```
	infoloker
	```
6. Gagal? opsi terakhir download ulang repositori ini lalu eksekusi termux_install.sh :
	```
	cd ~
	git clone https://github.com/ariidah/infoloker
	cd infoloker
	bash termux_install.sh
	```
	Tenang saja, secara otomatis mengecek package yang hilang atau miss, jadi tidak boros kuota.

### Mulai
Untuk melakukan scheduled crawling per 1 jam (3600000ms) bisa eksekusi baris ini :
```
infoloker start
```
Interval waktu bisa di set pada file `$/HOME/infoloker.sh`

Sedang untuk eksekusi sekali saja (walaupun ini jarang digunakan kecuali untuk Troubleshooting) :
```
infoloker
```

### Stop
Untuk stop scheduled crawling eksekusi :
```
infoloker stop
```

### Verifikasi scheduler
Untuk cek scheduler yang telah diaktifkan ketik :
```
termux-job-scheduler -p
```

## Termux:API
Kenapa harus pake `termux-api`, pada package `termux-api` terdapat command `termux-job-scheduler`. Alih-alih menggunakan `cron`, selain itu ada `termux-notification` biar ada notifikasi kalau ada lowongan baru, tap untuk membuka url dari notification-bar hal ini bisa sebab ada `termux-open`.

**Harap stop termux-job-scheduler setelah lewat jam kerja** (I mean, ngapain sih, toh bukan berarti akan ada yang posting lowongan tengah malem)

## Cache
Terdapat folder **cache/** semisal web overload akan melakukan non-stop download terhadap url kriteria, jadi semisal timeout ya retry. Hal ini berguna buat saya yang usianya sudah tidak muda, setelah laman terdownload cek menggunakan HTML Viewer (default ada di Android) apabila tidak sesuai kriteria stop, kalau sesuai baru pertarungan dimulai.

**Beberapa data mungkin tidak tampil (usia, gender dan formasi)** entah gimana (parsing?) querynya, kesel aja rebutan resources buat login eh mentok di usia. Karena repositori ini tidak melakukan login jadi ya gitu.

"Kualifikasi/(Usia Maksimal,Jumlah Formasi)" itu cuma tampil kalo udah login, kalo Gaji saya setuju. Tapi gender? sama usia? saya yakin sih itu data "Jumlah Formasi" minimal ada 2 kolom (Gender sama Demand), usia apa lagi cuma integer \*kali aja di follow-up.

Terdapat file **report.txt** semisal anda menghapus notifikasi secara tidak sengaja atau ingin copy-paste url ke browser.

## Instalasi Manual
**Anda sudah melakukan instalasi dan berhasil eksekusi?** skip bagian ini.

Repositori ini digunakan untuk ponsel Android, setup untuk PC dengan OS Fedora Workstation v31, saya tidak tahu untuk OS lain tapi menurut saya selama Linux ngak bakal terlalu berbeda.

### Termux
Download di Play Store lalu beri akses ke penyimpanan. Lalu buka termux dan ketik perintah :
```
termux-setup-storage
```

### Termux:API
Download di Play Store lalu beri akses ke notifikasi. Setelah itu buka Termux dan ketik perintah :
```
pkg install termux-api
```

### wget
Binary ini digunakan untuk download laman kriteria, tidak perlu penjelasan lebih lanjut mengenai binary ini, install dengan perintah :
```
pkg install wget
```

### w3m
Browser versi terminal digunakan untuk konversi file HTML ke text, mungkin ada banyak cara lain tapi ini yang saya pakai.
```
pkg install w3m
```

### python
Pada terminal Termux ketik perintah :
```
pkg install python
```

### scrapy
Berdasarkan url [Setting up scrapy in Termux for Android](https://gist.github.com/jcyl29/c73dcefd14c6ef6d4a00211bb62d3c94) pada terminal Termux ketik perintah :
```
pkg install libffi libxslt libxml2 clang
pip install scrapy
```

Catatan :

Apabila ada kesalahan pada proses instalasi menggunakan pkg cek koneksi internet dan pastikan package sudah up-to-date (bisa menggunakan `pkg upgrade`).

Apabila ada kesalahan pada proses baris pip install scrapy, silahkan baca-pelan-pelan error log, bisa jadi network error silahkan ulang lagi saja sedang sisanya mohon baca sekitar log terakhir dan cari sendiri di internet. At least di ponsel saya berhasil.

### First Setup untuk PC
Proses ini pada dasarnya sama seperti First Setup pada ponsel Android, hanya tanpa menggunakan package Termux diasumsikan scrapy sudah terinstall.

### libqrencode
Ini hanya tambahan, exception ketika eksekusi di terminal menggunakan PC untuk menampilkan barcode. Saya menggunakan Linux Fedora, pengguna linux lain bisa menyesuaikan.
```
sudo dnf install libqrencode
```

### notify-send
Saya menggunakan DE XFCE, saya tidak tahu `notify-send` berasal dari package mana sebab sudah ada secara default, saya menggunakan Linux Fedora dengan DE XFCE.

## Lain-lain
### I want do it my self
Spiders terdapat pada folder **infoloker/spiders/infoloker.py**, saya menonaktifkan robot.txt pada **settings.py** untuk meminimalisir timeout, saya juga **Tidak memodifikasi user-agent**.

### Lowongan yang tampil kurang?
Disini logikanya, lowongan baru akan tampil di homepage, sedangkan lowongan yang sudah terlalu lama akan tergeser ke laman berikutnya, untuk memproses laman berikutnya butuh network request dan pelamarnya pasti sudah banyak, selain itu posting lowongan sejauh ini belum ada yang tiba-tiba 5 lowongan sekaligus dalam interval 2 jam, jadi saya getok ngak, ngak perlu.

### Saya pasang scheduler tapi tetep ketinggalan
Disini saya belum memasang 'auto retry' pada saat crawling awal, tepatnya belum kepikiran dan jangan pasang interval scheduler terlalu mepet.

### Kemarin bisa sekarang error?
Karena script ini **HANYA** mengekstrak informasi tertentu dari laman web, tentunya modifikasi laman pada server akan berpengaruh terhadap output script ini. Saya baru saja belajar mungkin bisa diminimalisir dengan menggunakan metode xpath (saat ini masih menggunakan method css) tapi lihat saja nanti.

### Kok bisa?
Yang pertama saya lakukan rekontruksi, download laman awal dari web target lalu buat web server sendiri (lokal). Selanjutnya modifikasi source-code dari file HTML agar tidak melakukan request ke jaringan luar, hal ini relatif mudah hanya dengan menggunakan `sed`, bila perlu pasang rule firewall **ISOLASI**, selebihnya trial and error, toh di server lokal, belum ada sangkut-pautnya dengan web target.