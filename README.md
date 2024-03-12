# NFTREASURE community

Welcome to the NFTREASURE community website, an **unofficial** fan-made project that showcases projects built by NFTREASURE community members.

**DISCLAIMER:** _This project is in no-way officially endorsed or affiliated with [NFTreasure](https://nftreasure.com/) and is purely a fan-made project._

## Contributing

Contributions are welcome and encouraged! 🥳

## Links

- [Staging](https://staging.nftreasure.community)
- [Production](https://nftreasure.community)

## Development

Local development instructions for working with this repository.

- Ensure the submodules are up-to-date

```bash
# First time setup
git submodule update --init --recursive

# Future updates
git submodule update --recursive --remote
```

- Install the dependencies

```bash
npm install

go mod download -x

hugo mod clean
hugo mod tidy
hugo mod graph
```

- Run your own local instance using [hugo](https://gohugo.io)

```bash
hugo server --environment development
```

- Browse to the site running on `localhost`

```bash
open http://localhost:1313/
```

## Updating

- To update dependencies

```bash
# Update development dependencies
npm update --save-dev

# Test...

# Update production dependencies
npm update --save-prod

# Update Workers dependencies
npm --prefix workers-site update --save-dev
npm --prefix workers-site update --save-prod

# Update Go
hugo mod clean
hugo mod get -u
hugo mod tidy
hugo mod graph
```

## CI

### GitHub Actions

There is an included workflow for Cloudflare Pages that will deploy the site.

## Theme

The official documentation for this theme (Phantom) can be found at [gethugothemes](https://docs.gethugothemes.com/phantom).
