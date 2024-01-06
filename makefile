.PHONY: build
build:
	docker build -t sole .

.PHONY: write
write: build ## runs inline command
	docker run -v/c/Users/joeps sole /opt/minipro/minipro -p AT28C256 -w sole.bin

.PHONY: sh ## opens a shell to the shoebox docker container
sh: 
	docker-compose run -it sole 

.PHONY: down
down: ## kills the shoebox docker container
	docker-compose down

# hexdump

.PHONY: help
help: ## display this help screen
  @grep -E '^[a-z.A-Z_-]+:.?## .$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vasmPath = /c/Users/joeps/bin/vasm

all: sole

resole:
	rm -f ./sole.bin
	make sole
sole: sole.bin
sole.bin: sole.asm
	$(vasmPath)/vasm6502_oldstyle -dotdir sole.asm -Fbin -o sole.bin 

dump: sole.bin
	hexdump sole.bin

.PHONY: sole
.PHONY: dump
