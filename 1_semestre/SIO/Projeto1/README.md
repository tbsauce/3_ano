# SIO Projeto 1

## eHealth Corp

Este Repositório foi criado no âmbito da cadeira de Segurança Informática e Nas Organizações, tendo como objetivo armazenar toda a informação relativa ao primeiro projeto da UC: **"eHealth Corp"**.

### Objetivo: 

 Desenvolver uma página web simples para uma clínica de saúde.
 
 Esta deve sofrer de um conjunto específico de pontos fracos, que não são óbvios para o usuário casual, mas podem ser usados para comprometer a aplicação, o sistema ou até a segurança do usuário.

### Members

 + Catarina Barroqueiro  - 103895

 + Ricardo Covelo        - 102668

 + Rui Campos            - 103709

 + Telmo Sauce           - 104428

### Vulnerabilidades Implementadas:

>
> + **CWE 89** : SQL Injection
> + **CWE 79** : Cross-Site Scripting
> + **CWE 256** : Armazenamento de uma password em texto simples
> + **CWE 620** : Password sem verificação
> + **CWE 20** : Inserção de dados sem validação
> + **CWE 311** : Dados sensíveis armazenados sem encriptação
> + **CWE 549** : Falha na máscara da password 
>

## How to start

### Install

##### Flask

[flask.palletsprojects.com/installation](https://flask.palletsprojects.com/en/2.2.x/installation/)

```
sudo pip install Flask
```

##### Cryptography

```
sudo apt install python3-pip

sudo pip install cryptography==3.1.1
```

### Run

```
flask --app app.py --debug run
```
or 

```
flask run
```
