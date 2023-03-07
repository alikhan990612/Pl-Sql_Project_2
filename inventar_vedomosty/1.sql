--Создаю временную таблицу, где будут заполняться данные по нескольким месяцам через цикл
CREATE GLOBAL TEMPORARY TABLE WG_INFO_PO_RASHODAM_HV_KAN
(
  L_SH        NUMBER,
  BLOK        VARCHAR2(10 BYTE),
  ULICA_NAIM  VARCHAR2(150 BYTE),
  DOM         VARCHAR2(20 BYTE),
  KOL_HV      NUMBER,
  KOL_KAN     NUMBER
)
ON COMMIT DELETE ROWS
NOCACHE;


--Даю грант на user JASPRI.Потому что все отчеты формируется под этим пользователем 

GRANT DELETE, SELECT, UPDATE ON WG_INFO_PO_RASHODAM_HV_KAN TO JASPRI;
