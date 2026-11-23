USE momento;

/* 1.1 Você acabou de ser contratado pela Momento! Vamos começar incluindo você no sistema.*/

DESCRIBE funcionarios;
INSERT INTO funcionarios(funcionario_id,primeiro_nome,sobrenome,email,senha,telefone,data_contratacao,cargo_id,salario,gerente_id,departamento_id)
VALUES (301,'Laís','Toyama','lais.toyama@momento.org','ToyaminhaDaGrau244!','11 96665-2666','2026-10-27',4,100000.67,NULL,9);
SHOW TABLES;

/* 1.2 Agora que você faz parte da equipe, quantos funcionários temos ao total na empresa? */

SELECT COUNT(*) AS total_funcionarios
FROM funcionarios;

/* 1.3 Quantos funcionários trabalham especificamente no Departamento de Tecnologia? */

SELECT COUNT(*) AS total_tecnologia
FROM funcionarios
WHERE departamento = 'Tecnologia';

/* 1.4 Liste todos os departamentos que existem na empresa. Quantos são? */

SELECT * FROM departamentos;

SELECT COUNT(*) AS total_departamentos
FROM departamentos;

/* 1.5 Quantos escritórios a Momento possui? Em quais países? */

SELECT COUNT(*) AS total_escritorios
FROM escritorios;

SELECT DISTINCT pais
FROM escritorios;

-- 2.1 Quantos funcionários trabalham no Departamento de Vendas?

SELECT COUNT(*) AS funcs_vendas
FROM funcionarios f
JOIN departamentos d ON d.departamento_id = f.departamento_id
WHERE d.departamento_nome = 'Vendas';

-- 2.2 Qual é o custo total com salários do Departamento de Vendas?

SELECT SUM(f.salario) AS custo_total_vendas, f.moeda_salario
FROM funcionarios f
JOIN departamentos d ON d.departamento_id = f.departamento_id
WHERE d.departamento_nome = 'Vendas'
GROUP BY f.moeda_salario;

-- 2.3 Qual é a média salarial da empresa, excluindo os cargos de CEO, CMO e CFO?

SELECT ROUND(AVG(f.salario), 2) AS media_salarial_geral
FROM funcionarios f
JOIN cargos c ON c.cargo_id = f.cargo_id
WHERE c.cargo_nome NOT IN ('CEO', 'CMO', 'CFO');

SELECT f.moeda_salario, COUNT(*) AS qtd, ROUND(AVG(f.salario), 2) AS media_salarial
FROM funcionarios f
JOIN cargos c ON c.cargo_id = f.cargo_id
WHERE c.cargo_nome NOT IN ('CEO', 'CMO', 'CFO')
GROUP BY f.moeda_salario;

-- 2.4 Qual é a média salarial do Departamento de Tecnologia?

SELECT ROUND(AVG(f.salario), 2) AS media_salarial_tecnologia
FROM funcionarios f
JOIN departamentos d ON d.departamento_id = f.departamento_id
WHERE d.departamento_nome = 'Tecnologia da Informação';

-- 2.5 Qual departamento possui a maior média salarial?

SELECT d.departamento_id, d.departamento_nome, COUNT(f.funcionario_id) AS qtd, ROUND(AVG(f.salario), 2) AS media_salarial
FROM departamentos d
JOIN funcionarios f ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY media_salarial DESC
LIMIT 1;

-- 2.6 Qual departamento possui o menor número de funcionários?

SELECT d.departamento_id, d.departamento_nome, COUNT(f.funcionario_id) AS qtd_funcionarios
FROM departamentos d
LEFT JOIN funcionarios f ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY qtd_funcionarios ASC, d.departamento_id ASC;

-- 3.1 Quantos funcionários da empresa Momento possuem cônjuges?

SELECT COUNT(DISTINCT funcionario_id) AS funcs_com_conjuge
FROM dependentes
WHERE relacionamento = 'Cônjuge';

-- 3.2 Quantos funcionários possuem filhos registrados?

SELECT COUNT(DISTINCT funcionario_id) AS funcs_com_filhos, COUNT(*) AS total_registros_filhos
FROM dependentes
WHERE relacionamento = 'Filha(o)';

-- 3.3 Qual funcionário foi contratado há mais tempo na empresa?

SELECT funcionario_id, CONCAT(primeiro_nome, ' ', sobrenome) AS nome, data_contratacao
FROM funcionarios
ORDER BY data_contratacao ASC, funcionario_id ASC
LIMIT 1;

-- 3.4 Qual funcionário foi contratado há menos tempo na empresa?

SELECT funcionario_id, CONCAT(primeiro_nome, ' ', sobrenome) AS nome, data_contratacao
FROM funcionarios
ORDER BY data_contratacao DESC, funcionario_id ASC
LIMIT 1;

-- 3.5 Liste os 5 funcionários com mais tempo de casa, ordenados pela data de contratação.

SELECT funcionario_id, CONCAT(primeiro_nome, ' ', sobrenome) AS nome, data_contratacao, cargo_id
FROM funcionarios
ORDER BY data_contratacao ASC, funcionario_id ASC
LIMIT 5;

-- 3.6 Quantos funcionários foram contratados na década de 1990 (entre 1990-1999)?

SELECT COUNT(*) AS contratados_anos_90
FROM funcionarios
WHERE YEAR(data_contratacao) BETWEEN 1990 AND 1999;

-- 3.7 Como a média salarial da Momento evoluiu ao longo dos anos? Agrupe por ano de contratação e calcule a média salarial.

SELECT YEAR(data_contratacao) AS ano_contratacao,
    COUNT(*) AS total_contratados,
    ROUND(AVG(salario), 2) AS media_salarial
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano_contratacao;

-- 4.1 Qual é o custo total de suprimentos em cada escritório? Ordene do mais caro ao mais barato.

SELECT e.escritorio_id, e.escritorio_nome,
       COALESCE(SUM(s.quantidade_estoque * s.custo_unitario), 0) AS custo_total_suprimentos
FROM escritorios e
LEFT JOIN suprimentos s ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY custo_total_suprimentos DESC;

-- 4.2 Qual escritório possui a maior quantidade de diferentes tipos de suprimentos?

SELECT e.escritorio_id, e.escritorio_nome, COUNT(DISTINCT s.suprimento_nome) AS tipos_suprimentos
FROM escritorios e
JOIN suprimentos s ON s.escritorio_id = e.escritorio_id
GROUP BY e.escritorio_id, e.escritorio_nome
ORDER BY tipos_suprimentos DESC, SUM(s.quantidade_estoque * s.custo_unitario) DESC;

-- 4.3 Qual é o suprimento mais caro (considerando preço unitário) em toda a empresa?

SELECT s.suprimento_id, s.referencia_compra, s.suprimento_nome, e.escritorio_nome, s.custo_unitario, s.moeda
FROM suprimentos s
JOIN escritorios e ON e.escritorio_id = s.escritorio_id
ORDER BY s.custo_unitario DESC
LIMIT 1;

-- 4.4 Calcule o valor total do inventário de suprimentos da empresa (quantidade × preço unitário de todos os itens em todos os escritórios).

SELECT SUM(quantidade_estoque * custo_unitario) AS valor_total_inventario, moeda
FROM suprimentos
GROUP BY moeda;

-- 5.1 Quais produtos foram vendidos pela Momento? Liste todos os produtos únicos.

SELECT DISTINCT p.produto_id, p.sku, p.produto_nome
FROM itens_venda i
JOIN produtos p ON p.produto_id = i.produto_id
ORDER BY p.produto_id;

-- 5.2 Qual é o produto mais vendido (maior quantidade total)?

SELECT p.produto_id, p.sku, p.produto_nome, SUM(i.quantidade) AS unidades_vendidas
FROM itens_venda i
JOIN produtos p ON p.produto_id = i.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
ORDER BY unidades_vendidas DESC
LIMIT 1;

-- 5.3 Qual é o produto menos vendido?

SELECT p.produto_id, p.sku, p.produto_nome, COALESCE(SUM(i.quantidade), 0) AS unidades_vendidas
FROM produtos p
LEFT JOIN itens_venda i ON i.produto_id = p.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
ORDER BY unidades_vendidas ASC, p.produto_id ASC;

-- 5.4 Pensando na relação quantidade × valor unitário, qual produto gerou mais receita para a empresa?

SELECT p.produto_id, p.sku, p.produto_nome, SUM(i.quantidade * i.preco_unitario) AS receita_total
FROM itens_venda i
JOIN produtos p ON p.produto_id = i.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
ORDER BY receita_total DESC
LIMIT 1;

-- 5.5 Qual é o produto mais caro (maior preço unitário) no catálogo?

SELECT produto_id, sku, produto_nome, preco_catalogo, moeda
FROM produtos
ORDER BY preco_catalogo DESC
LIMIT 1;

-- 5.6 Qual foi o faturamento total da empresa em vendas?

SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM itens_venda;

-- 5.7 Quantas vendas foram realizadas no mês de junho de 2023?

SELECT COUNT(*) AS vendas_junho_2023
FROM vendas
WHERE data_venda >= '2023-06-01' AND data_venda < '2023-07-01';

-- 5.8 Qual vendedor realizou mais vendas (em quantidade de transações)?

SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor, COUNT(v.venda_id) AS total_vendas
FROM vendas v
JOIN funcionarios f ON f.funcionario_id = v.funcionario_id
GROUP BY f.funcionario_id, f.primeiro_nome, f.sobrenome
ORDER BY total_vendas DESC, f.funcionario_id ASC;

-- 5.9 Qual vendedor gerou mais receita para a empresa?

SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS vendedor,
       SUM(i.quantidade * i.preco_unitario) AS receita_total
FROM vendas v
JOIN itens_venda i ON i.venda_id = v.venda_id
JOIN funcionarios f ON f.funcionario_id = v.funcionario_id
GROUP BY f.funcionario_id, f.primeiro_nome, f.sobrenome
ORDER BY receita_total DESC
LIMIT 1;

-- 6.1 Criar departamento "Inovações" em "Wayne Offices" (escritorio_id = 1400)
INSERT INTO departamentos (departamento_id, departamento_nome, educacional, escritorio_id)
VALUES (31, 'Inovações', 0, 1400);

-- 6.2 Transferir 2 funcionários de Tecnologia da Informação (dept 6) para Inovações (dept 31)
UPDATE funcionarios
SET departamento_id = 31
WHERE funcionario_id IN (106, 107); -- Valli Stark e Diana Lorentz

-- 6.3 Reajuste de 10% nos salários de quem está em Tecnologia da Informação (dept 6)
UPDATE funcionarios
SET salario = ROUND(salario * 1.10, 2)
WHERE departamento_id = 6;

-- 6.4 Promover Bruce Ernst (104) a "Senior Web Developer" (cargo_id = 26) e salário $5.000
UPDATE funcionarios
SET cargo_id = 26, salario = 5000.00
WHERE funcionario_id = 104;

-- 6.5 Adicionar 15 unidades de "Headsets" a $150 no "Wayne Offices" (1400)
INSERT INTO suprimentos (suprimento_id, referencia_compra, suprimento_nome, quantidade_estoque, custo_unitario, moeda, data_compra, escritorio_id)
VALUES (106, 'PO-1400-08', 'Headsets', 15, 150.00, 'USD', '2026-11-23', 1400);

-- 6.6 Verificar antes e remover contratados antes de 1990 (8 funcionários: 100, 101, 102, 103, 104, 105, 170, 171)
SELECT funcionario_id, primeiro_nome, sobrenome, data_contratacao
FROM funcionarios
WHERE data_contratacao < '1990-01-01';

-- 7.1 Quais cursos estão ativos? Para cada um, mostre carga horária, nível e quantas turmas já foram abertas.

SELECT c.curso_id, c.curso_nome, c.carga_horaria, nc.nome AS nivel, COUNT(t.turma_id) AS turmas_abertas
FROM cursos c
JOIN niveis_curso nc ON nc.nivel_curso_id = c.nivel_curso_id
LEFT JOIN turmas t ON t.curso_id = c.curso_id
WHERE c.ativo = 1
GROUP BY c.curso_id, c.curso_nome, c.carga_horaria, nc.nome;

-- 7.2 Para cada turma, mostre curso, professores, capacidade e número de matrículas.

SELECT t.codigo, c.curso_nome, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS professor,
    t.capacidade, COUNT(m.matricula_id) AS total_matriculas
FROM turmas t
JOIN cursos c ON c.curso_id = t.curso_id
JOIN funcionarios f ON f.funcionario_id = t.professor_funcionario_id
LEFT JOIN matriculas m ON m.turma_id = t.turma_id
GROUP BY t.turma_id, t.codigo, c.curso_nome, f.primeiro_nome, f.sobrenome, t.capacidade;

-- 7.3 Quantos estudantes receberam bolsa, qual foi o percentual concedido e em quais cursos?

SELECT a.nome AS estudante, b.percentual_desconto, c.curso_nome, b.criterio, b.data_concessao
FROM bolsas b
JOIN alunos a ON a.aluno_id = b.aluno_id
JOIN cursos c ON c.curso_id = b.curso_id;

-- 7.4 Por curso e turma, calcule matrículas, concluintes, certificados emitidos e nota média. Quais perguntas adicionais seriam necessárias antes de afirmar que um curso teve “mais sucesso” que outro?

--A view impacto_educacional já consolida matriculas, concluintes, certificados_emitidos, nota_media e talentos_vinculados. Para afirmar que um curso teve "mais sucesso" que outro, convém avaliar: taxa de evasão/conclusão por turma, evolução salarial e retenção de talentos contratados, satisfação/engajamento, tamanho da amostra (há poucas matrículas na base demonstrativa) e alinhamento entre o curso e o departamento que absorve o talento.

-- 7.5 Reconstrua a trajetória de Ariel Nunes: curso, turma, matrícula, bolsa, estágio e contratação. Em que momento a formação passou a se conectar com uma oportunidade corporativa?

-- Cadastro como aluna (2025-01-10) → bolsa de 100% (2025-01-12) → matrícula na turma TEC-2025-01 do curso Tecnologia Criativa (2025-01-15), concluída com nota 91,50 e certificado emitido.
-- Estágio (tipo_vinculo_id = 1, encerrado) de 2025-05-05 a 2025-05-11 no departamento Tecnologia da Informação (depto 6, funcionario_id = NULL no vínculo).
-- Conexão formal com oportunidade corporativa: Em 2025-05-12, quando foi contratada como Desenvolvedor Web (funcionario_id = 300, salário US$ 5.200,00, gerente 103) e registrado o vínculo de contratação (tipo_vinculo_id = 2, status ATIVO) no mesmo departamento.

-- 7.6 Liste os vínculos de talentos com estudante, tipo de vínculo, departamento, status e, quando existir, a pessoa funcionária associada. Quantas pessoas passaram por estágio e quantas chegaram à contratação?

--Há 2 registros em vinculos_talentos, ambos referentes a Ariel Nunes no departamento Tecnologia da Informação (ID 6): 1 estágio (ENCERRADO, sem funcionario_id) e 1 contratação (ATIVO, ligada ao funcionario_id = 300, Ariel Nunes). Ou seja, 1 pessoa passou por estágio e 1 pessoa chegou à contratação.

SELECT vt.vinculo_id, a.nome AS estudante, tv.nome AS tipo_vinculo, d.departamento_nome,
    sv.nome AS status_vinculo, vt.data_inicio, vt.data_fim,
    vt.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario_associado
FROM vinculos_talentos vt
JOIN alunos a ON a.aluno_id = vt.aluno_id
JOIN tipos_vinculo tv ON tv.tipo_vinculo_id = vt.tipo_vinculo_id
JOIN departamentos d ON d.departamento_id = vt.departamento_id
JOIN status_vinculo sv ON sv.status_vinculo_id = vt.status_vinculo_id
LEFT JOIN funcionarios f ON f.funcionario_id = vt.funcionario_id;

-- 7.7 Quais departamentos recebem talentos da escola?

SELECT DISTINCT d.departamento_id, d.departamento_nome
FROM vinculos_talentos vt
JOIN departamentos d ON d.departamento_id = vt.departamento_id;

-- 7.8: Crie uma única consulta que apresente: total de alunos, matrículas ativas, concluintes, bolsas concedidas, estágios, contratações e departamentos que receberam talentos.

SELECT
(SELECT COUNT(*) FROM alunos) AS total_alunos,
(SELECT COUNT(*) FROM matriculas m JOIN status_matricula sm ON sm.status_matricula_id = m.status_matricula_id WHERE sm.nome = 'ATIVA') AS matriculas_ativas,
(SELECT COUNT(*) FROM matriculas m JOIN status_matricula sm ON sm.status_matricula_id = m.status_matricula_id WHERE sm.nome = 'CONCLUIDA') AS concluintes,
(SELECT COUNT(*) FROM bolsas) AS bolsas_concedidas,
(SELECT COUNT(*) FROM vinculos_talentos vt JOIN tipos_vinculo tv ON tv.tipo_vinculo_id = vt.tipo_vinculo_id WHERE tv.nome = 'ESTAGIO') AS estagios,
(SELECT COUNT(*) FROM vinculos_talentos vt JOIN tipos_vinculo tv ON tv.tipo_vinculo_id = vt.tipo_vinculo_id WHERE tv.nome = 'CONTRATACAO') AS contratacoes,
(SELECT COUNT(DISTINCT departamento_id) FROM vinculos_talentos) AS departamentos_com_talentos;

-- 7.11 O que faz a tabela vinculos_talentos?
-- Registra e rastreia a transição de alunos da escola para oportunidades corporativas dentro da Momento (ESTAGIO ou CONTRATACAO), vinculando o aluno_id a um departamento_id, ao período (data_inicio / data_fim), ao status_vinculo_id e, quando aplicável, ao funcionario_id criado na empresa.

-- 8.1 Quanto custa manter a frente educacional em comparação à operação comercial? (Faça uma análise de custo total com salários, suprimentos e despesas gerais para cada departamento.)

SELECT CASE WHEN d.educacional = 1 THEN 'Educacional' ELSE 'Comercial/Corporativo' END AS frente,
    f.moeda_salario,
    COUNT(f.funcionario_id) AS total_funcionarios,
    SUM(f.salario) AS folha_salarial
FROM funcionarios f
JOIN departamentos d ON d.departamento_id = f.departamento_id
GROUP BY frente, f.moeda_salario
ORDER BY frente, f.moeda_salario;

-- 8.2 Quais escritórios concentram equipes comerciais e quais concentram equipes da escola?

-- Apenas departamentos comerciais/corporativos (educacional = 0): Wayne Offices, Stark Tower, Sala Winter, Arkham Base, Shuri's Palace, Umbrella Corp, Campus de Lisboa, Archies Mad House, Baxter Building, House of Mystery, Daily Planet Bureau e Cape Town Studio
-- Apenas departamentos educacionais (educacional = 1): Torre de Paris, Instituto Rio, Paititi Operations, Koboa Koboa, Castelo Principal e Tokyo Lab.
-- Ambos (educacional = 0 e 1): Verstebona (2800) e Castelo Encantado (3000).

-- 8.3 A receita das vendas consegue sustentar investimentos educacionais?

-- O faturamento em vendas é de US$ 863.042,05 (ou US$ 780.061,94 apenas em vendas CONCLUIDA), o que cobre integralmente a folha em USD da frente educacional (US$ 111.300,00) e supera os custos totais de suprimentos da empresa (US$ 700.535,50). Contudo, uma análise financeira rigorosa exige converter BRL, GBP e EUR para uma mesma moeda, considerar margem/CMV e custo de oportunidade, e incluir despesas operacionais ausentes no banco.

-- 8.4 Quais cargos e departamentos são compartilhados pelas duas frentes?

-- Na base atual, nenhum cargo_nome e nenhum departamento_nome aparecem simultaneamente em educacional = 0 e educacional = 1 (os cargos e departamentos da escola são específicos da frente educacional, embora Recursos Humanos exista em dois departamentos comerciais distintos, IDs 3 e 4).

-- 8.5 Como a expansão internacional afeta vendas, equipes e o projeto educacional?

-- Amplia o alcance geográfico e multicultural (escritórios e países reais e fantásticos), mas introduz complexidade de moedas (USD, BRL, EUR, GBP) na folha salarial e nas compras/fornecedores, além de exigir padronização de formatos (datas, separadores decimais e canais) na integração de vendas.

-- 9.1 Crie um relatório mostrando cada departamento com: nome do departamento, número de funcionários, salário total e média salarial.

SELECT d.departamento_nome,
    COUNT(f.funcionario_id) AS numero_funcionarios,
    COALESCE(SUM(f.salario), 0) AS salario_total,
    ROUND(COALESCE(AVG(f.salario), 0), 2) AS media_salarial
FROM departamentos d
LEFT JOIN funcionarios f ON f.departamento_id = d.departamento_id
GROUP BY d.departamento_id, d.departamento_nome
ORDER BY d.departamento_id;

-- 9.2 Liste os 3 cargos mais comuns na empresa e quantos funcionários ocupam cada cargo.

SELECT c.cargo_nome, COUNT(f.funcionario_id) AS total_funcionarios
FROM cargos c
JOIN funcionarios f ON f.cargo_id = c.cargo_id
GROUP BY c.cargo_id, c.cargo_nome
ORDER BY total_funcionarios DESC, c.cargo_nome ASC
LIMIT 3;

-- 9.3 Encontre todos os funcionários que ganham acima da média salarial de seus respectivos departamentos.

SELECT f.funcionario_id, CONCAT(f.primeiro_nome, ' ', f.sobrenome) AS funcionario,
    d.departamento_nome, f.salario, f.moeda_salario
FROM funcionarios f
JOIN departamentos d ON d.departamento_id = f.departamento_id
WHERE f.salario > (
SELECT AVG(f2.salario)
FROM funcionarios f2
WHERE f2.departamento_id = f.departamento_id
)
ORDER BY d.departamento_nome, f.salario DESC;

-- 9.4 Calcule a taxa de crescimento da empresa por ano (quantos funcionários foram contratados a cada ano).

SELECT YEAR(data_contratacao) AS ano, COUNT(*) AS contratacoes
FROM funcionarios
GROUP BY YEAR(data_contratacao)
ORDER BY ano;

-- 9.5 Crie um ranking dos vendedores, mostrando: nome do vendedor, número de vendas realizadas e receita total gerada.

SELECT p.produto_id, p.sku, p.produto_nome, COUNT(DISTINCT v.funcionario_id) AS qtd_vendedores
FROM itens_venda i
JOIN vendas v ON v.venda_id = i.venda_id
JOIN produtos p ON p.produto_id = i.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
HAVING COUNT(DISTINCT v.funcionario_id) = 1;

-- 9.6 Encontre os produtos que foram vendidos por apenas um vendedor.

SELECT p.produto_id, p.sku, p.produto_nome, COUNT(DISTINCT v.funcionario_id) AS qtd_vendedores
FROM itens_venda i
JOIN vendas v ON v.venda_id = i.venda_id
JOIN produtos p ON p.produto_id = i.produto_id
GROUP BY p.produto_id, p.sku, p.produto_nome
HAVING COUNT(DISTINCT v.funcionario_id) = 1;