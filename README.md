# InfoLoker notification pack
Script ini secara fungsi hanya membaca halaman awal dari situs [InfoLoker Karawang](https://infoloker.karawangkab.go.id/) menyimpan ringkasan lowongan kedalam file, lalu mendownload laman kriteria dari lowongan (fungsi ini ada sebab web sering overload). Proses ini disebut crawling, menurut saya script ini masih boleh, sebab hanya beberapa laman, selain itu buat apa web dibuat publik kalau tidak bisa diakses, tapi ngak baik juga kalau terlalu banyak request, gunakan dengan bijak.

**Saya tidak bertanggungjawab atas segala kerugian yang telah dan mungkin ditimbulkan dari script ini**

## First Setup
Proses ini secara ringkas digunakan untuk ponsel Android, setup untuk PC dengan OS Fedora Workstation v31, saya tidak tahu untuk OS lain tapi menurut saya selama Linux ngak bakal terlalu berbeda.

###### Termux
Download di Play Store lalu beri akses ke penyimpanan. Lalu buka termux dan ketik perintah :
```
termux-setup-storage
```

###### Termux API
Download di Play Store lalu beri akses ke notifikasi. Setelah itu buka Termux dan ketik perintah :
```
pkg install termux-api
```

###### wget
Binary ini digunakan untuk download laman kriteria, tidak perlu penjelasan lebih lanjut mengenai binary ini, install dengan perintah :
```
pkg install wget
```

###### python
Pada terminal Termux ketik perintah :
```
pkg install python
```

###### scrapy
Berdasarkan url [Setting up scrapy in Termux for Android](https://gist.github.com/jcyl29/c73dcefd14c6ef6d4a00211bb62d3c94) pada terminal Termux ketik perintah :
```
pkg install libffi libxslt libxml2 clang
pip install scrapy
```

Catatan :

Apabila ada kesalahan pada proses instalasi menggunakan pkg cek koneksi internet dan pastikan package sudah up-to-date (bisa menggunakan `pkg upgrade`).

Apabila ada kesalahan pada proses baris pip install scrapy, silahkan baca-pelan-pelan error log, apabila mengandung teks **GET** silahkan ulang lagi saja (network error) sisanya mohon cari sendiri di internet. At least di ponsel saya berhasil.

### First Setup untuk PC
Proses ini pada dasarnya sama seperti First Setup pada ponsel Android, hanya tanpa menggunakan package Termux

###### libqrencode
Ini hanya tambahan, exception ketika eksekusi di terminal menggunakan PC untuk menampilkan barcode. Saya menggunakan Linux Fedora, pengguna linux lain bisa menyesuaikan.
```
sudo dnf install libqrencode
```

###### notify-send
Saya menggunakan DE XFCE, saya tidak tahu `notify-send` berasal dari package mana sebab sudah ada secara default, saya menggunakan Linux Fedora dengan DE XFCE.

## Termux API
Proses ini yang membuat kenapa harus pake `termux-api`, pada package `termux-api` terdapat command `termux-job-scheduler`. Alih-alih menggunakan `cron`, selain itu ada `termux-notification` biar ada notifikasi kalau ada lowongan baru, tap untuk membuka url dari notification-bar hal ini bisa sebab ada `termux-open`.

**Harap stop termux-job-scheduler setelah lewat jam kerja** (I mean, ngapain sih, toh bukan berarti akan ada yang posting lowongan tengah malem)

## Cache
Terdapat folder **cache/** semisal web overload akan melakukan non-stop download terhadap url kriteria, jadi semisal timeout ya retry. Hal ini berguna buat saya yang usianya sudah tidak muda, setelah laman terdownload cek menggunakan HTML Viewer (otomatis ada di Android) apabila tidak sesuai kriteria stop, kalau sesuai baru pertarungan dimulai.

Terdapat file **report.txt** semisal anda menghapus notifikasi secara tidak sengaja, atau ingin copy-paste url ke browser.

## Eksekusi
###### Awal sekali
Apabila anda mendapat script ini melalui `git clone` pada $HOME directory Termux  maka tidak ada masalah, sedang bagi yang lainnya ada hal yang perlu diubah.

Pastikan melakukan extract repository ini pada directory **$HOME**, agar bisa merubah file permission. Tepatnya **~/infoloker** sebenarnya terserah tapi pastikan modifikasi variable **$SCRIPTHOME** di file `infoloker.sh` dan pastikan bisa merubah permission file `infoloker.sh`

Pastikan memiliki permission untuk eksekusi file infoloker.sh apabila ragu eksekusi :
```
chmod 700 infoloker.sh
```

Lalu ketik `ls -la infoloker.sh` pastikan permission nya diawali **-rwx** untuk lebih lengkap silahkan googling dengan keyword **linux file permission**. Hal ini tidak akan berfungsi kalau file infoloker.sh berada pada direktori penyimpanan internal/sdcard, harus berada pada direktori $HOME dari Termux.

First run dengan eksekusi :
```
./infoloker.sh
```

Tidak berfungsi? Pastikan direktori aktif adalah direktori repository ini, lalu eksekusi baris ini secara manual, apabila berhasil berarti ada kesalahan pada file infoloker.sh
```
scrapy crawl infoloker
```

Setelah berhasil eksekusi file `infoloker.sh`, file `infoloker.sh` bisa dipindah ke $HOME directory Termux untuk meminimalisir ketikan, tapi pastikan kembali **$SCRIPTHOME** adalah path untuk repository ini. File `infoloker.sh` ini bisa dibilang launchernya.

###### Mulai
Untuk melakukan scheduled crawling per 1 jam (3600000ms) bisa eksekusi baris ini, pastikan file berada pada direktori yang sama dengan `infoloker.sh` dan file `infoloker.sh` bisa dieksekusi.
```
termux-job-scheduler -s $PWD/infoloker.sh --period-ms 3600000
```

Sedang untuk eksekusi sekali saja (walaupun ini jarang digunakan)
```
bash infoloker.sh
```

###### Stop
Untuk stop scheduled crawling eksekusi :
```
termux-job-scheduler --cancel-all
```

###### Verifikasi scheduler
Untuk cek scheduler yang telah diaktifkan ketik :
```
termux-job-scheduler -p
```

###### Keterangan
Saya sengaja tidak membuat executable untuk bagian Mulai, Stop maupun Verifikasi scheduler, lagipula kenapa harus semuanya dibikinin kalo bisa bikin sendiri.

## Lain-lain
###### I want do it my self
Spiders terdapat pada folder **infoloker/spiders/infoloker.py**, saya menonaktifkan robot.txt pada **settings.py** untuk meminimalisir timeout, saya juga **Tidak memodifikasi user-agent**.

###### Lowongan yang tampil kurang
Disini logikanya, lowongan baru akan tampil di homepage, sedangkan lowongan yang sudah terlalu lama akan tergeser ke laman berikutnya, untuk memproses laman berikutnya butuh network request dan pelamarnya pasti sudah banyak, selain itu posting lowongan sejauh ini belum ada yang tiba-tiba 5 lowongan sekaligus dalam interval 2 jam, jadi saya getok ngak, ngak perlu.

###### Saya pasang scheduler tapi tetep ketinggalan
Disini saya belum memasang 'auto retry' pada saat crawling awal, tepatnya belum kepikiran dan jangan pasang interval scheduler terlalu mepet.

###### Kemarin bisa sekarang error
Karena script ini **HANYA** mengekstrak informasi tertentu dari laman web, tentunya modifikasi laman pada server akan berpengaruh terhadap output script ini. Saya baru saja belajar mungkin bisa diminimalisir dengan menggunakan metode xpath (saat ini masih menggunakan method css) tapi lihat saja nanti.

###### Kok bisa?
Yang pertama saya lakukan rekontruksi, download laman awal dari web target lalu buat web server sendiri (lokal). Selanjutnya modifikasi source-code dari file HTML agar tidak melakukan request ke jaringan luar, hal ini relatif mudah hanya dengan menggunakan `sed`, bila perlu pasang rule firewall **ISOLASI**, selebihnya trial and error, toh di server lokal, belum ada sangkut-pautnya dengan web target.
