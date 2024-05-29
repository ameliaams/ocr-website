-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Bulan Mei 2024 pada 05.34
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 8.1.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `posyandu_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `balita`
--

CREATE TABLE `balita` (
  `id_balita` int(11) NOT NULL,
  `nama_balita` varchar(50) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `tgl_lahir` date NOT NULL,
  `umur` int(11) NOT NULL,
  `nama_ortu` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `balita`
--

INSERT INTO `balita` (`id_balita`, `nama_balita`, `jenis_kelamin`, `tgl_lahir`, `umur`, `nama_ortu`) VALUES
(1, 'Ryuka Artawijaya', 'L', '2019-07-16', 58, 'Nuraini'),
(2, 'M. Arsya', 'L', '2019-08-15', 56, 'Ratna'),
(3, 'Daffa Nazriel', 'L', '2019-10-30', 54, 'Dewi'),
(4, 'Razka Putra', 'L', '2019-11-23', 53, 'Selvi'),
(5, 'M. Wafi Widi', 'L', '2021-03-24', 37, 'Sulis'),
(6, 'Muwahidin', 'L', '2021-04-13', 36, 'Wahyu'),
(7, 'M. Elfatan', 'L', '2021-05-08', 35, 'Ratna'),
(8, 'Azfeer Haidar', 'L', '2021-05-11', 35, 'Devi'),
(9, 'M. Rafif', 'L', '2021-09-12', 31, 'Nurul'),
(10, 'M. Elvano H', 'L', '2022-01-02', 27, 'Selvi'),
(11, 'M. Fadhil I', 'L', '2022-03-09', 25, 'Dewi'),
(12, 'Rajendra', 'L', '2022-04-12', 24, 'Indah'),
(13, 'Wahyu Abiseka', 'L', '2023-01-10', 15, 'Riyanti'),
(14, 'Alvaro Dirga', 'L', '2023-02-20', 14, 'Zahro'),
(15, 'M. Fatih A', 'L', '2023-03-15', 13, 'Khomariah'),
(16, 'Nazriel Arrifai', 'L', '2023-07-20', 9, 'Cahyanti'),
(17, 'Arshan Rafaeza', 'L', '2023-12-10', 4, 'Ayu Diah'),
(18, 'M. Khalif', 'L', '2024-01-26', 3, 'Zumaisa'),
(19, 'Yufika Zanitha', 'P', '2019-04-09', 60, 'Lalita'),
(20, 'Sakila Aulia Putri', 'P', '2019-06-20', 58, 'Riyanti'),
(21, 'Azkia Faniza A.', 'P', '2019-07-20', 57, 'Astuti'),
(22, 'Ayudisa B', 'P', '2019-09-08', 55, 'Dina'),
(23, 'Anindita Putri', 'P', '2020-03-03', 49, 'Zahro'),
(24, 'Luvia', 'P', '2020-03-11', 49, 'Khomsi'),
(25, 'Nayara Kirana', 'P', '2020-07-13', 45, 'Zumaisa'),
(26, 'Qiana Misha', 'P', '2020-09-11', 43, 'Ariani'),
(27, 'Felycia A', 'P', '2021-06-28', 34, 'Fitri'),
(28, 'Keysha', 'P', '2021-07-29', 33, 'Geofani'),
(29, 'Eka Septiana', 'P', '2021-09-01', 31, 'Desy'),
(30, 'Aurelia B', 'P', '2021-10-28', 30, 'Ayu'),
(31, 'Ayunda', 'P', '2022-05-29', 23, 'Putri'),
(32, 'Arshvree Azehra', 'P', '2022-12-02', 16, 'Arlinda'),
(33, 'Hana Syita N', 'P', '2023-01-14', 15, 'Vina'),
(34, 'Anindita Putri', 'P', '2023-03-14', 13, 'Lalita'),
(35, 'Kayla Almaira', 'P', '2023-06-21', 10, 'Haqiy'),
(36, 'Nabila Arsyla', 'P', '2023-09-18', 7, 'Dewi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengukuran`
--

CREATE TABLE `pengukuran` (
  `id_pengukuran` int(11) NOT NULL,
  `id_balita` int(11) NOT NULL,
  `nama_balita` varchar(50) NOT NULL,
  `tinggi_badan` float DEFAULT NULL,
  `berat_badan` float DEFAULT NULL,
  `lingkar_kepala` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `pengukuran`
--

INSERT INTO `pengukuran` (`id_pengukuran`, `id_balita`, `nama_balita`, `tinggi_badan`, `berat_badan`, `lingkar_kepala`) VALUES
(16, 14, 'Alvaro Dirga', 39.13, 14.5, '46.01'),
(17, 30, 'Aurelia B', 47.2, 11.02, '43'),
(18, 19, 'Yufika Zanitha', 63, 0.09, '0'),
(19, 31, 'Ayunda', 88887, 4.63, '0'),
(20, 16, 'Nazriel Arrifai', 683.7, 7.39, '0'),
(21, 1, 'Ryuka Artawijaya', 8.7, 4.465, '0');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `balita`
--
ALTER TABLE `balita`
  ADD PRIMARY KEY (`id_balita`);

--
-- Indeks untuk tabel `pengukuran`
--
ALTER TABLE `pengukuran`
  ADD PRIMARY KEY (`id_pengukuran`),
  ADD KEY `fk_balita` (`id_balita`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `balita`
--
ALTER TABLE `balita`
  MODIFY `id_balita` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT untuk tabel `pengukuran`
--
ALTER TABLE `pengukuran`
  MODIFY `id_pengukuran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pengukuran`
--
ALTER TABLE `pengukuran`
  ADD CONSTRAINT `fk_balita` FOREIGN KEY (`id_balita`) REFERENCES `balita` (`id_balita`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
