# Scraper :bug:

![ruby version][ruby_version_badge] [![Build Status](https://travis-ci.org/arthurstomp/scraper.svg?branch=master)](https://travis-ci.org/arthurstomp/scraper)

Esse é o scraper, um simples web crawler para extrair quotes do site [http://quotes.toscrape.com/]().

Scraper é um desafio proposto pela Inovamind.

## Funcionamento

O funcionamento do Scraper é implementado em sua maioria pelas classes `lib/quote_scraper.rb` e `lib/tag_fetcher.rb`.

A classe `QuoteScraper` é responsável por buscar a página na Internet pela tag e extrai as quotes.

A classe `TagFetcher`, utilizado pelo `TagsController`, é responsável pelo lógica de onde serão obtidas as 
quotes de uma Tag. Se ela estiver presente no banco de dados(cache) ele retornará essas quotes. Caso contrário
será utilizado o `QuoteScraper` para obter as quotes pela Internet e o resultado é persistido no banco de dados.

## API

### `GET /quotes/:tag`

Cabeçalhos:

* `Authorization` - JWT no formato `Bearer <jwt>`.

Parametros:

* `:tag` - Tag a ser pesquisada pela API. Caso ela não esteja presente no banco de dados, 
Scraper irá extrair do site.

Respostas:

* `200` 

```json
{
  "quotes": [
    {
      "text": "Something smart",
      "author": "Jhon Doe",
      "author_about": "http://quotes.toscrape.com/author/Jhon-Doe"
      "tags": ["thinking", "deep-thoughts"]
    }
  ]
}
```

* `400` - Tag não encontrada.
* `404` - Falhou em obter tag.

### `POST /users`

Corpo:

```json
{
  "user": {
    "email": "test@test.com",
    "password": "12341234"
  }
}
```

Respostas:

* `201` - Usuário criado. JWT retornado no cabeçalho `Authorization`.


### `POST /users/sign_in`

Corpo:

```json
{
  "user": {
    "email": "test@test.com",
    "password": "12341234"
  }
}
```

Respostas:

 * `200` - Usuário logado. JWT retornado no cabeçalho `Authorization`.

### `DELETE /users/sign_out`

Cabeçalhos:

* `Authorization` - JWT no formato `Bearer <jwt>`.

Respostas:

* `204` - Revoga JWT do usuário.

## Configuração

1. Crie o `config/master.key`

```bash
$ echo 3e813d4b91357d606caf8152ad1e8d82 > config/master.key
```

> Nunca publique sua master.key. Esse é somente um projeto de demonstração, não possui credenciais confidencias.

1. Componha com `docker-compose`

```bash
$ docker-compose up -d
```

## Executando testes

```bash
$ rspec spec
```

## Exemplos de uso

Usando [HTTPie](https://httpie.org/)

* Criando usuário

```bash
$ http :3000/users user:='{"email": "test@test.com", "password": "12341234"}'

HTTP/1.1 201 Created
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxOWE1OGE1Ny0wY2Y0LTQxNGUtYmNlNi02ZTJiNjA0ZjA5NWYiLCJzdWIiOiI1YjcxYzI5YTQ4NGQ1ZDAwMDE3MTQyNTAiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE1MzQxODIwNDIsImV4cCI6IjE1MzQyNjg0NDIifQ.VkroH2aAbyXJdZ2MFGvfEVxX3j13qUnOw3RUAeGyzfQ
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"472961c44b3392b1e81344d98b82dbb7"
Location: /
Transfer-Encoding: chunked
X-Request-Id: 8447a6c2-2a1f-4b5c-8a27-a453b872a0e7
X-Runtime: 0.133040

{
    "_id": {
        "$oid": "5b71c29a484d5d0001714250"
    },
    "email": "test@test.com",
    "jti": "19a58a57-0cf4-414e-bce6-6e2b604f095f"
}
```

* Logando usuário

```bash
$ http :3000/users/sign_in user:='{"email": "test@test.com", "password": "12341234"}'

HTTP/1.1 201 Created
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxOWE1OGE1Ny0wY2Y0LTQxNGUtYmNlNi02ZTJiNjA0ZjA5NWYiLCJzdWIiOiI1YjcxYzI5YTQ4NGQ1ZDAwMDE3MTQyNTAiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE1MzQxODIxNDUsImV4cCI6IjE1MzQyNjg1NDUifQ.6GxIZxS8Rz4e757ejPKwgLNbguVj4Ziy4UtWPHDh0o0
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"472961c44b3392b1e81344d98b82dbb7"
Location: /
Transfer-Encoding: chunked
X-Request-Id: dc0dd70c-c63c-4b62-b777-35cad0c0b4bb
X-Runtime: 0.127408

{
    "_id": {
        "$oid": "5b71c29a484d5d0001714250"
    },
    "email": "test@test.com",
    "jti": "19a58a57-0cf4-414e-bce6-6e2b604f095f"
}

```

* Buscando quotes

```bash
$ http :3000/quotes/thinking Authorization:"Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxOWE1OGE1Ny0wY2Y0LTQxNGUtYmNlNi02ZTJiNjA0ZjA5NWYiLCJzdWIiOiI1YjcxYzI5YTQ4NGQ1ZDAwMDE3MTQyNTAiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE1MzQxODIxNDUsImV4cCI6IjE1MzQyNjg1NDUifQ.6GxIZxS8Rz4e757ejPKwgLNbguVj4Ziy4UtWPHDh0o0"

HTTP/1.1 200 OK
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json; charset=utf-8
ETag: W/"3e3842bfdb20e9de2767d532cf47f2d7"
Transfer-Encoding: chunked
X-Request-Id: a078e327-56ce-43c2-830e-76f0e3fec210
X-Runtime: 1.748024

{
    "quotes": [
        {
            "author": "Albert Einstein",
            "author_about": "http://quotes.toscrape.com/author/Albert-Einstein",
            "tags": [
                "change",
                "deep-thoughts",
                "thinking",
                "world"
            ],
            "text": "“The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.”"
        },
        {
            "author": "Terry Pratchett",
            "author_about": "http://quotes.toscrape.com/author/Terry-Pratchett",
            "tags": [
                "humor",
                "open-mind",
                "thinking"
            ],
            "text": "“The trouble with having an open mind, of course, is that people will insist on coming along and trying to put things in it.”"
        }
    ]
}
```

[ruby_version_badge]: https://ruby-version-badger.herokuapp.com/github/arthurstomp/scraper 
[travis_badge]: https://travis-ci.org/arthurstomp/scraper
