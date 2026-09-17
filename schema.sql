-- ============================================================
-- Skema Buku Hutang Piutang — jalankan ini di Supabase SQL Editor
-- (Dashboard Supabase > SQL Editor > New query > paste semua ini > Run)
-- ============================================================

create table if not exists nasabah (
  id bigint generated always as identity primary key,
  nama text not null,
  bank text not null,
  rekening text not null,
  created_at timestamptz not null default now()
);

create table if not exists transaksi (
  id bigint generated always as identity primary key,
  tanggal date not null,
  nasabah_id bigint not null references nasabah(id) on delete cascade,
  referensi text not null,
  jenis text not null check (jenis in ('debet','kredit')),
  jenis_transaksi text not null check (jenis_transaksi in ('reguler','khusus')),
  jumlah numeric not null check (jumlah > 0),
  created_at timestamptz not null default now()
);

-- Aktifkan Row Level Security (wajib di Supabase)
alter table nasabah enable row level security;
alter table transaksi enable row level security;

-- PENTING (baca catatan keamanan):
-- Policy di bawah ini membuat data bisa dibaca & ditulis oleh SIAPA SAJA yang
-- membuka alamat web-nya, karena aplikasi ini tidak punya sistem login.
-- Cocok untuk pemakaian internal/terbatas, tapi siapa pun yang tahu link-nya
-- bisa menambah atau menghapus data. Jika perlu lebih aman, tambahkan
-- autentikasi (Supabase Auth) dan ganti policy ini agar hanya mengizinkan
-- user yang sudah login.

create policy "publik baca nasabah" on nasabah for select using (true);
create policy "publik tambah nasabah" on nasabah for insert with check (true);
create policy "publik hapus nasabah" on nasabah for delete using (true);

create policy "publik baca transaksi" on transaksi for select using (true);
create policy "publik tambah transaksi" on transaksi for insert with check (true);
create policy "publik hapus transaksi" on transaksi for delete using (true);
