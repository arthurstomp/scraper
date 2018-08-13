# Scraper :bug:

![ruby version][ruby_version_badge]

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
      "text":,
      "author":,
      "author_about":
      "tags": ["thinking", "deep-thoughts"]
    }
  ]
}
```

* `400` - Tag não encontrada.
* `404` - Falhou em obter tag.

### `POST /users`

Corpo:

```
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

```
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

## Desenvolvimento

[ruby_version_badge]: https://ruby-version-badger.herokuapp.com/github/arthurstomp/scraper 
