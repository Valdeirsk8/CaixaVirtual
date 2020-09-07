# CaixaVirtual

Api Caixa Virtual

![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-Delphi.Tokyo-blue.svg)

**Recursos**

- /login

```
Metodos
    Get
```

Autenticação requirida
basic-auth
</br>Usuário e Senha para Teste
</br>userName: caixa
</br>password: API

- /usuario

```
Metodos
    Get
        Listar todos - /usuario
        Listar um - /usuario/:id_usuario
```

```
    Post
        Cadatrar um novo usuário
        exemplo de Body
        {
            "name":"Nome do Usuário",
            "username":"UserName",
            "password":"senha"
        }

        exemplo de Retorno
        {
            "id": 1,
            "username": "UserName",
            "name": "Nome do Usuário"
        }
```

```
    put
```

```
    delete
```

- /categoria
- /movimentacoes
