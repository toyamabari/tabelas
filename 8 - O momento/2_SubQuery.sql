
-- Selecionando dados através de uma subconsulta

SELECT funcionarios.primeiro_nome, funcionarios.sobrenome
FROM funcionarios 
WHERE cargo_id = 
    (SELECT cargo_id
     FROM cargos
     WHERE cargo_nome = 'Contador');