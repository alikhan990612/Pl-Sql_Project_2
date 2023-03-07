CREATE OR REPLACE procedure INFO_PO_RASHODAM_HV_KAN
(
v_dat_n date,  --Начало месяца. Пример -> 01.01.2023 
v_dat_k date   --Конец месяца.  Прмер  -> 01.05.2023
) is
kol_months number;
p_dat_n date;
p_dat_k date;
p_dat date;
begin
    kol_months:= months_between(v_dat_k,v_dat_n);                  -- Нахожу разницу месяцов, чтобы указать в цикле количество повторений
    p_dat_n:= v_dat_n;
    p_dat_k:= last_day(v_dat_n)+1;
    p_dat:= p_dat_n;
    delete from WG_INFO_PO_RASHODAM_HV_KAN;                        --Удаляю данные из временной таблицы
    FOR i IN 1..kol_months                                         --Указываю количество повторений
    loop
    delete from wk_g$dat;
    insert into wk_g$dat (dat_n, dat_k)                            --Заполняю временную таблицу нужными датами. Пример -> сначала заполняется  за январь , потом за февраль до мая. Май не входит     
    values (p_dat, (last_day(p_dat)+1));  
    insert into WG_INFO_PO_RASHODAM_HV_KAN                         --Заполняю временную таблицу через select  
    select a.kod, a.blok, a.naim, a.dom, b.kol_hv, b.kol_kan
    from
    (
    select a.kod kod, a.blok blok, a.dom dom, c.naim naim                          --Здесь находится данные о абоненте. Находится ли в архиве или нет. Название улицы и номер дому
    from wv_l_sh a 
    left join spr_t$ulica c on (c.kod = a.ulica) 
    cross join wk_g$dat d                                                          --Связал через cross join чтобы взял только за нужную дату
    where a.blok = '0' and a.dat_n <= d.dat_k - 1 and a.dat_k >= d.dat_k - 1 
    
    union all
    
    select a.kod kod, a.blok blok, a.dom naim, c.naim naim
    from wv_l_sh_log a 
    left join spr_t$ulica c on (c.kod = a.ulica) 
    cross join wk_g$dat d
    where a.blok = '0' and a.dat_n <= d.dat_k - 1 and a.dat_k >= d.dat_k - 1 
    ) a 
    left join 
    (
    select w.l_sh , sum(w.kol_hv) kol_hv, sum(w.kol_kan) kol_kan                   --Здесь находится данные о абоненте. Начисления по услугам. Количество расходов
    from wt_sost_obj w 
    cross join wk_g$dat x
    where w.dat between x.dat_n + 1 and x.dat_k
    group by w.l_sh
    
    union all 
    
    select w.l_sh, sum(w.kol_hv) kol_hv, sum(w.kol_kan) kol_kan
    from wt_sost_obj_log w 
    cross join wk_g$dat x
    where w.dat between x.dat_n + 1 and x.dat_k
    group by w.l_sh
    ) b on b.l_sh = a.kod;
        p_dat:=last_day(p_dat)+1;                                                  --Как только за январь закончится заполнения. Переходит на февраль 
    end loop;
end;
/
