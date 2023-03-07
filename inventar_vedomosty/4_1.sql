declare 
	a_call varchar2(2000);
begin	
  message('���� ������������...',NO_ACKNOWLEDGE);
  
  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'BUSY');

  --���� ���� ����� ���������� �� ������ ������� ��������� �� ��������� �� JASPER �����

  if
    get_const(102)is not null
  then
a_call:='start "" "'||get_const(102,1)||'INVENTAR_BEDOMOSTY&_repFormat=pdf&_dataSource='||get_const(102,2)
            ||'&P_DAT_N='||to_char(:b10.v_dat_n_10, 'dd.mm.rrrr')
            ||'&P_DAT_K='||to_char(last_day(:b10.v_dat_k_10)+1, 'dd.mm.rrrr')
            ||'&V_DAT_N='||to_char(:b10.v_dat_y_n_10, 'dd.mm.rrrr')
            ||'&V_DAT_K='||to_char(last_day(:b10.v_dat_y_k_10)+1, 'dd.mm.rrrr')
            ||'&P_SECTOR_KOD='||nvl(:b10.V_SECTOR_KOD_10, '-1')
            ||'&P_RAION_KOD='||:b10.V_KSK_KOD_10
            ||'&P_ULICA_KOD='||nvl(:b10.V_ULICA_KOD_10, '-1')
            ||'&P_DOM='||nvl(:b10.V_DOM_10, '-1')
            ||'"';
    host(a_call, NO_SCREEN);
    
    message('������������ ���������. ������ ������...');
    
  else
    message('��� ���������� �  Jasper �������!');
    message('��� ���������� �  Jasper �������!');
    raise form_trigger_failure;
  end if;
  
	SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
end;