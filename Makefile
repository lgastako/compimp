help:
	@cat Makefile  # or "less readme"

PYTHON=python3
PYTHON_OPTIONS=-OO
STACK_BIN_DIR=$(HOME)/.local/bin
STACK_OPTIONS=--ghc-options=-O2
STACK_PROJ=compimp
EXE=$(STACK_PROJ)-exe
HS_BIN=$(STACK_BIN_DIR)/$(EXE)

clean:
	\rm -rf .stack-work $(HS_BIN)

python:
	@$(PYTHON) qs.py

haskell: $(HS_BIN)
	@$(HS_BIN)

$(HS_BIN): src/*.hs
	stack build $(STACK_OPTIONS) $(STACK_PROJ):exe:$(EXE)
	stack install $(STACK_PROJ):exe:$(EXE)

py: python
hs: haskell
