select
	p01 ULICA,
	p02 DOM,
          to_number(p03) KV,
          to_number(p04) PRIZNAK_HV_D,
          to_number(p05) PRIZNAK_GV_D,
          to_number(p06) COUNT_HV_K,
          to_number(p07) COUNT_GV_K,
          to_number(p08) KLAS_0,
          to_number(p09) KLAS_1,
          to_number(p10) KLAS_2,
          to_number(p11) KLAS_3,
          to_number(p12) KLAS_4,
          to_number(p13) KLAS_5,
          to_number(p14) KLAS_6,
          to_number(p15) KLAS_7,
          to_number(p16) KLAS_8,
          to_number(p17) KLAS_9,
          to_number(p18) KLAS_10,
          to_number(p19) KLAS_11,
          to_number(p20) KLAS_12,
          to_number(p21) KLAS_13,
          to_number(p22) KLAS_14,
          to_number(p23) KLAS_15,
          to_number(p24) KLAS_16,
          to_number(p25) KLAS_17,
          to_number(p26) KLAS_21,
          to_number(p27) VSEGO,
          to_number(p28) RASHOD_HV,
          to_number(p29) RASHOD_KAN
from table(jasper.jasper_table(
'
insert into wk_g$dat (dat_n, dat_k, chto)
values (to_date('''||$P{P_DAT_N}||''',''dd.mm.rrrr''), to_date('''||$P{P_DAT_K}||''',''dd.mm.rrrr''), 1);

--Запускаю процедуру передав даты как параметр

begin
INFO_PO_RASHODAM_HV_KAN(to_date('''||$P{V_DAT_N}||''',''dd.mm.rrrr''),to_date('''||$P{V_DAT_K}||''',''dd.mm.rrrr''));
end;
',
'

--После заполнения временной таблицы выбираю данные из вьюхи WV_DATA_COUNT_IPU за один месяц. А из временной таблицы WG_INFO_PO_RASHODAM_HV_KAN выбираю данные за несколько месяцов

select
a.ulica ULICA,
a.dom DOM,
count(a.kv) KV,
max(case when a.hv_vod = 2 then 1 else 0 end) PRIZNAK_HV_D,
max(case when a.gv_vod = 2 then 1 else 0 end) PRIZNAK_GV_D,
sum(case when a.hv_vod = 1 then nvl(a.count_hv,0) else 0 end) COUNT_HV_K,
sum(case when a.gv_vod = 1 then nvl(a.count_gv,0) else 0 end) COUNT_GV_K,
sum(case when a.klas = 0 then a.prop else 0 end) KLAS_0,
sum(case when a.klas = 1 then a.prop else 0 end) KLAS_1,
sum(case when a.klas = 2 then a.prop else 0 end) KLAS_2,
sum(case when a.klas = 3 then a.prop else 0 end) KLAS_3,
sum(case when a.klas = 4 then a.prop else 0 end) KLAS_4,
sum(case when a.klas = 5 then a.prop else 0 end) KLAS_5,
sum(case when a.klas = 6 then a.prop else 0 end) KLAS_6,
sum(case when a.klas = 7 then a.prop else 0 end) KLAS_7,
sum(case when a.klas = 8 then a.prop else 0 end) KLAS_8,
sum(case when a.klas = 9 then a.prop else 0 end) KLAS_9,
sum(case when a.klas = 10 then a.prop else 0 end) KLAS_10,
sum(case when a.klas = 11 then a.prop else 0 end) KLAS_11,
sum(case when a.klas = 12 then a.prop else 0 end) KLAS_12,
sum(case when a.klas = 13 then a.prop else 0 end) KLAS_13,
sum(case when a.klas = 14 then a.prop else 0 end) KLAS_14,
sum(case when a.klas = 15 then a.prop else 0 end) KLAS_15,
sum(case when a.klas = 16 then a.prop else 0 end) KLAS_16,
sum(case when a.klas = 17 then a.prop else 0 end) KLAS_17,
sum(case when a.klas = 21 then a.prop else 0 end) KLAS_21,
sum(a.prop) VSEGO,
nvl(round(avg(b.kol_hv),2),0) RASHOD_HV,
nvl(round(avg(b.kol_kan),2),0) RASHOD_KAN
from
(
select
a.l_sh l_sh,
c.naim ULICA,
b.dom DOM,
b.kv KV,
a.count_hv count_hv,
a.count_gv count_gv,
a.hv_vod hv_vod,
a.gv_vod gv_vod,
a.klas klas,
a.prop prop
from WV_DATA_COUNT_IPU a
join wv_l_sh b on (b.kod = a.l_sh and b.blok = ''0'')
left join spr_t$ulica c on (c.kod = b.ulica)
$P!{P_WHERE}
order by c.naim, b.dom
) a

left join

  (
  select l_sh, sum(kol_hv) kol_hv, sum(kol_kan) kol_kan
  from WG_INFO_PO_RASHODAM_HV_KAN
  group by l_sh
  order by l_sh
  ) b on b.l_sh = a.l_sh
group by a.ulica, a.dom
order by a.ulica, a.dom
'))