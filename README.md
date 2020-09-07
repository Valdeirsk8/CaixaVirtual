# CaixaVirtual

Api Caixa Virtual

![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-Tokyo-blue.svg)

A Documentação completa da Api pode ser encontrada [neste link](https://documenter.getpostman.com/view/636961/TVCiUn1w) [https://documenter.getpostman.com/view/636961/TVCiUn1w](https://documenter.getpostman.com/view/636961/TVCiUn1w)

**Pré-requisitos - Build**

- Basta baixar e compilar a aplicação utiliando o Delphi Tokyo
- Há uma pasta **Modules** no diretório Raiz do projeto, esta pasta e suas subPastas precisam estar no **search path** do projeto para ele compilar

##### Obs.: Verificar o search path do atual do projeto e apontar para o diretório onde esta o projeto.

**Pré-requisitos - Execução**

- Firebird 3.0 Instaldo e em execução
- Junto ao .exe do servidor há um aquivo .ini nele é necessário configurar
  - O Caminho do banco de dados
  - o IP do servidor ondo esta o banco de dados
  - A porta onde o Firebird esta rodando
    ```
    [BANCO]
    DATABASE=C:\Users\Documents\CaixaVirtual\DataBase\DBCAIXAVIRTUAL.FDB
    SERVER=127.0.0.1
    PORT=3050
    ```
- A Aplicação é Console basta que ele estaja aberta para que respondas as requisiçãoes
  - A Porta padrão da aplicação é 9000

###### ps.: não foi criado recurso para alterar a porta da aplicação.

###### ps2.: por questão de comodidade o usuário e senha padrão do firebird foram mantidos: Usuário: SYSDBA - Senha: masterkey

**Rota padrão para acessar a aplicação**

```
    http://localhost:9000/[recurso]
```

**Recursos Diponíveis na API**

- /login

```
    Get
```

### Autenticação requirida.

##### basic-auth - Usuário e Senha para Teste

###### userName: caixa - password: API

A Api irá retornar um token que deverá ser utilizado para em todos os outros recursos.

- /usuario

```
    Get
        Listar todos - /usuario
        Listar um - /usuario/:id_usuario
```

```
    Post
        /usuario
```

```
    put
        /usuario/{id_usuario}
```

```
    delete
        /usuario/{id_usuario}
```

- /categoria

```
    Get
        Listar todas - /categoria
        Listar uma - /categoria/:id_categoria
```

```
    Post
        /categoria
```

```
    put
        /categoria/{id_categoria}
```

```
    delete
        /categoria/{id_categoria}
```

- /movimentacoes

```
    Get
        Mostrar o Saldo - /movimentacoes/Saldo
        Mostra uma movimentação - /movimentacoes/{:id_movimentacao}
```

```
    Post
        /movimentacao
```

```
    put
        /movimentacao/{id_movimentacao}
```

```
    delete
        /movimentacao/{id_movimentacao}
```
