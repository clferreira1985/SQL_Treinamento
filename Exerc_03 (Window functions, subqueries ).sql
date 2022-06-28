# Duração total do aluguel das bikes (em horas), ao longo do tempo, por estação de início do aluguel da bike

select 
duracao_segundos,
sum(duracao_segundos/60/60) over (order by data_inicio) as duracao_total_horas
from
cap_06.tb_bikes;

#quando a data de´início foi inferior a 2012-01-08

select 
estacao_inicio,
duracao_segundos,
sum(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as tempo_total_horas
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

# Qual a média de tempo (em horas) de aluguel de bike da estação de iício 31017?

select
estacao_inicio,
avg(duracao_segundos/60/60) as media_tempo_aluguel
from cap_06.tb_bikes
where numero_estacao_inicio = 31017
group by estacao_inicio;

# Qual a média de tempo (em horas)de aluguel da estação de início 31017 ao longo do tempo (média móvel)?

select
estacao_inicio,
avg(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as media_tempo_aluguel
from cap_06.tb_bikes
where numero_estacao_inicio = 31017;

# Estação de início, data de início e duração de cada aluguel de bike em segundos
# Duração total de aluguel das bikes ao longo do  por estação de início
# Duração média do aluguel de bikes ao longo do tempo por estacao de início
# Número de aluguéis de bikes por estação ao longo do tempo
# somente os registros quando a dta de início for inferior a "2012-01-08

# Esta query calcula estatística, ao longo do tempo!

select 
	estacao_inicio,
    data_inicio,
    duracao_segundos,
    sum(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as duracao_total_aluguel,
    avg(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as media_tempo_aluguel,
    count(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as numero_alugueis
from cap_06.tb_bikes
where data_inicio < '2012-01-08';

# Estação de incio, data de inicio de cada aluguel de bike e duração de cada aluguel em segundos
# Número de alugueis de bike (independente da estação) ao longo do tempo
# somente os registros quando a data de início for inferior a 2012 01 08

#solucao 1
select 
	estacao_inicio,
    data_inicio,
    duracao_segundos,
    count(duracao_segundos/60/60) over (order by data_inicio) as numero_alugueis
from cap_06.tb_bikes
where data_inicio < "2012-01-08";

#solucao 2

select 
	estacao_inicio,
    data_inicio,
    duracao_segundos,
    row_number() over (order by data_inicio) as numero_alugueis
from cap_06.tb_bikes
where data_inicio < "2012-01-08";

#solucao 3 por estação

select 
	estacao_inicio,
    data_inicio,
    duracao_segundos,
    count(duracao_segundos/60/60) over (partition by estacao_inicio order by data_inicio) as numero_alugueis
from cap_06.tb_bikes
where data_inicio < "2012-01-08";

# comparando as funções
select
	estacao_inicio,
    cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    row_number() over (partition by estacao_inicio order by cast(data_inicio as date)) as numero_alugueis,
    dense_rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as ranking_aluguel_dense_rank,
    rank() over (partition by estacao_inicio order by cast(data_inicio as date)) as ranking_aluguel_rank
from cap_06.Tb_bikes
where data_inicio < "2012-01-08"
and numero_estacao_inicio = 31000;

# NTILE
# A função NTILE é uma janela (window) que distribui linhas de uma partição ordenadas em um número predefinido

select
	estacao_inicio,
    duracao_segundos,
    row_number() over (partition by estacao_inicio order by duracao_segundos) as numero_alugueis,
    ntile(2) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_dois,
    ntile(4) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_quatro,
    ntile(5) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_cinco
from cap_06.Tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;	

select
	estacao_inicio,
    cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    row_number() over (partition by estacao_inicio order by duracao_segundos) as numero_alugueis,
    ntile(2) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_dois,
    ntile(4) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_quatro,
    ntile(16) over (partition by estacao_inicio order by duracao_segundos) as numero_grupo_dezesseis
from cap_06.Tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;	

#Lag e lead
select
	estacao_inicio,
    cast(data_inicio as date) as data_inicio,
    duracao_segundos,
	lag (duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as registro_lag,
    lead (duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as registro_lead
    from cap_06.Tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio = 31000;	

#Qual a diferença da duração do aluguel de bikes ao longo do tempo, de um registro para outro?
select estacao_inicio,
	cast(data_inicio as date) as data_inicio,
    duracao_segundos,
    duracao_segundos - lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as diferenca
from cap_06.tb_bikes
where data_inicio < '2012-01-08'
and numero_estacao_inicio =31000;

select * 
from 
		(select estacao_inicio,
		cast(data_inicio as date) as data_inicio,
		duracao_segundos,
		duracao_segundos - lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as diferenca
	from cap_06.tb_bikes
	where data_inicio < '2012-01-08'
	and numero_estacao_inicio =31000) resultado
where resultado.diferenca is not null;
