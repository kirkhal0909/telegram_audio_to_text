install:
	chmod +x scripts/install.sh
	./scripts/install.sh

run:
	chmod +x scripts/run.sh
	./scripts/run.sh

stop:
	chmod +x scripts/stop.sh
	./scripts/stop.sh

console:
	irb -r ./lib/boot.rb
