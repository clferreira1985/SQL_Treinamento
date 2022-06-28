# 1- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro?

select tipo_membro,
	avg(duracao_segundos) as media_tempo_aluguel
from cap_06.tb_bikes
group by tipo_membro;

# 2- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro e 
# por estação fim (onde as bikes são entregues após o aluguel)?

select estacao_fim,
	tipo_membro,
    avg(duracao_segundos) as media_tempo_aluguel
from cap_06.tb_bikes
group by estacao_fim, tipo_membro;

# 3- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro e 
# por estação fim (onde as bikes são entregues após o aluguel) ao longo do tempo?

select extract(hour from data_inicio) as hora,
	count(duracao_segundos) as num_alugueis
from cap_06.tb_bikes
where numero_bike = "W01182"
group by hora
order by num_alugueis desc;

# 4- Qual hora do dia (independente do mês) a bike de número W01182 teve o maior número de 
# aluguéis considerando a data de início?

select estacao_fim,
	tipo_membro,
    avg(duracao_segundos) over (partition by tipo_membro order by data_inicio) as media_tempo_aluguel
from cap_06.tb_bikes
group by estacao_fim, tipo_membro;

# 5- Qual o número de aluguéis da bike de número W01182 ao longo do tempo considerando a 
# data de início?

select cast(data_inicio as date) as data_inicio,
	count(duracao_segundos) over (partition by estacao_inicio order by cast(data_inicio as date)) as num_alugueis
from cap_06.tb_bikes
where numero_bike = "w01182"
group by estacao_fim, tipo_membro;

# 6- Retornar:
# Estação fim, data fim de cada aluguel de bike e duração de cada aluguel em segundos
# Número de aluguéis de bikes (independente da estação) ao longo do tempo 
# Somente os registros quando a data fim foi no mês de Abril

select estacao_fim,
	data_fim,
    duracao_segundos,
    count(duracao_segundos) over (order by data_fim) as numero_alugueis
from cap_06.tb_bikes
where extract(month from data_fim)=4;

# 7- Retornar:
# Estação fim, data fim e duração em segundos do aluguel 
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00
# Queremos a ordem (classificação ou ranking) dos dias de aluguel ao longo do tempo
# Retornar os dados para os aluguéis entre 7 e 11 da manhã

select estacao_fim,
	date_format(data_fim, "%d/%M/%Y %H:%i:%S") as data_fim,
    duracao_segundos,
    dense_rank() over (partition by estacao_fim order by cast(data_fim as date)) as ranking_aluguel
from cap_06.tb_bikes
where extract(hour from data_fim) between 07 and 11;

# 8- Qual a diferença da duração do aluguel de bikes ao longo do tempo, de um registro para 
# outro, considerando data de início do aluguel e estação de início?
# A data de início deve ser retornada no formato: Sat/Jan/12 00:00:00 (Sat = Dia da semana 
# abreviado e Jan igual mês abreviado). Retornar os dados para os aluguéis entre 01 e 03 da manhã

select estacao_fim,
	date_format(data_fim, "%a/%b/%y %H:%i:%S") as data_inicio,
    duracao_segundos,
    duracao_segundos -lag(duracao_segundos, 1) over (partition by estacao_inicio order by cast(data_inicio as date)) as diferença
from cap_06.tb_bikes
where extract(hour from data_fim) between 01 and 03;

# 9- Retornar:
# Estação fim, data fim e duração em segundos do aluguel 
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00
# Queremos os registros divididos em 4 grupos ao longo do tempo por partição
# Retornar os dados para os aluguéis entre 8 e 10 da manhã
# Qual critério usado pela função NTILE para dividir os grupos?

select estacao_fim,
	date_format(data_fim, "%d/%M/%Y %H:%i:%S") as data_fim,
    duracao_segundos,
    ntile(4) over (partition by estacao_fim order by cast(data_fim as date)) as ranking_aluguel
from cap_06.tb_bikes
where extract(hour from data_fim) between 08 and 11;

# 10- Quais estações tiveram mais de 35 horas de duração total do aluguel de bike ao longo do 
# tempo considerando a data fim e estação fim?
# Retorne os dados entre os dias '2012-01-01' e '2012-01-02'
# Dica: Use função window e subquery

select *
from 
(select estacao_fim,
	cast(data_fim as date) as data_fim,
    sum(duracao_segundos/60/60) over (partition by estacao_fim order by cast(data_fim as date)) as tempo_total_horas
from cap_06.tb_bikes
where data_fim between '2012-01-01' and '2012-01-02') resultado
where resultado.tempo_total_horas >35
order by resultado.estacao_fim;