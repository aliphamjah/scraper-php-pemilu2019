# pemilu2019-kpucrawler
Crawler data Situng KPU - Untuk pemilu 2019

Script ini dibuat seadanya, dan "secepatnya jadi", karena awalnya hanya untuk
konsumsi pribadi. Tapi konsep cara crawling nya udah ada di sana, tinggal
dikembangkan, memang bagusnya menggunakan shell language atau bagus lagi pake
C/C++, tapi menurut saya terlalu memakan waktu dan resource, dikarenakan
jangka waktu aplikasi ini hanya bisa digunakan paling lama 1-2 bulan, setelah
itu program ini jadi Obsolete.

# Script
* 00_get_main.php - Untuk ambil data propinsi (1x run aja cukup)
* 01_get_prov.php - Untuk ambil data kota/kab sampai kelurahan
   (Dijalankan sampai beres dengan eksekusi 11_start_prov - multi process)
* 02_get_suara.php - Ini untuk ambil data per TPS.
   Akan melakukan query view kelurahan yang updatenya terlama, lalu bila
   di kelurahan tersebut terdapat TPS yang sudah terisi suara, maka
   data TPS yang dimaksud akan di download agar mendapatkan data
   suara sah, tidak sah dan jumlah
* 03_loop_suara.sh - (TDK-DIPAKAI-LAGI) Script lama kalau tidak pake systemd
* 11_start_prov - Lihat baca 01_get_prov.php
* 12_start_suara - (TDK-DIPAKAI-LAGI) Script lama untuk get suara tanpa systemd
* 13_stop - Stop service / all php/crawling process
* 20_restart_service - restart semua service crawler systemd
* 30_get_status - lihat status semua service crawler systemd
* 40_get_logs - lihat journalctl untuk service. Param nya nomor service


# SYSTEMD
* Ini saya main cepat, kita pake 5 service untuk melakukan fetch secara
bersamaan, karena PHP tidak mempunyai fasilitas Thread dan native fork,
gk lucu juga pake fork di PHP mah...

* 1 service melakukan fetch beberapa propinsi. Silahkan dilihat aja script2nya.


# PENUTUP
Program Ini tidak saya coding dikarenakan ada keberpihakan atau sebagainya,
Tapi dikarenakan ketertarikan dan hobby.

Dengan script/program ini, bukan hanya bisa menampilkan data yang menguntungkan
satu pasangan, tapi pasti ditemukan juga data-data yang menguntungkan
pasangan lainnya.

Terima Kasih
Dan mohon maaf, README nya rancu... SAYA BELUM TIDUR... wkwkwkwk

