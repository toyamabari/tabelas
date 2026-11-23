-- 1.3 Qual foi o primeiro ano de cerimônia do Oscar registrado na base?

SELECT MIN(ano_cerimonia) AS primeiro_ano_cerimonia
FROM indicados_ao_oscar;

-- 1.4 Qual foi o último ano de cerimônia registrado na base?

SELECT MAX(ano_cerimonia) AS ultimo_ano_cerimonia
FROM indicados_ao_oscar;

-- 1.5 Quantas cerimônias do Oscar estão registradas no total?

SELECT COUNT(DISTINCT edicao_cerimonia) AS total_cerimonias
FROM indicados_ao_oscar;

-- 1.6 Atualize os registros da tabela com os dados do Oscar 2025 e 2026 (pesquise os vencedores e adicione-os).

-- 97ª Cerimônia (2025 - filmes de 2024)
INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES
(2024, 2025, 97, 'BEST PICTURE', 'Alex Coco, Samantha Quan, and Sean Baker', 'Anora', TRUE),
(2024, 2025, 97, 'DIRECTING', 'Sean Baker', 'Anora', TRUE),
(2024, 2025, 97, 'ACTOR IN A LEADING ROLE', 'Adrien Brody', 'The Brutalist', TRUE),
(2024, 2025, 97, 'ACTRESS IN A LEADING ROLE', 'Mikey Madison', 'Anora', TRUE),
(2024, 2025, 97, 'ACTOR IN A SUPPORTING ROLE', 'Kieran Culkin', 'A Real Pain', TRUE),
(2024, 2025, 97, 'ACTRESS IN A SUPPORTING ROLE', 'Zoe Saldaña', 'Emilia Pérez', TRUE),
(2024, 2025, 97, 'INTERNATIONAL FEATURE FILM', 'Walter Salles', 'I''m Still Here', TRUE);

-- 98ª Cerimônia (2026 - filmes de 2025)
INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES
(2025, 2026, 98, 'BEST PICTURE', 'Adam Somner, Sara Murphy, and Paul Thomas Anderson', 'One Battle After Another', TRUE),
(2025, 2026, 98, 'DIRECTING', 'Paul Thomas Anderson', 'One Battle After Another', TRUE),
(2025, 2026, 98, 'ACTOR IN A LEADING ROLE', 'Michael B. Jordan', 'Sinners', TRUE),
(2025, 2026, 98, 'ACTRESS IN A LEADING ROLE', 'Jessie Buckley', 'Hamnet', TRUE),
(2025, 2026, 98, 'ACTOR IN A SUPPORTING ROLE', 'Sean Penn', 'One Battle After Another', TRUE),
(2025, 2026, 98, 'ACTRESS IN A SUPPORTING ROLE', 'Amy Madigan', 'Weapons', TRUE);

-- 2.1 Quantas indicações existem para cada categoria? Agrupe por categoria e ordene da mais frequente para a menos frequente.

SELECT categoria, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
GROUP BY categoria
ORDER BY total_indicacoes DESC;

-- 2.2 Qual categoria teve mais indicações ao longo da história do Oscar?

SELECT categoria, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
GROUP BY categoria
ORDER BY total_indicacoes DESC
LIMIT 1;

-- 2.3 Qual categoria teve menos indicações ao longo da história?

SELECT categoria, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
GROUP BY categoria
ORDER BY total_indicacoes ASC
LIMIT 1;

-- 2.4 A partir de que ano a categoria "ACTRESS" deixou de existir? (Dica: procure a última cerimônia com essa categoria)

SELECT MAX(ano_cerimonia) AS ultima_cerimonia_actress,
    MAX(ano_cerimonia) + 1 AS deixou_de_existir_a_partir_de
FROM indicados_ao_oscar
WHERE categoria = 'ACTRESS';

-- 2.5 Quais categorias existiam na primeira cerimônia (1928) e não existem mais hoje?

SELECT DISTINCT categoria
FROM indicados_ao_oscar
WHERE edicao_cerimonia = (SELECT MIN(edicao_cerimonia) FROM indicados_ao_oscar)
AND categoria NOT IN (
    SELECT DISTINCT categoria
    FROM indicados_ao_oscar
    WHERE edicao_cerimonia = (SELECT MAX(edicao_cerimonia) FROM indicados_ao_oscar)
);

-- 2.6 Liste todas as categorias que contêm a palavra "DIRECTING" no nome.

SELECT DISTINCT categoria
FROM indicados_ao_oscar
WHERE categoria LIKE '%DIRECTING%';

-- 3.1 Quantas vezes Natalie Portman foi indicada ao Oscar?

SELECT COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Natalie Portman%';

-- 3.2 Quantos Oscars Natalie Portman ganhou?

SELECT COUNT(*) AS total_vitorias
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Natalie Portman%'
AND vencedor = TRUE;

-- 3.3 Em quais anos e por quais filmes Natalie Portman foi indicada?

SELECT DISTINCT ano_cerimonia, nome_filme
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Natalie Portman%'
ORDER BY ano_cerimonia;

-- 3.4 Liste todas as indicações de Natalie Portman mostrando: ano, categoria, filme e se venceu.

SELECT ano_cerimonia, categoria, nome_filme, vencedor
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Natalie Portman%'
ORDER BY ano_cerimonia;

-- 3.5 Quantas vezes Viola Davis foi indicada ao Oscar?

SELECT COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Viola Davis%';

-- 3.6 Quantos Oscars Viola Davis ganhou?

SELECT COUNT(*) AS total_vitorias
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Viola Davis%'
AND vencedor = TRUE;

-- 3.7 Por quais filmes Viola Davis foi indicada?

SELECT DISTINCT nome_filme
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Viola Davis%';

-- 3.8 Amy Adams já ganhou algum Oscar?

SELECT CASE WHEN COUNT(*) > 0 THEN 'Sim' ELSE 'Não' END AS ganhou_oscar
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Amy Adams%'
AND vencedor = TRUE;

-- 3.9 Quantas vezes Amy Adams foi indicada sem ganhar?

SELECT COUNT(*) AS indicacoes_sem_vitoria
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Amy Adams%'
AND vencedor = FALSE;

-- 3.10 Denzel Washington já ganhou algum Oscar?

SELECT CASE WHEN COUNT(*) > 0 THEN 'Sim' ELSE 'Não' END AS ganhou_oscar
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Denzel Washington%'
AND vencedor = TRUE;

-- 3.11 Quantas vezes Denzel Washington foi indicado ao Oscar?

SELECT COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Denzel Washington%';

-- 3.12 Liste todos os Oscars que Denzel Washington ganhou (ano, categoria, filme).

SELECT ano_cerimonia, categoria, nome_filme
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Denzel Washington%'
AND vencedor = TRUE
ORDER BY ano_cerimonia;

-- 4.1 Quem ganhou o primeiro Oscar para Melhor Atriz (ACTRESS)? Em que ano e por qual filme?

SELECT nome_indicado, ano_cerimonia, nome_filme
FROM indicados_ao_oscar
WHERE categoria = 'ACTRESS'
AND vencedor = TRUE
ORDER BY ano_cerimonia ASC, edicao_cerimonia ASC
LIMIT 1;

-- 4.2 Quem ganhou o primeiro Oscar para Melhor Ator (ACTOR)? Em que ano e por qual filme?

SELECT nome_indicado, ano_cerimonia, nome_filme
FROM indicados_ao_oscar
WHERE categoria = 'ACTOR'
AND vencedor = TRUE
ORDER BY ano_cerimonia ASC, edicao_cerimonia ASC
LIMIT 1;

-- 4.3 Quantos vencedores existem ao todo na base de dados?

SELECT COUNT(*) AS total_vencedores
FROM indicados_ao_oscar
WHERE vencedor = TRUE;

-- 4.4 Liste todos os filmes que ganharam o Oscar de Melhor Filme (categoria "OUTSTANDING PICTURE" ou "BEST PICTURE").

SELECT DISTINCT nome_filme, ano_cerimonia, categoria
FROM indicados_ao_oscar
WHERE categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE')
AND vencedor = TRUE
ORDER BY ano_cerimonia;

-- 4.5 Quantos filmes diferentes já ganharam o Oscar?

SELECT COUNT(DISTINCT nome_filme) AS filmes_diferentes_vencedores
FROM indicados_ao_oscar
WHERE vencedor = TRUE
AND nome_filme IS NOT NULL;

-- 5.1 Quais atores/atrizes foram indicados mais de uma vez? Liste o nome e o número de indicações.

SELECT nome_indicado, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
HAVING COUNT(*) > 1
ORDER BY total_indicacoes DESC;

-- 5.2 Qual ator ou atriz tem o maior número de indicações na história do Oscar?

SELECT nome_indicado, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
ORDER BY total_indicacoes DESC
LIMIT 1;

-- 5.3 Quais atores foram indicados mais de 3 vezes, mas nunca ganharam?

SELECT nome_indicado,
    COUNT(*) AS total_indicacoes,
    SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) AS total_vitorias
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
HAVING COUNT(*) > 3
AND SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) = 0
ORDER BY total_indicacoes DESC;

-- 5.4 Encontre todos os artistas que foram indicados em categorias diferentes (ex: ator e diretor).

SELECT nome_indicado,
    COUNT(DISTINCT categoria) AS qtd_categorias,
    GROUP_CONCAT(DISTINCT categoria ORDER BY categoria SEPARATOR ' | ') AS categorias
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
HAVING COUNT(DISTINCT categoria) > 1
ORDER BY qtd_categorias DESC;

-- 5.5 Quantos indicados têm exatamente 1 indicação na história?

SELECT COUNT(*) AS indicados_com_uma_indicacao
FROM (
    SELECT nome_indicado
    FROM indicados_ao_oscar
    WHERE nome_indicado IS NOT NULL
    GROUP BY nome_indicado
    HAVING COUNT(*) = 1
) AS sub;

-- 5.6 Qual o maior números de indicados em um único ano? Essa é uma pergunta franca.

SELECT ano_cerimonia, COUNT(*) AS total_indicados
FROM indicados_ao_oscar
GROUP BY ano_cerimonia
ORDER BY total_indicados DESC
LIMIT 1;

-- 6.1 A série de filmes Toy Story ganhou Oscars em quais anos?

SELECT DISTINCT ano_cerimonia, nome_filme, categoria
FROM indicados_ao_oscar
WHERE nome_filme LIKE '%Toy Story%'
AND vencedor = TRUE
ORDER BY ano_cerimonia;

-- 6.2 Quantas indicações a franquia Toy Story recebeu no total?

SELECT COUNT(*) AS total_indicacoes_toy_story
FROM indicados_ao_oscar
WHERE nome_filme LIKE '%Toy Story%';

-- 6.3 Em quais categorias os filmes Toy Story foram indicados?

SELECT DISTINCT categoria
FROM indicados_ao_oscar
WHERE nome_filme LIKE '%Toy Story%';

-- 6.4 Em qual edição do Oscar o filme "Crash" concorreu?

SELECT DISTINCT edicao_cerimonia, ano_cerimonia, nome_filme
FROM indicados_ao_oscar
WHERE nome_filme = 'Crash';

-- 6.5 Quantas indicações o filme "Crash" recebeu?

SELECT COUNT(*) AS total_indicacoes_crash
FROM indicados_ao_oscar
WHERE nome_filme = 'Crash';

-- 6.6 "Crash" ganhou o Oscar de Melhor Filme?

SELECT CASE WHEN COUNT(*) > 0 THEN 'Sim' ELSE 'Não' END AS ganhou_melhor_filme
FROM indicados_ao_oscar
WHERE nome_filme = 'Crash'
AND categoria IN ('BEST PICTURE', 'OUTSTANDING PICTURE')
AND vencedor = TRUE;

-- 6.7 O filme "Central do Brasil" aparece no banco de dados?

SELECT CASE WHEN COUNT(*) > 0 THEN 'Sim' ELSE 'Não' END AS aparece_no_banco,
    COUNT(*) AS total_registros
FROM indicados_ao_oscar
WHERE nome_filme = 'Central do Brasil';

-- 6.8 Se sim, quantas indicações "Central do Brasil" recebeu?

SELECT COUNT(*) AS total_indicacoes_central
FROM indicados_ao_oscar
WHERE nome_filme = 'Central do Brasil';

-- 7.1 No campo "vencedor", altere todos os valores "true" (string) para true (booleano) e "false" (string) para false (booleano).

UPDATE indicados_ao_oscar
SET vencedor = CASE
    WHEN LOWER(CAST(vencedor AS CHAR)) = 'true' THEN TRUE
    WHEN LOWER(CAST(vencedor AS CHAR)) = 'false' THEN FALSE
    ELSE vencedor
END;

-- 7.2 Inclua no banco 3 filmes que nunca foram nomeados ao Oscar, mas que você acha que merecem. Use dados fictícios, mas realistas.

INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES
(2023, 2024, 96, 'BEST PICTURE', 'Clara Mendes', 'O Último Trem da Madrugada', FALSE),
(2022, 2023, 95, 'ORIGINAL SCREENPLAY', 'Rafael Vasconcelos', 'Cartas de Inverno', FALSE),
(2024, 2025, 97, 'CINEMATOGRAPHY', 'Lucas Ribeiro', 'Horizonte de Sal', FALSE);

-- 7.3 Adicione uma nova categoria chamada "BEST INTERNATIONAL FEATURE FILM" com alguns vencedores recentes (2020-2024).

INSERT INTO indicados_ao_oscar (ano_filmagem, ano_cerimonia, edicao_cerimonia, categoria, nome_indicado, nome_filme, vencedor) VALUES
(2019, 2020, 92, 'BEST INTERNATIONAL FEATURE FILM', 'Bong Joon-ho', 'Parasite', TRUE),
(2020, 2021, 93, 'BEST INTERNATIONAL FEATURE FILM', 'Thomas Vinterberg', 'Another Round', TRUE),
(2021, 2022, 94, 'BEST INTERNATIONAL FEATURE FILM', 'Ryusuke Hamaguchi', 'Drive My Car', TRUE),
(2022, 2023, 95, 'BEST INTERNATIONAL FEATURE FILM', 'Edward Berger', 'All Quiet on the Western Front', TRUE),
(2023, 2024, 96, 'BEST INTERNATIONAL FEATURE FILM', 'Jonathan Glazer', 'The Zone of Interest', TRUE);

-- 7.4 Corrija possíveis erros de digitação nos nomes dos filmes (ex: espaços extras, caracteres especiais desnecessários).

UPDATE indicados_ao_oscar
SET nome_filme = TRIM(REGEXP_REPLACE(nome_filme, '\\s+', ' '))
WHERE nome_filme IS NOT NULL;

-- 7.5 Remova todos os registros com valor NULL no campo nome_do_filme.

DELETE FROM indicados_ao_oscar
WHERE nome_filme IS NULL;

-- 8.1 Quantas indicações aconteceram por década? Agrupe por década (1920s, 1930s, etc.) e mostre o total.

SELECT CONCAT(FLOOR(ano_cerimonia / 10) * 10, 's') AS decada,
    COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE ano_cerimonia IS NOT NULL
GROUP BY FLOOR(ano_cerimonia / 10) * 10
ORDER BY decada;

-- 8.2 Em qual década houve o maior número de indicações?

SELECT CONCAT(FLOOR(ano_cerimonia / 10) * 10, 's') AS decada,
    COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE ano_cerimonia IS NOT NULL
GROUP BY FLOOR(ano_cerimonia / 10) * 10
ORDER BY total_indicacoes DESC
LIMIT 1;

-- 8.3 Como o número de categorias evoluiu ao longo dos anos? Mostre quantas categorias únicas existiam a cada década.

SELECT CONCAT(FLOOR(ano_cerimonia / 10) * 10, 's') AS decada,
    COUNT(DISTINCT categoria) AS categorias_unicas
FROM indicados_ao_oscar
WHERE ano_cerimonia IS NOT NULL
GROUP BY FLOOR(ano_cerimonia / 10) * 10
ORDER BY decada;

-- 8.4 Qual foi o ano com o maior número de indicações registradas?

SELECT ano_cerimonia, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE ano_cerimonia IS NOT NULL
GROUP BY ano_cerimonia
ORDER BY total_indicacoes DESC
LIMIT 1;

-- 8.5 Calcule a taxa de crescimento de indicações comparando a primeira década com a última.

WITH por_decada AS (
    SELECT FLOOR(ano_cerimonia / 10) * 10 AS decada_num,
        COUNT(*) AS total
    FROM indicados_ao_oscar
    WHERE ano_cerimonia IS NOT NULL
    GROUP BY FLOOR(ano_cerimonia / 10) * 10
)
SELECT primeira.decada_num AS primeira_decada,
        primeira.total AS indicacoes_primeira,
        ultima.decada_num AS ultima_decada,
        ultima.total AS indicacoes_ultima,
       ROUND(((ultima.total - primeira.total) / NULLIF(primeira.total, 0)) * 100, 2) AS taxa_crescimento_pct
FROM por_decada primeira
JOIN por_decada ultima
ON primeira.decada_num = (SELECT MIN(decada_num) FROM por_decada)
AND ultima.decada_num  = (SELECT MAX(decada_num) FROM por_decada);

-- 9.1 Sidney Poitier foi o primeiro ator negro a ser indicado ao Oscar. Em que ano ele foi indicado? Por qual filme?

SELECT ano_cerimonia, ano_filmagem, categoria, nome_filme, vencedor
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Sidney Poitier%'
ORDER BY ano_cerimonia ASC
LIMIT 1;

-- 9.2 Sidney Poitier ganhou o Oscar nessa indicação?

SELECT ano_cerimonia, nome_filme, vencedor
FROM indicados_ao_oscar
WHERE nome_indicado LIKE '%Sidney Poitier%'
ORDER BY ano_cerimonia ASC
LIMIT 1;

-- 9.3 Quantos atores/atrizes negros foram indicados na categoria ACTOR ou ACTRESS antes de 1970?

SELECT DISTINCT nome_indicado, ano_cerimonia, categoria, nome_filme, vencedor
FROM indicados_ao_oscar
WHERE categoria IN ('ACTOR', 'ACTRESS')
AND ano_cerimonia < 1970
ORDER BY ano_cerimonia;

-- 9.4 Liste todos os filmes dirigidos por mulheres que ganharam algum Oscar.

SELECT DISTINCT nome_filme, nome_indicado, ano_cerimonia, categoria
FROM indicados_ao_oscar
WHERE categoria LIKE '%DIRECTING%'
AND vencedor = TRUE
ORDER BY ano_cerimonia;

-- 9.5 Denzel Washington e Jamie Foxx já concorreram ao Oscar no mesmo ano?
-- 9.6 Se sim, em qual ano e quem ganhou?

SELECT a.ano_cerimonia,
    a.categoria,
    a.nome_indicado AS indicado_1,
    a.nome_filme AS filme_1,
    a.vencedor AS venceu_1,
    b.nome_indicado AS indicado_2,
    b.nome_filme AS filme_2,
    b.vencedor AS venceu_2
FROM indicados_ao_oscar a
JOIN indicados_ao_oscar b
ON a.ano_cerimonia = b.ano_cerimonia
AND a.categoria = b.categoria
WHERE a.nome_indicado LIKE '%Denzel Washington%'
AND b.nome_indicado LIKE '%Jamie Foxx%';

-- 9.7 Encontre casos onde o mesmo filme ganhou Oscar em múltiplas categorias na mesma cerimônia. Mostre o nome do filme e quantas categorias ele venceu.

SELECT ano_cerimonia, nome_filme, COUNT(DISTINCT categoria) AS categorias_vencidas
FROM indicados_ao_oscar
WHERE vencedor = TRUE
AND nome_filme IS NOT NULL
GROUP BY ano_cerimonia, nome_filme
HAVING COUNT(DISTINCT categoria) > 1
ORDER BY categorias_vencidas DESC, ano_cerimonia;

-- 10.1 Quais filmes ganharam o Oscar de Melhor Filme ("OUTSTANDING PICTURE" ou "BEST PICTURE") e Melhor Diretor na mesma cerimônia?

SELECT DISTINCT f.ano_cerimonia, f.nome_filme
FROM indicados_ao_oscar f
JOIN indicados_ao_oscar d
ON f.ano_cerimonia = d.ano_cerimonia
AND f.nome_filme = d.nome_filme
WHERE f.categoria IN ('OUTSTANDING PICTURE', 'BEST PICTURE')
AND f.vencedor = TRUE
AND d.categoria LIKE '%DIRECTING%'
AND d.vencedor = TRUE
ORDER BY f.ano_cerimonia;

-- 10.2 Qual filme recebeu o maior número de indicações em uma única cerimônia?

SELECT ano_cerimonia, nome_filme, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_filme IS NOT NULL
GROUP BY ano_cerimonia, nome_filme
ORDER BY total_indicacoes DESC
LIMIT 1;

-- 10.3 Qual filme teve a maior taxa de conversão (porcentagem de indicações que viraram vitórias)?

SELECT nome_filme,
    COUNT(*) AS indicacoes,
    SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) AS vitorias,
       ROUND((SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS taxa_conversao_pct
FROM indicados_ao_oscar
WHERE nome_filme IS NOT NULL
GROUP BY nome_filme
HAVING COUNT(*) >= 3
ORDER BY taxa_conversao_pct DESC, vitorias DESC
LIMIT 10;

-- 10.4 Encontre atores que foram indicados em anos consecutivos. Liste o nome e os anos.

SELECT DISTINCT a.nome_indicado,
    a.ano_cerimonia AS ano_1,
    b.ano_cerimonia AS ano_2,
    a.nome_filme AS filme_1,
    b.nome_filme AS filme_2
FROM indicados_ao_oscar a
JOIN indicados_ao_oscar b
ON a.nome_indicado = b.nome_indicado
AND b.ano_cerimonia = a.ano_cerimonia + 1
WHERE a.nome_indicado IS NOT NULL
ORDER BY a.nome_indicado, a.ano_cerimonia;

-- 10.5 Qual a média de indicações por cerimônia ao longo da história?

SELECT ROUND(COUNT(*) / COUNT(DISTINCT edicao_cerimonia), 2) AS media_indicacoes_por_cerimonia
FROM indicados_ao_oscar;

-- 10.6 Identifique "surpresas" - indicados em categorias principais (ACTOR, ACTRESS, BEST PICTURE) cujo filme só teve uma indicação.

SELECT i.ano_cerimonia, i.categoria, i.nome_indicado, i.nome_filme, i.vencedor
FROM indicados_ao_oscar i
WHERE i.categoria IN ('ACTOR', 'ACTRESS', 'BEST PICTURE')
AND i.nome_filme IN (
    SELECT nome_filme
    FROM indicados_ao_oscar
    WHERE nome_filme IS NOT NULL
    GROUP BY nome_filme
    HAVING COUNT(*) = 1
)
ORDER BY i.ano_cerimonia;

-- 11.1 Crie um ranking dos 10 filmes mais premiados da história (que ganharam mais Oscars).

SELECT nome_filme, COUNT(*) AS total_oscar
FROM indicados_ao_oscar
WHERE vencedor = TRUE
AND nome_filme IS NOT NULL
GROUP BY nome_filme
ORDER BY total_oscar DESC, nome_filme ASC
LIMIT 10;

-- 11.2 Crie um ranking dos 10 artistas (atores/diretores) mais indicados da história, independente da categoria.

SELECT nome_indicado, COUNT(*) AS total_indicacoes
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
ORDER BY total_indicacoes DESC, nome_indicado ASC
LIMIT 10;

-- 11.3 Encontre "azarões" - artistas com mais de 5 indicações e 0 vitórias.

SELECT nome_indicado,
    COUNT(*) AS total_indicacoes,
    SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) AS total_vitorias
FROM indicados_ao_oscar
WHERE nome_indicado IS NOT NULL
GROUP BY nome_indicado
HAVING COUNT(*) > 5
AND SUM(CASE WHEN vencedor = TRUE THEN 1 ELSE 0 END) = 0
ORDER BY total_indicacoes DESC;

-- 11.4 Qual categoria tem a maior concentração de vitórias (menos vencedores diferentes ao longo do tempo)?

SELECT categoria,
    COUNT(DISTINCT nome_indicado) AS vencedores_distintos,
    COUNT(*) AS total_vitorias
FROM indicados_ao_oscar
WHERE vencedor = TRUE
AND nome_indicado IS NOT NULL
GROUP BY categoria
ORDER BY vencedores_distintos ASC, total_vitorias DESC
LIMIT 1;

-- 11.5 Calcule a "competitividade" de cada categoria (média de indicados por cerimônia).

SELECT categoria,
    ROUND(COUNT(*) / COUNT(DISTINCT edicao_cerimonia), 2) AS media_indicados_por_cerimonia
FROM indicados_ao_oscar
GROUP BY categoria
ORDER BY media_indicados_por_cerimonia DESC;

-- 11.6 Encontre filmes que foram indicados em uma categoria em um ano e ganharam em outra categoria em outro ano.

SELECT DISTINCT i.nome_filme,
    i.ano_cerimonia AS ano_indicacao,
    i.categoria AS categoria_indicacao,
    v.ano_cerimonia AS ano_vitoria,
    v.categoria AS categoria_vitoria
FROM indicados_ao_oscar i
JOIN indicados_ao_oscar v
ON i.nome_filme = v.nome_filme
WHERE i.nome_filme IS NOT NULL
AND v.vencedor = TRUE
AND i.ano_cerimonia <> v.ano_cerimonia
AND i.categoria <> v.categoria
ORDER BY i.nome_filme, i.ano_cerimonia;