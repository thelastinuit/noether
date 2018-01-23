<p align="center">
  <img src="noether.png" height="250px" />
</p>

 A place where I can drop algorithms without any worries, well, **some worries**.

## Usage
First, since I do benchmarks, you will need to install gems or remove the benchmarking code.

```bash
$ bundle
```

if you are into `docker`:
```bash
$ docker-compose run --rm console bundle
```

Once you have installed the proper gems or remove the benchmarking code, you can run it right away.
```bash
$ random_search/code.rb
```

If you stumple upon with executable issues, just make `code.rb` executable.
```bash
$ chmod +x random_search/code.rb
```

## For Dockerist
Similar as above but with `docker`. If you have your way of doing development with docker, do it, this is a simple usage example.

```bash
$ docker-compose run --rm console bundle
```

Once you have installed the proper gems or remove the benchmarking code, you can run it right away.
```bash
$ docker-compose run --rm console bash
# random_search/code.rb
```

If you stumple upon with executable issues, just make `code.rb` executable.
```bash
$ docker-compose run --rm console chmod +x random_search/code.rb
```


For any other example, you can follow the same pattern executation.
