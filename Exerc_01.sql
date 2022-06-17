/* o Presente dataset tem por como exercicio respodnder as questões abaixo.
1- Qual o número de hubs por cidade?
# 2- Qual o número de pedidos (orders) por status?
# 3- Qual o número de lojas (stores) por cidade dos hubs?
# 4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?
# 5- Qual tipo de driver (driver_type) fez o maior número de entregas?
# 6- Qual a distância média das entregas por tipo de driver (driver_modal)?
# 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?
# 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?
# 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?
# 10- Quantos pagamentos foram cancelados (chargeback)?
# 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?
# 12- Qual a média do valor de pagamento por método de pagamento (payment_method) 
em ordem decrescente?
# 13- Quais métodos de pagamento tiveram valor médio superior a 100?
# 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), 
segmento da loja (store_segment) e tipo de canal (channel_type)?
# 15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal 
(channel_type) teve média de valor de pedido (order_amount) maior que 450?
# 16- Qual o valor total de pedido (order_amount) por estado do hub (hub_state), 
segmento da loja (store_segment) e tipo de canal (channel_type)? Demonstre os totais 
intermediários e formate o resultado.
# 17- Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 
'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido 
(order_amount)?
# 18- Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi 
cancelado, algum hub_state teve total de valor do pedido superior a 100.000?
# 19- Em que data houve a maior média de valor do pedido (order_amount)? Dica: 
Pesquise e use a função SUBSTRING().
# 20- Em quais datas o valor do pedido foi igual a zero (ou seja, não houve venda)? Dica: 
Use a função SUBSTRING().*/

# 1- Qual o número de hubs por cidade?

select * from hubs;

select hub_city, count(hub_name) as contagem
from estudo_de_caso_01.hubs
group by hub_city
order by contagem desc;

# 2- Qual o número de pedidos (orders) por status?
select order_status, count(order_status) as Qnt_de_pedido
from
estudo_de_caso_01.orders
group by order_status
order by Qnt_de_pedido;

# 3- Qual o número de lojas (stores) por cidade dos hubs?

select
hub_city, count(store_id) as num_lojas
from
estudo_de_caso_01.hubs hubs, estudo_de_caso_01.stores stores 
where hubs.hub_id = stores.hub_id
group by hub_city
order by num_lojas desc;

# 4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?

select 
max(payment_amount) as maior_valor,
min(payment_amount) as menor_valor
from
estudo_de_caso_01.payments;

# 5- Qual tipo de driver (driver_type) fez o maior número de entregas?

select
driver_type, count(delivery_id) as num_entregas
from
estudo_de_caso_01.deliveries deliveries, estudo_de_caso_01.drivers drivers
where drivers.driver_id = deliveries.driver_id
group by driver_type
order by num_entregas desc;

# 6- Qual a distância média das entregas por tipo de driver (driver_modal)?

select
driver_modal, round(avg(delivery_distance_meters),2) as distancia_media
from
estudo_de_caso_01.deliveries, estudo_de_caso_01.drivers
where drivers.driver_id = deliveries.driver_id
group by driver_modal;

# 7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?

select
store_name, round(avg(order_amount),2) as media_pedido
from
estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores
where stores.store_id = orders.store_id
group by store_name;

# 8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?

select
coalesce(store_name, "Sem Loja"), count(order_id) as contagem
from estudo_de_caso_01.orders orders left join estudo_de_caso_01.stores stores
on stores.store_id = orders.store_id
group by store_name
order by contagem desc;

# 9- Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?

select
round(sum(order_amount),2) as total
from estudo_de_caso_01.orders orders, estudo_de_caso_01.channels channels
where channels.channel_id = orders.channel_id
and channel_name = "Food place";

# 10- Quantos pagamentos foram cancelados (chargeback)?

select
payment_status, count(payment_status) as contagem
from
estudo_de_caso_01.payments payments
where payment_status = "Chargeback"
group by payment_status;

# 11- Qual foi o valor médio dos pagamentos cancelados (chargeback)?

select
payment_status, round(avg(payment_amount),2) as contagem
from
estudo_de_caso_01.payments payments
where payment_status = "Chargeback"
group by payment_status;

# 12- Qual a média do valor de pagamento por método de pagamento (payment_method)
# em ordem decrescente?

select
payment_method, round(avg(payment_amount),2) as media_pagamento
from
estudo_de_caso_01.payments
group by payment_method
order by media_pagamento desc;

# 13- Quais métodos de pagamento tiveram valor médio superior a 100?

select
payment_method, round(avg(payment_amount),2) as media_pagamento
from
estudo_de_caso_01.payments
group by payment_method
having media_pagamento > 100
order by media_pagamento desc;

# 14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state),
# segmento da loja (store_segment) e tipo de canal (channel_type)?

select hub_state, store_segment, channel_type, round(avg(order_amount),2) as media_pedido
from estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores, 
estudo_de_caso_01.channels channels, estudo_de_caso_01.hubs hubs
where stores.store_id = orders.store_id
and channels.channel_id = orders.channel_id
and hubs.hub_id = stores.hub_id
group by hub_state, store_segment, channel_type
order by hub_state;

# 15- Qual estado do hub (hub_state), segmento da loja (store_segment)
# e tipo de canal (channel_type) teve média de valor de pedido (order_amount) maior que 450?

select hub_state, store_segment, channel_type, round(avg(order_amount),2) as media_pedido
from estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores, 
estudo_de_caso_01.channels channels, estudo_de_caso_01.hubs hubs
where stores.store_id = orders.store_id
and channels.channel_id = orders.channel_id
and hubs.hub_id = stores.hub_id
group by hub_state, store_segment, channel_type
having media_pedido > 450
order by hub_state;

# 16- Qual o valor total de pedido (order_amount) por estado do hub (hub_state), 
# segmento da loja (store_segment) e tipo de canal (channel_type)? Demonstre os totais 
# intermediários e formate o resultado.

select
	if (grouping(hub_state), "Total Hub State", hub_state) as hub_state,
    if (grouping(store_segment), "Total Segmento", store_segment) as store_segment,
    if (grouping(channel_type), "total Tipo de Canal", channel_type) as channel_type,
    round(sum(order_amount),2) total_pedido
from estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores,
estudo_de_caso_01.channels channels, estudo_de_caso_01.hubs hubs
where stores.store_id = orders.store_id
and channels.channel_id = orders.store_id
and hubs.hub_id = stores.hub_id
group by hub_state, store_segment, channel_type with rollup; 

# 17- Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 
# 'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido 
# (order_amount)?

select hub_state, store_segment, channel_type, round(avg(order_amount),2) as media_pedido
from estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores, 
estudo_de_caso_01.channels channels, estudo_de_caso_01.hubs hubs
where stores.store_id = orders.store_id
and channels.channel_id = orders.channel_id
and hubs.hub_id = stores.hub_id
and order_status = "canceled"
and store_segment = "Food"
and channel_type = "marketplace"
and hub_state = "RJ"
group by hub_state, store_segment, channel_type;

# 18- Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi 
# cancelado, algum hub_state teve total de valor do pedido superior a 100.000?

select hub_state, store_segment, channel_type, round(avg(order_amount),2) as total_pedido
from estudo_de_caso_01.orders orders, estudo_de_caso_01.stores stores, 
estudo_de_caso_01.channels channels, estudo_de_caso_01.hubs hubs
where stores.store_id = orders.store_id
and channels.channel_id = orders.channel_id
and hubs.hub_id = stores.hub_id
and order_status = "canceled"
and store_segment = "Food"
and channel_type = "marketplace"
and hub_state = "RJ"
group by hub_state, store_segment, channel_type
having total_pedido > 100000;

# 19- Em que data houve a maior média de valor do pedido (order_amount)? Dica: 
# Pesquise e use a função SUBSTRING().

select substring(order_moment_created, 1, 9) as data_pedido, round(avg(order_amount),2) as media_pedido
from estudo_de_caso_01.orders orders
group by data_pedido
order by media_pedido desc;

# 20- Em quais datas o valor do pedido foi igual a zero (ou seja, não houve venda)? Dica: 
# Use a função SUBSTRING().

select substring(order_moment_created, 1, 9) as data_pedido, min(order_amount) as min_pedido
from estudo_de_caso_01.orders orders
group by data_pedido
having min_pedido = 0
order by data_pedido asc;






