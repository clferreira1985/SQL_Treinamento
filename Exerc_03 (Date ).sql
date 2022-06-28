# manipulação de data

select * from cap_06.tb_bikes;

select data_inicio,
		date(data_inicio),
		timestamp(data_inicio),
		year(data_inicio),
		month(data_inicio),
		day(data_inicio)
from cap_06.tb_bikes
where numero_estacao_inicio = 31000;

#extraindo o mês da data

select 
	extract(month from data_inicio) as mes, 
    month(data_inicio),
    duracao_segundos
from cap_06.tb_bikes
where numero_estacao_inicio = 31000;

# adicionando 10 dias à data de início

select	
	data_inicio,
    date_add(data_inicio, interval 10 day) as data_inicio,
    duracao_segundos
from cap_06.tb_bikes
where numero_estacao_inicio = 31000;

# Retornando dados de 10 dias anteriores à data de inicio do aluguel da bike
select data_inicio,
		duracao_segundos
from cap_06.tb_bikes
where date_sub("2012-01-31", interval 10 day) <= data_inicio
and numero_estacao_inicio = 31000;

    