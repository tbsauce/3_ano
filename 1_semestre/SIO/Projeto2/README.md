# SIO Projeto 2

### Descrição

Este Repositório foi criado no âmbito da cadeira de Segurança Informática e Nas Organizações, tendo como objetivo armazenar toda a informação relativa ao segundo projeto da UC: **"Bingo"**.


## Bingo

Este projeto tem como objetivo implementar um protocolo robusto que permita manipular o Bingo, um jogo de azar distribuído. Tal como apresentado a implementação do jogo consiste num **servidor** (presente no ficheiro caller.py) e **múltiplos clientes** (os jogadores) que comunicam entre si através de uma **rede**.

#### Regras do Jogo

Cada jogador recebe um único **cartão** com um conjunto aleatório de números únicos (de 1 a N). Esses mesmos **números (o baralho do jogador)** são selecionados aleatoriamente pelo servidor (caller), que gere todo o seguimento do jogo até que um dos jogadores complete uma linha do seu cartão previamente atribuído com os números selecionados até então.

<p> Na versão segura do jogo, cada jogador poderá gerar o seu próprio cartão, baralhando inicalmente os números que tiver ao seu dispôr e posteriormente depositar o mesmo na Playing Area.

<p> Um jogador <b>vence</b> o jogo assim que o seu cartão ficar completamente preenchido com os números selecionados pelo Servidor (caller), e não apenas uma só linha.

<p> Deve ainda ser tido em conta que o Caller enviará todos os números do baralho aleatoriamente misturados e <b>cada jogador receberá exatamente o mesmo baralho pela mesma ordem</b>. Posto isto podemos concluir que cada jogador, poderá encontrar os vencedores do jogo em causa : preenchendo todos os cartões com os números baralhados, seguindo a ordem dada e determinando quais dos jogadores preenchem o seu cartão com menor quantidade de números, o jogador chegará facilmente aos vencedores.

<p> Terminando o ciclo descrito, <b>todos os jogadores poderão chegar a um acordo sobre o(s) vencedor(es)</b>.

<p> É ainda relevante lembrar que nenhuma entidade tem controlo total sobre o jogo. Os jogadores podem detetar se o Caller contornou as regras impostas (por exemplo, se este não forneceu um baralho com um conjunto de números únicos para serem baralhados, aceitou uma carta inválida etc.) ou se algum jogador forneceu uma mensagem errada.




### Autores:

 - Catarina Barroqueiro  
    - 103895

 - Ricardo Covelo        
    - 102668

 - Rui Campos            
    - 103709

 - Telmo Sauce           
    - 104428
