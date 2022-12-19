-- ----------------------------------------------------------------------------
-- BD 2022/2023 - etapa E2 - bd32 
--João Leal,        56922, TP14 33%
--Jorge Ferreira,   58951, TP13 33%
--Mariana Valente,  55945, TP13 33%
-- ----------------------------------------------------------------------------

-- 1. Nic e nome dos utentes internados em quartos, o seu género, distrito e país. O
-- resultado deve vir ordenado pelo pais e distrito de forma ascendente, e pelo nic de
-- forma descendente. Nota: pretende-se uma interrogação com apenas um SELECT,
-- ou seja, sem sub-interrogações.


SELECT nic, nome, genero, distrito, pais
    FROM pessoa, internado  
    ORDER BY nic DESC, pais ASC, distrito ASC


-- 2. Cedula, nome, e país dos médicos que são especialistas em pelo menos uma das
-- especialidades: cardiologia e otorrino, ou que tenham um nome contendo a letra
-- ‘e’ e tenham começado a sua actividade médica depois do ano de início da
-- pandemia C19 (2019). Nota: pode usar construtores de conjuntos.

SELECT m.cedula, p.nome, p.pais, esp.especialidade
  FROM medico m, pessoa p, especialista esp
 WHERE m.nic = p.nic
   AND esp.medico = m.nic
   AND esp.especialidade = "cardiologia" OR esp.especialidade = "otorrino"
    OR m.mome LIKE [Ee%]
   AND m.ano > 2019;

-- 3. Nic, nome e país dos utentes internados em enfermaria mais de 7 dias, que
-- receberam visitas solidárias de pelo menos uma pessoa de um país diferente do
-- seu e um nome com 5 letras, terminado por ‘o’.

SELECT utente.nic, utente.nome, utente.pais
FROM pessoa utente, pessoa visitante, visita v, internado i
WHERE utente.nic = i.utente AND 
      (visitante.nic = v.visitante AND v.tipo = 'S' AND v.intern = i.numero) AND
      visitante.pais != utente.pais AND
      visitante.nome like '%o' AND LENGTH(visitante.nome) = 5

-- 4. Nome e ano (de início) dos médicos que iniciaram actividade depois do ano da
-- pandemia de Gripe A - H1N1 (2009), e que nunca foram responsáveis por
-- internamentos em quarto que tenham durado mais de 21 dias.

SELECT medico_nome, ano, dias   
    FROM medico, pessoa, internado
    WHERE ano>2009
    AND dias<21
--

-- 5. Ano de actividade, nic, cedula e nome dos médicos que tenham sido responsáveis
-- por todos os internamentos de utentes do Mónaco (MC) realizados em enfermaria,
-- por mais de 100 dias, no ano em que iniciaram a sua actividade. Nota: o resultado
-- deve vir ordenado pelo ano e pelo nome de forma ascendente.

SELECT m.ano, m.nic, m.cedula, p.nome
  FROM medico m, pessoa p, internado i, pessoa pi
 WHERE m.nic = p.nic
   AND i.medico = m.nic
   AND i.utente = pi.nic
   AND pi.pais = "Mónaco"
   AND i.dias > 100
   AND i.ano = m.ano
   AND i.tipo = "E"
 ORDER BY m.ano ASC, p.nome ASC;
   
-- 6. Número de internamentos da responsabilidade de cada médico (indicando nic e
-- nome) em cada especialidade. Nota: ordene o resultado pela especialidade de
-- forma ascendente e pelo nome do médico de forma descendente.

SELECT e.medico, p.nome, esp.nome especialidade, COUNT(p.nome) numero_internamentos
FROM internado i, medico m, especialista e, pessoa p, especialidade esp
WHERE i.medico = m.nic AND
      m.nic = e.medico AND
      e.medico = p.nic AND
      esp.nome = i.especialidade
GROUP BY e.medico
ORDER BY esp.nome ASC, p.nome DESC

-- 7. Cédula, nome e nacionalidade dos médicos que foram responsáveis (como
-- especialidade/actividade principal), por mais internamentos em quarto, em cada
-- uma das especialidades existentes. Notas: em caso de empate, devem ser
-- mostrados todos os médicos em causa.

SELECT especialidade.especialidade, medico.nic, pessoa.nome, 
COUNT(internado.medico) AS n_internamentos
    FROM especialidade 
        INNER JOIN medico ON especialista.medico = medico.nic
        INNER JOIN pessoa ON medico.nic = pessoa.nic
        INNER JOIN internado ON medico.nic = internado.medico
        GROUP BY especialista.especialidade, medico.nic, pessoa.nome
        HAVING COUNT(internado.medico) = 
            SELECT MAX(n_internamentos)
            FROM ( 
                SELECT COUNT(internado.medico) AS n_internamentos
                FROM especialista   
                INNER JOIN medico ON especialista.medico = medico.nic   
                INNER JOIN internado ON medico.nic = internado.medico
                GROUP BY especialista.especialidade, medico.nic
            ) 
            

-- 8. Nome, ano de nascimento e nacionalidade das pessoas que nasceram depois do
-- ano inicial da Operação Nariz Vermelho (2002) e visitaram menos de 5 internados
-- distintos, mesmo que não tenham visitado nenhum. Pretende-se uma interrogação
-- sem sub-interrogações: apenas com um SELECT.

SELECT p.nome, p.ano, p.pais
  FROM pessoa p, visita v
 WHERE p.ano > 2002
   AND v.visitante = p.nic
 GROUP BY v.utente
   AND IFNULL(COUNT(p.nic), 0) < 5;

-- 9. Para cada país e região de origem, o nic e nome da pessoa que realizou mais visitas
-- solidárias, indicando o número de visitas, e a maior e menor duração dos
-- internamentos visitados. Nota: devem ser mostrados todos os visitantes que
-- empatarem neste total de visitas.

SELECT visitante.pais, visitante.distrito, visitante.nic, visitante.nome, MIN(i.dias) min_tempo, MAX(i.dias) max_tempo, COUNT(v.visitante)
FROM pessoa visitante, pessoa utente, internado i, visita v
WHERE v.visitante = visitante.nic AND
      v.tipo = "S" AND
      v.intern = i.numero AND
      i.utente = v.utente AND
GROUP BY v.visitante
HAVING COUNT(v.visitante) >= ALL