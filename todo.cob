IDENTIFICATION DIVISION.
PROGRAM-ID. DAFTAR-TUGAS.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT BERKAS-TUGAS ASSIGN TO "tasks.dat"
        ORGANIZATION IS LINE SEQUENTIAL
        FILE STATUS IS WS-STATUS-BERKAS.

DATA DIVISION.
FILE SECTION.
FD  BERKAS-TUGAS.
01  CATATAN-TUGAS.
    05  CT-STATUS       PIC X.
    05  CT-DESKRIPSI    PIC X(80).

WORKING-STORAGE SECTION.
78  MAKSIMAL-TUGAS      VALUE 100.

01  WS-JUMLAH           PIC 9(3) VALUE 0.

01  WS-TUGAS.
    05  WS-ENTRI-TUGAS OCCURS 100 TIMES.
        10  WS-STATUS-TUGAS PIC X.
        10  WS-DESKRIPSI-TUGAS PIC X(80).

01  WS-STATUS-BERKAS    PIC X(2) VALUE SPACE.
01  WS-PILIHAN-RAW      PIC X(30) VALUE SPACE.
01  WS-NOMOR            PIC 9(4) VALUE 0.
01  WS-ANGKA            PIC 9(2) VALUE 0.
01  WS-VALID            PIC X VALUE 'Y'.
01  WS-PILIHAN          PIC 9(3) VALUE 0.
01  WS-I                PIC 9(3) VALUE 0.
01  WS-J                PIC 9(3) VALUE 0.
01  WS-K                PIC 9(3) VALUE 0.
01  WS-KELUAR-LOOP      PIC X VALUE 'N'.
01  WS-AKHIR-FILE       PIC X VALUE 'N'.
01  WS-PESAN            PIC X(80) VALUE SPACE.
01  WS-TAMPIL-NOMOR     PIC ZZ9.

PROCEDURE DIVISION.
MAIN-LOGIC.
    PERFORM MUAT-TUGAS
    PERFORM UNTIL WS-KELUAR-LOOP = 'Y'
        PERFORM TAMPILKAN-MENU
        PERFORM BACA-PILIHAN
        EVALUATE WS-PILIHAN
            WHEN 1
                PERFORM TAMBAH-TUGAS
            WHEN 2
                PERFORM LIHAT-TUGAS
            WHEN 3
                PERFORM SELESAIKAN-TUGAS
            WHEN 4
                PERFORM HAPUS-TUGAS
            WHEN 5
                MOVE 'Y' TO WS-KELUAR-LOOP
            WHEN OTHER
                DISPLAY "Pilihan tidak valid, coba lagi."
        END-EVALUATE
    END-PERFORM
    DISPLAY "Selamat tinggal!"
    STOP RUN.

TAMPILKAN-MENU.
    DISPLAY " "
    DISPLAY "=== DAFTAR TUGAS SAYA ==="
    DISPLAY "  1) Tambah tugas"
    DISPLAY "  2) Lihat tugas"
    DISPLAY "  3) Tandai tugas selesai"
    DISPLAY "  4) Hapus tugas"
    DISPLAY "  5) Keluar"
    DISPLAY "Pilihan> " WITH NO ADVANCING.

BACA-PILIHAN.
    ACCEPT WS-PILIHAN-RAW
    PERFORM PARSE-NOMOR
    MOVE WS-NOMOR TO WS-PILIHAN.

PARSE-NOMOR.
    MOVE ZERO TO WS-NOMOR
    MOVE ZERO TO WS-ANGKA
    MOVE 'Y' TO WS-VALID
    PERFORM VARYING WS-K FROM 1 BY 1 UNTIL WS-K > 30
        IF WS-PILIHAN-RAW(WS-K:1) NOT = SPACE
            IF WS-PILIHAN-RAW(WS-K:1) >= "0"
               AND WS-PILIHAN-RAW(WS-K:1) <= "9"
                ADD 1 TO WS-ANGKA
                IF WS-ANGKA > 4
                    MOVE 'N' TO WS-VALID
                END-IF
            ELSE
                MOVE 'N' TO WS-VALID
            END-IF
        END-IF
    END-PERFORM
    IF WS-VALID = 'Y'
        MOVE FUNCTION NUMVAL(WS-PILIHAN-RAW) TO WS-NOMOR
    END-IF.

TAMBAH-TUGAS.
    DISPLAY "Teks tugas> " WITH NO ADVANCING
    ACCEPT WS-PILIHAN-RAW
    MOVE FUNCTION TRIM(WS-PILIHAN-RAW) TO WS-PESAN
    IF WS-PESAN = SPACES
        DISPLAY "Tidak ada tugas yang ditambahkan."
    ELSE
        IF WS-JUMLAH >= MAKSIMAL-TUGAS
            DISPLAY "Daftar penuh (maksimal 100 tugas)."
        ELSE
            ADD 1 TO WS-JUMLAH
            MOVE 'O' TO WS-STATUS-TUGAS(WS-JUMLAH)
            MOVE WS-PESAN TO WS-DESKRIPSI-TUGAS(WS-JUMLAH)
            PERFORM SIMPAN-TUGAS
            DISPLAY "Tugas berhasil ditambahkan."
        END-IF
    END-IF.

LIHAT-TUGAS.
    IF WS-JUMLAH = 0
        DISPLAY "Belum ada tugas."
    ELSE
        PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-JUMLAH
            MOVE WS-I TO WS-TAMPIL-NOMOR
            IF WS-STATUS-TUGAS(WS-I) = 'X'
                DISPLAY WS-TAMPIL-NOMOR ") [x] "
                    FUNCTION TRIM(WS-DESKRIPSI-TUGAS(WS-I))
            ELSE
                DISPLAY WS-TAMPIL-NOMOR ") [ ] "
                    FUNCTION TRIM(WS-DESKRIPSI-TUGAS(WS-I))
            END-IF
        END-PERFORM
    END-IF.

SELESAIKAN-TUGAS.
    IF WS-JUMLAH = 0
        DISPLAY "Belum ada tugas."
    ELSE
        DISPLAY "Nomor tugas yang selesai> " WITH NO ADVANCING
        ACCEPT WS-PILIHAN-RAW
        PERFORM PARSE-NOMOR
        IF WS-VALID = 'N' OR WS-NOMOR < 1 OR WS-NOMOR > WS-JUMLAH
            DISPLAY "Nomor tugas tidak valid."
        ELSE
            IF WS-STATUS-TUGAS(WS-NOMOR) = 'X'
                DISPLAY "Tugas sudah selesai."
            ELSE
                MOVE 'X' TO WS-STATUS-TUGAS(WS-NOMOR)
                PERFORM SIMPAN-TUGAS
                DISPLAY "Tugas berhasil ditandai selesai."
            END-IF
        END-IF
    END-IF.

HAPUS-TUGAS.
    IF WS-JUMLAH = 0
        DISPLAY "Belum ada tugas."
    ELSE
        DISPLAY "Nomor tugas yang dihapus> " WITH NO ADVANCING
        ACCEPT WS-PILIHAN-RAW
        PERFORM PARSE-NOMOR
        IF WS-VALID = 'N' OR WS-NOMOR < 1 OR WS-NOMOR > WS-JUMLAH
            DISPLAY "Nomor tugas tidak valid."
        ELSE
            PERFORM VARYING WS-J FROM WS-NOMOR BY 1
                    UNTIL WS-J >= WS-JUMLAH
                MOVE WS-ENTRI-TUGAS(WS-J + 1)
                    TO WS-ENTRI-TUGAS(WS-J)
            END-PERFORM
            SUBTRACT 1 FROM WS-JUMLAH
            PERFORM SIMPAN-TUGAS
            DISPLAY "Tugas berhasil dihapus."
        END-IF
    END-IF.

MUAT-TUGAS.
    OPEN INPUT BERKAS-TUGAS
    EVALUATE WS-STATUS-BERKAS
        WHEN "00"
            PERFORM UNTIL WS-AKHIR-FILE = 'Y'
                READ BERKAS-TUGAS
                    AT END
                        MOVE 'Y' TO WS-AKHIR-FILE
                    NOT AT END
                        IF WS-JUMLAH < MAKSIMAL-TUGAS
                            ADD 1 TO WS-JUMLAH
                            MOVE CT-STATUS TO WS-STATUS-TUGAS(WS-JUMLAH)
                            MOVE CT-DESKRIPSI TO WS-DESKRIPSI-TUGAS(WS-JUMLAH)
                        END-IF
                END-READ
            END-PERFORM
            CLOSE BERKAS-TUGAS
        WHEN "35"
            CONTINUE
        WHEN OTHER
            DISPLAY "Peringatan: tidak dapat membuka tasks.dat (status "
                WS-STATUS-BERKAS ")."
    END-EVALUATE.

SIMPAN-TUGAS.
    OPEN OUTPUT BERKAS-TUGAS
    IF WS-STATUS-BERKAS = "00"
        PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-JUMLAH
            MOVE WS-STATUS-TUGAS(WS-I) TO CT-STATUS
            MOVE WS-DESKRIPSI-TUGAS(WS-I) TO CT-DESKRIPSI
            WRITE CATATAN-TUGAS
        END-PERFORM
        CLOSE BERKAS-TUGAS
    ELSE
        DISPLAY "Peringatan: tidak dapat menyimpan tugas (status "
            WS-STATUS-BERKAS ")."
    END-IF.
