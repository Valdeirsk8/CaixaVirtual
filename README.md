# CaixaVirtual

Api Caixa Virtual

![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-Tokyo-blue.svg)

A Documentação completa da Api pode ser encontrada [neste link](https://documenter.getpostman.com/view/636961/TVCiUn1w) [https://documenter.getpostman.com/view/636961/TVCiUn1w](https://documenter.getpostman.com/view/636961/TVCiUn1w)

**Pré-requisitos**

- Basta baixar e compilar a aplicação utiliando o Delphi Tokyo
- Há uma pasta **Modules** no diretório Raiz do projeto, esta pasta e suas subPastas precisam estar no **search path** do projeto para ele compilar

##### Obs.: Verificar o search path do atual do projeto e apontar para o diretório onde esta o projeto.

**Recursos Diponíveis na API**

- /login

### Autenticação requirida.

##### basic-auth - Usuário e Senha para Teste

###### userName: caixa - password: API

A Api irá retornar um token que deverá ser utilizado para em todos os outros recursos.

```
    Get
```

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
