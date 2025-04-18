-- ADIM 1: VERİTABANI VE HATALI KAYNAK TABLO OLUŞTURMA
CREATE DATABASE ETL_Projesi;
GO

USE ETL_Projesi;
GO

-- Eğer tablo varsa baştan oluştur
DROP TABLE IF EXISTS Musteriler;
GO

CREATE TABLE Musteriler (
    MusteriID INT,
    Ad NVARCHAR(50),
    Soyad NVARCHAR(50),
    Email NVARCHAR(100),
    Telefon VARCHAR(15),
    DogumTarihi DATE
);
GO

-- Hatalı ve eksik verilerle örnek kayıtlar
INSERT INTO Musteriler (MusteriID, Ad, Soyad, Email, Telefon, DogumTarihi) VALUES
(1, 'Ahmet', 'Yılmaz', 'ahmetyilmaz[at]mail.com', '05431234567', '1990-05-12'),
(2, NULL, 'Kaya', 'kaya@gmail.com', '0532xxxxxxx', '1985-10-30'),
(3, 'Mehmet', 'Demir', 'mehmet@gmail.com', NULL, NULL),
(4, 'Ayşe', 'Öztürk', 'ayse.ozturk@gmail.com', 'invalid_number', NULL),
(5, 'Fatma', NULL, 'fatma@gmail.com', '05001234567', '2000-01-15');
GO

-- ADIM 2: HATALARI TESPİT ETME

-- NULL alanlar
SELECT * FROM Musteriler
WHERE Ad IS NULL OR Soyad IS NULL OR Telefon IS NULL OR DogumTarihi IS NULL;

-- Geçersiz e-posta
SELECT * FROM Musteriler
WHERE Email NOT LIKE '%@%.%';

-- Bozuk telefon
SELECT * FROM Musteriler
WHERE ISNUMERIC(Telefon) = 0 OR LEN(Telefon) < 11;
GO

-- ADIM 2: VERİ TEMİZLEME İŞLEMLERİ

-- Eksik verileri düzelt
UPDATE Musteriler SET Ad = 'Bilinmiyor' WHERE Ad IS NULL;
UPDATE Musteriler SET Soyad = 'Bilinmiyor' WHERE Soyad IS NULL;
UPDATE Musteriler SET Telefon = '00000000000' WHERE Telefon IS NULL;
UPDATE Musteriler SET DogumTarihi = '2000-01-01' WHERE DogumTarihi IS NULL;

-- Email düzeltmeleri
UPDATE Musteriler
SET Email = REPLACE(Email, '[at]', '@')
WHERE Email LIKE '%[at]%';

-- Telefon düzeltmeleri
UPDATE Musteriler
SET Telefon = '05555555555'
WHERE ISNUMERIC(Telefon) = 0 OR LEN(Telefon) < 11;
GO

-- Temiz veri kontrolü
SELECT * FROM Musteriler;
GO

-- ADIM 3: TEMİZ VERİYİ YENİ TABLOYA YÜKLEME (LOAD)

-- Hedef tabloyu oluştur
DROP TABLE IF EXISTS Musteriler_Temiz;
GO

CREATE TABLE Musteriler_Temiz (
    MusteriID INT,
    Ad NVARCHAR(50),
    Soyad NVARCHAR(50),
    Email NVARCHAR(100),
    Telefon VARCHAR(15),
    DogumTarihi DATE
);
GO

-- Temiz verileri aktar
INSERT INTO Musteriler_Temiz (MusteriID, Ad, Soyad, Email, Telefon, DogumTarihi)
SELECT MusteriID, Ad, Soyad, Email, Telefon, DogumTarihi
FROM Musteriler;
GO

-- Kontrol
SELECT * FROM Musteriler_Temiz;
GO
