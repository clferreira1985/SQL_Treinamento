create schema cap_06;

create table cap_06.tb_vendas (
	nome_funcionario varchar(50) not null,
    ano_fiscal int not null,
    valor_venda decimal(14,2) not null,
    primary key(nome_funcionario, ano_fiscal)
    );
    
insert into 
cap_06.tb_vendas(nome_funcionario, ano_fiscal, valor_venda)
values("Romario", 2020,2000),
	("Romario", 2021,2500),
    ("Romario", 2022,3000),
    ("Zico", 2020,1500),
    ("Zico", 2021,1000),
    ("Zico", 2022,2000),
    ("Pele", 2020,2000),
    ("Pele", 2021,1500),
    ("Pele", 2022,2500);
    
# total de vendas por ano, por funcionário e total de vendas do ano

select
	ano_fiscal, 
    nome_funcionario,
    valor_venda,
    sum(valor_venda) over (partition by ano_fiscal) total_vendas_ano
from
cap_06.tb_vendas
order by ano_fiscal;

# Total de vendas por ano, por funcioário e total de vendas do ano

select
	ano_fiscal, 
    nome_funcionario,
    valor_venda,
    sum(valor_venda) over () total_vendas_ano
from
cap_06.tb_vendas
order by ano_fiscal;

#Subquery no lugar da função window

select
	ano_fiscal, 
    nome_funcionario,
    count(*) num_vendas_ano,
    (select count(*) from cap_06.tb_vendas) as num_vendas_geral
from cap_06.tb_vendas
group by ano_fiscal, nome_funcionario
order by ano_fiscal;