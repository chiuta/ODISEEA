# ODISEEA

[English](README.md) · [Română](README.ro.md) · [Français](README.fr.md) · [Italiano](README.it.md) · [Español](README.es.md) · **Português** · [Deutsch](README.de.md) · [Magyar](README.hu.md)

Versão: 1.1 · Última atualização: 15 de novembro de 2026

Documentário de cerca de 4,5 minutos sobre as **Voyager 1 e 2**, num único ficheiro HTML que corre localmente no navegador, sem servidor e sem instalação.

## Funcionalidades

- Carrega imagens públicas da NASA/JPL (e da Wikimedia Commons, domínio público), com a opção «a sua imagem» para cada cena.
- Cenas geradas de forma processual na GPU (WebGL): planetas, sonda, foguetão, antena da DSN, Disco de Ouro, heliosfera, Pale Blue Dot. O mapa de profundidade vem da geometria, pelo que o efeito 3D é correto.
- Exportação **2D**, **3D SBS metade** (1920×1080) e **3D SBS completo** (3840×1080), além de um modo «telemóvel» para óculos VR do tipo VR BOX / 3DBOX.
- Música ambiente gerada no navegador; narração opcional (síntese de voz em direto, não gravável) ou o seu próprio ficheiro de áudio.
- Totalmente traduzido para 8 idiomas: English, Română, Français, Italiano, Español, Português, Deutsch, Magyar (interface, narração, legendas, créditos). Escolha o idioma no seletor no canto superior direito.

## Utilização

Abra `ODISEEA.html` no Chrome (recomendado), prima «Carregar as imagens» ou diretamente «Reproduzir». Mantenha o separador em primeiro plano durante a exportação.

## Limitações conhecidas

- As imagens da NASA só carregam se o navegador tiver acesso à rede (CORS).
- As texturas fractais são processuais, não fotográficas; o fundo estelar acrescentado às fotos reais é artístico e pode ser desativado.
- A profundidade das fotos reais é estimada a partir do brilho.
- Não testado em óculos reais; a exportação 3840×1080 é pesada. Um `.mp4` com vp9 pode exigir conversão para H.264.
- A voz sintética usa as vozes do navegador; se não existir nenhuma para o idioma escolhido, fica desligada.

`fx.glsl` é o código-fonte do shader fractal; já está incluído em `ODISEEA.html`.

## Créditos

Imagens: NASA/JPL-Caltech, conforme o crédito de cada imagem (descarregável a partir da aplicação). Verifique os créditos antes de publicar.

Licença do código: MIT.
