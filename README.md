# Synopsis

elm-calculator is a toy project to explore the exciting world of monadic parser combinators.


# Installation

```bash
# install elm
npm install elm -g

# get and run this code
git clone https://github.com/akobler/elm-calculator.git
cd elm-calculator
elm-package install
elm-reactor
# now point your browser to: https://localhost:8000 and open src/Main.elm

# run unit tests (no coverage, only to demonstrate unit testing)
cd tests && elm-package install && cd ..
elm-test
```

# Disclaimer

This is a toy project. Consider [elm-combine](https://github.com/Bogdanp/elm-combine) for more serious business.


# Ressources

The main sources of inspiration, ideas, examples and a lot of fun:
* https://fsharpforfunandprofit.com/parser/
* other great articles on https://fsharpforfunandprofit.com
* https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/

Many thanks!


# License

Use, learn and build awesome stuff. (MIT)